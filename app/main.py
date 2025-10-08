"""
 Backend - FastAPI 메인 애플리케이션
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

# 환경 변수 로드
load_dotenv()

# FastAPI 앱 생성
app = FastAPI(
    title="BF API",
    description="뷰티 퍼스널 어시스턴트 - AI 피부 분석 서비스",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS 설정
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API 라우터 등록
from app.api.v1 import analysis, health

app.include_router(analysis.router, prefix="/api/v1")
app.include_router(health.router, prefix="/api/v1")

# guides 라우터가 있다면 추가
try:
    from app.api.v1 import guides
    app.include_router(guides.router, prefix="/api/v1")
except ImportError:
    pass


# @app.get("/", tags=["루트"])
# async def root():
#     """루트 엔드포인트"""
#     return {
#         "service": "VUPA API",
#         "version": "1.0.0",
#         "status": "running",
#         "endpoints": {
#             "comprehensive_analysis": "/api/v1/analysis/comprehensive",
#             "personal_color": "/api/v1/analysis/personal-color",
#             "sensitivity": "/api/v1/analysis/sensitivity",
#             "health": "/api/v1/analysis/health",
#             "docs": "/docs",
#             "redoc": "/redoc"
#         },
#         "description": "AI 기반 퍼스널 컬러 & 피부 분석 서비스"
#     }


@app.get("/health", tags=["상태 확인"])
async def health():
    """전체 서비스 상태 확인"""
    import os
    
    return {
        "status": "healthy",
        "environment": os.getenv("ENVIRONMENT", "development"),
        "openai_configured": os.getenv("OPENAI_API_KEY") is not None,
        "models": {
            "colorinsight": os.path.exists("./Colorinsight-main"),
            "nia": os.path.exists("./NIA/checkpoints")
        }
    }


if __name__ == "__main__":
    import uvicorn
    
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", 8000))
    
    uvicorn.run(
        "app.main:app",
        host=host,
        port=port,
        reload=True
    )