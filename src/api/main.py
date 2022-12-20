import google.cloud.logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes.anime.router import router as anime_router

app = FastAPI()

app.include_router(anime_router)

# Instantiates a client
client = google.cloud.logging.Client()

# Retrieves a Cloud Logging handler based on the environment
# you're running in and integrates the handler with the
# Python logging module. By default, this captures all logs
# at INFO level and higher
client.setup_logging()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*", "Access-Control-Allow-Origin"],
)
