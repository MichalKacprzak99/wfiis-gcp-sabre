from sqlalchemy import Column, Integer, Text

from database import Base


# alembic revision --autogenerate
# alembic upgrade head

class Anime(Base):
    __tablename__ = "animes"

    id = Column('id', Integer, primary_key=True)
    name = Column(Text)
    last_episode = Column(Integer)
    website_url = Column(Text)
