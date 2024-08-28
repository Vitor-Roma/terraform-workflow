#############################

FROM public.ecr.aws/lambda/python:3.12 AS base

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/src
WORKDIR /src
RUN pip install poetry==1.7.1
RUN poetry config virtualenvs.create false
COPY . .

FROM base AS dependencies
RUN poetry install --only main

FROM base AS development
RUN poetry install

CMD [ "src.main.handler" ]

