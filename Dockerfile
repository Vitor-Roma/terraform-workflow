FROM python:3.12.1


WORKDIR /usr/src/app
COPY ./ /usr/src/app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# install dependencies
RUN pip install --upgrade pip --user

EXPOSE 8000
