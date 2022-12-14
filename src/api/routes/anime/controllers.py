import datetime
import logging
import os
from typing import List, Optional

import requests
from bs4 import BeautifulSoup
from dateutil.parser import parse
from fastapi import HTTPException
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from sqlalchemy.orm import Session

import db_models
from schemas import anime as anime_schemas

SENDGRID_API_KEY = os.environ.get('SENDGRID_API_KEY')

sendgrid_api_client = SendGridAPIClient(SENDGRID_API_KEY)


def get_all_animes(db: Session):
    return db.query(db_models.Anime).all()


def create_anime(anime: anime_schemas.AnimeBase, db: Session):
    db_anime = db_models.Anime(**anime.dict())
    db.add(db_anime)
    db.commit()
    db.refresh(db_anime)
    return db_anime


def get_anime(anime_id: int, db):
    db_anime: Optional[db_models.Anime] = db.query(db_models.Anime).get(anime_id)
    if not db_anime:
        raise HTTPException(status_code=404)

    return db_anime


def update_anime(anime_id: int, anime: anime_schemas.AnimeUpdate, db: Session):
    db_anime: db_models.Anime = db.query(db_models.Anime).get(anime_id)
    if not db_anime:
        raise HTTPException(status_code=404)

    db.query(db_models.Anime).filter(
        db_models.Anime.id == db_anime.id
    ).update(anime.dict(exclude_unset=True))

    db.commit()
    db.refresh(db_anime)
    return db_anime


def delete_anime(anime_id: int, db: Session):
    db_anime: db_models.Anime = db.query(db_models.Anime).get(anime_id)
    if not db_anime:
        raise HTTPException(status_code=404)
    db.query(db_models.Anime).filter(db_models.Anime.id == anime_id).delete()
    db.commit()


def monitor_animes(db: Session):
    db_animes: List[db_models.Anime] = db.query(db_models.Anime).all()

    if not db_animes:
        logging.info("No anime added to monitor")
        return True

    anime_information: List[str] = []
    today = datetime.datetime.today()

    for db_anime in db_animes:

        next_episode = (db_anime.last_episode or 0) + 1

        req = requests.get(db_anime.website_url)

        bs = BeautifulSoup(req.content, 'html.parser')

        table = bs.find(name='table', attrs={"class": "lista"})
        rows = table.findAll(lambda tag: tag.name == 'tr')
        rows = [r for r in rows if db_anime.name in r.find(name='td').text]

        if len(rows) > next_episode:
            db_anime.last_episode = len(rows)
            last_episode = rows[0]
            last_episode_data_text = last_episode.find(name='td', attrs={"class": "lista_td"}).text
            last_episode_data = parse(last_episode_data_text)
            if last_episode_data >= today:
                anime_information.append(f'New episode no. {db_anime.last_episode} '
                                         f'for anime: {db_anime.name} will be released at {last_episode_data_text}')
                continue
            last_episode_title = last_episode.find(name='td').text
            anime_information.append(f'New episode no. {db_anime.last_episode} for anime: {db_anime.name} '
                                     f'today with title {last_episode_title}')
            logging.info(f"New episode for {db_anime.name}, last registered episode {db_anime.last_episode}")
        else:
            anime_information.append(f'No new episode for anime: {db_anime.name}')
            logging.info(f"No new episode no. {db_anime.last_episode} for {db_anime.name}")

    email_message = "\n".join(anime_information)
    message = Mail(
        from_email='michal.kacprzak999@gmail.com',
        to_emails='michal.kacprzak999@gmail.com',
        subject='Anime Tracker',
        plain_text_content=email_message
    )
    try:
        response = sendgrid_api_client.send(message)
        logging.info("Successfully send email")
    except Exception as e:
        logging.exception(e)

    db.commit()
    return True
