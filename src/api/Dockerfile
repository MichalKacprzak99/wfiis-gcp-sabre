FROM tiangolo/uvicorn-gunicorn:python3.8

ENV PYTHONUNBUFFERED True

WORKDIR /app

ADD requirements.txt .

RUN apt-get update
RUN apt-get install -y default-libmysqlclient-dev
RUN pip3 install -r requirements.txt


COPY . .

ENV PORT 8000

CMD exec uvicorn main:app --host 0.0.0.0 --port $PORT
