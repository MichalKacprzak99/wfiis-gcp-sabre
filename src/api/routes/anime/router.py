import uuid
from typing import List

from fastapi import APIRouter, Depends

from database import get_db
from schemas import anime as anime_schema
from sqlalchemy.orm import Session
from . import controllers

router = APIRouter(prefix='/animes', tags=["Animes"])


@router.post("/",
             response_model=anime_schema.Anime,
             operation_id='create_anime',
             )
def create_anime(anime: anime_schema.AnimeBase, db: Session = Depends(get_db)):
    return controllers.create_anime(anime, db)


@router.get("/",
            response_model=List[anime_schema.Anime],
            operation_id='get_all_animes',
            )
def get_all_animes(db: Session = Depends(get_db)):
    return controllers.get_all_animes(db)


@router.get("/{anime_id}",
            response_model=anime_schema.Anime,
            operation_id='get_anime',
            )
def get_anime(anime_id: int, db: Session = Depends(get_db)):
    return controllers.get_anime(anime_id, db)


@router.put("/{anime_id}/",
            response_model=anime_schema.AnimeUpdate,
            operation_id='update_anime',
            )
def update_anime(anime_id: int, anime: anime_schema.AnimeUpdate,
                 db: Session = Depends(get_db)):
    return controllers.update_anime(anime_id, anime, db)


@router.delete("/{anime_id}/",
               operation_id='delete_anime',
               )
def delete_anime(anime_id: int, db: Session = Depends(get_db)):
    return controllers.delete_anime(anime_id, db)


@router.post("/monitor/", operation_id="monitor")
def monitor_animes(db: Session = Depends(get_db)):
    controllers.monitor_animes(db)
