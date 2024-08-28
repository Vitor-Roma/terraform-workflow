#############################

FROM python:3.12.1

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/src
WORKDIR /src
RUN pip install poetry==1.7.1
RUN poetry config virtualenvs.create false
COPY . .

RUN poetry install --only main


CMD [ "main.handler" ]
