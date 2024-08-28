from fastapi import APIRouter

from src.router import healthcheck


def setup_router():
    router = APIRouter()
    router.include_router(healthcheck.setup(), prefix="", tags=["Health Check"])
    return router
