from fastapi import APIRouter
import logging


def setup():
    router = APIRouter()

    @router.get("/healthcheck", status_code=200)
    def healthcheck():
        logging.info("Healthy")
        return "Healthy"

    @router.get("/test", status_code=400)
    def healthcheck():
        logging.error("Error")
        return "Error"

    return router
