from fastapi import APIRouter
from fastapi.responses import Response
from starlette import status


def setup():
    router = APIRouter()

    @router.get("/healthcheck")
    def healthcheck():
        return Response(
            status_code=status.HTTP_200_OK,
            content="Healthy")

    return router
