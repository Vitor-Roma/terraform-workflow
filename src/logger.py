from aws_lambda_powertools import Logger

from src.config import settings

logging = Logger(service=settings["APP_NAME"], level=settings["LOG_LEVEL"])
