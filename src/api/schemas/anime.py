import uuid
from typing import Optional

from pydantic import HttpUrl, validator

from .model import Model


class AnimeBase(Model):
    name: str
    website_url: HttpUrl
    last_episode: Optional[int]

    @validator('website_url')
    def passwords_match(cls, website_url):
        WEBSITE_DOMAIN = 'wbijam.pl'
        if WEBSITE_DOMAIN not in website_url:
            raise ValueError(f"{website_url} not from {WEBSITE_DOMAIN} domain")
        return website_url


class Anime(AnimeBase):
    id: int


class AnimeUpdate(Model):
    name: Optional[str]
    website_url: Optional[HttpUrl]
    last_episode: Optional[int]
