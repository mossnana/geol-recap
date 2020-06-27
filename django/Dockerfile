FROM python:3.8.0-alpine

ENV PYTHONUNBUFFERED 1

RUN mkdir /webapp

WORKDIR /webapp

COPY requirements.txt /webapp/

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

RUN pip install --upgrade pip \
  && pip install -r requirements.txt

COPY . /webapp/
