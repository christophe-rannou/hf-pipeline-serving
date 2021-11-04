FROM python:3.8-slim-buster

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install -r requirements.txt

RUN ["transformers-cli", "download", "distilbert-base-cased-distilled-squad"]

COPY main.py ./
RUN python main.py

CMD [ "bentoml", "serve", "MyPipelineService:latest" ]
