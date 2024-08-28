from fastapi import APIRouter
from fastapi.responses import Response
from starlette import status


def setup():
    router = APIRouter()

    @router.get("/healthcheck", status_code=200)
    def healthcheck():
        return "Healthy"

    return router
