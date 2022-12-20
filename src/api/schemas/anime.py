import uuid
from typing import Optional

from pydantic import HttpUrl, validator, Field

from .model import Model

ANIME_WEBSITE_DOMAIN = 'wbijam.pl'


class AnimeBase(Model):
    name: str
    website_url: HttpUrl = Field(description=f"Must be URL from {ANIME_WEBSITE_DOMAIN!r} domain")
    last_episode: Optional[int] = 0

    @validator('website_url')
    def passwords_match(cls, website_url):
        if ANIME_WEBSITE_DOMAIN not in website_url:
            raise ValueError(f"{website_url} not from {ANIME_WEBSITE_DOMAIN!r} domain")
        return website_url


class Anime(AnimeBase):
    id: int


class AnimeUpdate(Model):
    name: Optional[str]
    website_url: Optional[HttpUrl]
    last_episode: Optional[int]
