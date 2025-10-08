"""
bf Backend - FastAPI 메인 애플리케이션
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
    version="1.0.0"
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 프로덕션에서는 특정 도메인만 허용
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API 라우터 등록
from app.api import analysis

app.include_router(analysis.router)


# @app.get("/")
# async def root():
#     """루트 엔드포인트"""
#     return {
#         "service": "BF API",
#         "version": "1.0.0",
#         "status": "running",
#         "endpoints": {
#             "comprehensive_analysis": "/api/analysis/comprehensive",
#             "personal_color": "/api/analysis/personal-color",
#             "sensitivity": "/api/analysis/sensitivity",
#             "health": "/api/analysis/health",
#             "docs": "/docs"
#         }
#     }

# 🔥 API 정보를 /api로 이동
@app.get("/api")
async def api_info():
    """API 정보"""
    return {
        "service": "BF API",
        "version": "1.0.0",
        "status": "running",
        "endpoints": {
            "comprehensive_analysis": "/api/v1/analysis/comprehensive",
            "personal_color": "/api/v1/analysis/personal-color",
            "sensitivity": "/api/v1/analysis/sensitivity",
            "health": "/api/v1/analysis/health",
            "docs": "/docs",
            "redoc": "/redoc"
        },
        "description": "AI 기반 퍼스널 컬러 & 피부 분석 서비스",
        "gradio_ui": "/"  # 🔥 Gradio UI는 루트에
    }


@app.get("/health")
async def health():
    """전체 서비스 상태 확인"""
    return {
        "status": "healthy",
        "openai_configured": os.getenv('OPENAI_API_KEY') is not None,
        "models": {
            "colorinsight": os.path.exists('./Colorinsight-main'),
            "nia": os.path.exists('./NIA/checkpoints')
        }
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )

