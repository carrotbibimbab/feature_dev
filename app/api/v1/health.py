"""
헬스 체크 API
"""

from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter(tags=["Health"])


@router.get("/health")
def health_check():
    """서버 상태 확인"""
    return JSONResponse({
        "status": "healthy",
        "services": {
            "colorinsight": "ready",
            "nia": "ready",
            "supabase": "connected"
        }
    })