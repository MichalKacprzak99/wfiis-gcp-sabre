from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
import google.cloud.logging
from pydantic.error_wrappers import ErrorWrapper, ValidationError
from starlette.requests import Request
from starlette.responses import Response

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


@app.exception_handler(RequestValidationError)
async def http_exception_accept_handler(request: Request, exc: RequestValidationError) -> Response:
    raw_errors = exc.raw_errors
    error_wrapper: ErrorWrapper = raw_errors[0]
    validation_error: ValidationError = error_wrapper.exc
    overwritten_errors = validation_error.errors()
    return JSONResponse(
        status_code=422,
        content={"detail": jsonable_encoder(overwritten_errors)},
    )


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*", "Access-Control-Allow-Origin"],
)
