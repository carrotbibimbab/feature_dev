"""가이드 관련 API 엔드포인트"""
from fastapi import APIRouter

router = APIRouter(tags=["guides"])

@router.get("/guides")
async def get_guides():
    """가이드 목록 조회"""
    return {
        "success": True,
        "message": "Guides API",
        "data": {
            "guides": [],
            "total": 0
        }
    }