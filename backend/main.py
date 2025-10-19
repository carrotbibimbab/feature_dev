import os
from datetime import datetime, timedelta
from typing import Optional
import uuid

from fastapi import FastAPI, Request, HTTPException, Depends, UploadFile, File, Form, Header
from fastapi.responses import HTMLResponse, RedirectResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.templating import Jinja2Templates
from fastapi.exceptions import RequestValidationError
from starlette.middleware.sessions import SessionMiddleware
from itsdangerous import URLSafeSerializer
from dotenv import load_dotenv
from fastapi.routing import APIRoute
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
from supabase import create_client, Client

from app.services.response_formatter import ResponseFormatter

# ────────────────────────────────────────────────────────────
# Supabase
# ────────────────────────────────────────────────────────────
supabase = None
try:
    SUPABASE_URL = os.getenv("SUPABASE_URL")
    SUPABASE_KEY = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")
    if SUPABASE_URL and SUPABASE_KEY:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
except Exception:
    supabase = None

# JWT 검증 함수
async def get_current_user_from_supabase(authorization: Optional[str] = Header(None)):
    """
    Supabase JWT 토큰 검증
    """
    if not authorization:
        raise HTTPException(status_code=401, detail="Authorization header missing")
    
    try:
        # "Bearer " 제거
        token = authorization.replace("Bearer ", "")
        
        # Supabase JWT 검증
        user = supabase.auth.get_user(token)
        
        if not user or not user.user:
            raise HTTPException(status_code=401, detail="Invalid token")
        
        # 사용자 정보 반환
        return {
            "id": user.user.id,
            "email": user.user.email,
            "user_metadata": user.user.user_metadata,
        }
    
    except Exception as e:
        print(f"❌ JWT verification error: {str(e)}")
        raise HTTPException(status_code=401, detail=f"Authentication failed: {str(e)}")


# ────────────────────────────────────────────────────────────
# AI 서비스 Import
# ────────────────────────────────────────────────────────────
try:
    from app.services.ai_client import ai_client
    from app.services.storage_service import storage_service
except ImportError:
    try:
        from ai_client import ai_client  # type: ignore
        from storage_service import storage_service  # type: ignore
    except ImportError:
        ai_client = None  # type: ignore
        storage_service = None  # type: ignore
        print("⚠️  경고: AI 서비스 모듈을 찾을 수 없습니다")

# ────────────────────────────────────────────────────────────
# Env
# ────────────────────────────────────────────────────────────
try:
    load_dotenv()
except Exception:
    pass

BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000")
SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-change-me")
GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")
GOOGLE_CLIENT_SECRET = os.getenv("GOOGLE_CLIENT_SECRET")

# ────────────────────────────────────────────────────────────
# FastAPI
# ────────────────────────────────────────────────────────────
app = FastAPI(
    title="BF Backend API",
    description="""
## 뷰파(BF) 백엔드 API

### 주요 기능
- **AI 이미지 분석**: HuggingFace Space의 NIA 모델을 사용한 피부 분석
- **GPT 가이드**: OpenAI GPT를 활용한 개인화된 뷰티 가이드
- **Google OAuth**: 소셜 로그인
- **JWT 인증**: 앱 클라이언트용 토큰 기반 인증

### API 카테고리
- `/api/v1/analysis/*` - AI 피부 분석 (이미지 필수)
- `/auth/*` - 인증 (Google OAuth, JWT)
- `/health` - 서비스 상태 확인
    """,
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(SessionMiddleware, secret_key=SECRET_KEY, max_age=60*60*24*7)

templates = Jinja2Templates(directory="templates")


# ────────────────────────────────────────────────────────────
# 서버 시작 이벤트
# ────────────────────────────────────────────────────────────
@app.on_event("startup")
async def startup_event():
    """서버 시작 시 환경변수 및 서비스 상태 확인"""
    print("\n" + "="*60)
    print("🚀 BF Backend API 서버 시작 중...")
    print("="*60)
    
    # 필수 환경변수 체크
    required_vars = ["SECRET_KEY"]
    recommended_vars = ["SUPABASE_URL", "SUPABASE_KEY", "AI_API_URL", "GOOGLE_CLIENT_ID"]
    
    missing = [var for var in required_vars if not os.getenv(var)]
    if missing:
        print(f"❌ 오류: 필수 환경변수 누락: {', '.join(missing)}")
        return
    
    missing_rec = [var for var in recommended_vars if not os.getenv(var)]
    if missing_rec:
        print(f"⚠️  경고: 권장 환경변수 누락: {', '.join(missing_rec)}")
    
    # 서비스 상태 확인
    print("\n📊 서비스 상태:")
    print(f"  - Supabase: {'✅ 연결됨' if supabase else '❌ 미설정'}")
    print(f"  - Google OAuth: {'✅ 설정됨' if GOOGLE_CLIENT_ID else '❌ 미설정'}")
    
    # AI 서비스 연결 확인
    if ai_client:
        try:
            health = await ai_client.check_health()
            if health.get("status") in ["ok", "healthy"]:
                print(f"  - AI Service: ✅ 연결 성공 ({os.getenv('AI_API_URL')})")
            else:
                print(f"  - AI Service: ⚠️  상태 이상 - {health}")
        except Exception as e:
            print(f"  - AI Service: ❌ 연결 실패 - {str(e)}")
    else:
        print("  - AI Service: ❌ 모듈 로드 실패")
    
    print("\n" + "="*60)
    print("✅ 서버 준비 완료!")
    print("📖 API 문서: http://localhost:8000/docs")
    print("="*60 + "\n")

# ────────────────────────────────────────────────────────────
# 에러 핸들러
# ────────────────────────────────────────────────────────────
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """입력값 검증 실패 시 에러 응답"""
    return JSONResponse(
        status_code=422,
        content={
            "success": False,
            "error": "입력값 검증 실패",
            "details": exc.errors()
        }
    )

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """HTTP 예외 처리"""
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "success": False,
            "error": exc.detail
        }
    )

# ────────────────────────────────────────────────────────────
# 기본 페이지
# ────────────────────────────────────────────────────────────
@app.get("/", response_class=HTMLResponse)
def root():
    return {"message": "BF API Server", "status": "running"}



@app.get("/me")
async def get_current_user_info(user: dict = Depends(get_current_user_from_supabase)):
    """
    현재 로그인한 사용자 정보 반환 (Supabase JWT 기반)
    """
    return {
        "authenticated": True,
        "user": user
    }


@app.get("/profile")
async def get_profile(user: dict = Depends(get_current_user_from_supabase)):
    """
    사용자 프로필 조회
    """
    user_id = user["id"]
    
    # Supabase에서 프로필 데이터 조회
    response = supabase.table("profiles").select("*").eq("id", user_id).execute()
    
    if not response.data:
        return {"user": user, "profile": None}
    
    return {
        "user": user,
        "profile": response.data[0]
    }



# ────────────────────────────────────────────────────────────
# 헬스체크
# ────────────────────────────────────────────────────────────
@app.get("/health")
async def health_check():
    """전체 서비스 상태 확인"""
    
    # AI 서비스 상태
    ai_status = "unavailable"
    if ai_client:
        try:
            ai_health = await ai_client.check_health()
            ai_status = ai_health.get("status", "unknown")
        except:
            ai_status = "error"
    
    return {
        "status": "ok",
        "timestamp": datetime.utcnow().isoformat(),
        "services": {
            "api": "ok",
            "ai_service": ai_status,
            "supabase": "ok" if supabase else "unavailable",
            "auth": "ok" if GOOGLE_CLIENT_ID else "not_configured"
        }
    }

@app.get("/__routes", tags=["debug"])
def list_routes():
    """등록된 라우트 목록 (디버깅용)"""
    return sorted([r.path for r in app.routes if isinstance(r, APIRoute)])

# ────────────────────────────────────────────────────────────
# Supabase 예시 엔드포인트 (개발/테스트용)
# ────────────────────────────────────────────────────────────
@app.get("/api/v1/profiles", tags=["database"])
def get_profiles():
    """프로필 목록 조회 (개발용)"""
    if not supabase:
        return {"warning": "Supabase not configured", "data": []}
    try:
        resp = supabase.table("profiles").select("*").execute()
        return {"success": True, "data": resp.data}
    except Exception as e:
        return {"success": False, "error": str(e)}

@app.get("/api/v1/products/{product_id}", tags=["database"])
def get_product(product_id: str):
    """제품 상세 조회 (개발용)"""
    if not supabase:
        return {"warning": "Supabase not configured", "data": None}
    try:
        resp = supabase.table("products").select("*").eq("id", product_id).single().execute()
        return {"success": True, "data": resp.data}
    except Exception as e:
        return {"success": False, "error": str(e)}

# ────────────────────────────────────────────────────────────
# AI 분석 API (핵심 기능)
# ────────────────────────────────────────────────────────────

@app.post("/api/v1/analysis/comprehensive", tags=["AI 분석"])
async def ai_comprehensive_analysis(
    file: UploadFile = File(..., description="얼굴 이미지 (JPG, PNG)"),
    concerns: Optional[str] = Form(None, description="피부 고민 (선택)"),
    user: dict = Depends(get_current_user_info)
):
    """
    HF Space AI 서비스를 사용한 종합 피부 분석
    
    **플로우:**
    1. 이미지 업로드 → Supabase Storage
    2. AI API 호출 → HF Space (NIA 모델 + GPT)
    3. 결과 변환 → 프론트엔드 형식
    4. 결과 저장 → Supabase DB
    5. 응답 반환 (프론트엔드 AnalysisResult 형식)
    
    **인증:** JWT Token 또는 Session 필요
    
    **응답 형식:** 프론트엔드 AnalysisResult 모델과 일치
    """
    
    if not ai_client or not storage_service:
        raise HTTPException(
            status_code=503,
            detail="AI 서비스가 설정되지 않았습니다. 관리자에게 문의하세요."
        )
    
    # 파일 검증
    if not file.content_type.startswith('image/'):
        raise HTTPException(
            status_code=400,
            detail="이미지 파일만 업로드 가능합니다 (JPG, PNG)"
        )
    
    user_id = user.get("sub")
    
    try:
        # 1. 이미지 업로드
        upload_result = await storage_service.upload_analysis_image(
            user_id=user_id,
            file=file
        )
        image_id = upload_result["image_id"]
        image_url = upload_result["image_url"]
        
        # 2. AI 분석 요청
        await file.seek(0)  # 파일 포인터 리셋
        ai_result = await ai_client.comprehensive_analysis(
            image_file=file,
            concerns=concerns
        )
        
        # 3. 응답 형식 변환 (HF Space → 프론트엔드)
        formatted_response = ResponseFormatter.format_analysis_response(
            analysis_id=str(uuid.uuid4()),  # 새 분석 ID 생성
            user_id=user_id,
            image_id=image_id,
            image_url=image_url,
            ai_result=ai_result,
            concerns=concerns
        )
        
        # 4. 결과 저장 (프론트엔드 형식으로)
        await storage_service.save_analysis_result_formatted(
            user_id=user_id,
            formatted_result=formatted_response
        )
        
        # 5. 응답 반환 (success/data 래퍼 없이 직접 반환)
        return formatted_response
    
    except HTTPException:
        raise
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"분석 처리 실패: {str(e)}"
        )

@app.get("/api/v1/analysis/history", tags=["AI 분석"])
async def get_analysis_history(
    limit: int = 10,
    user: dict = Depends(get_current_user_info)
):
    """
    사용자의 분석 히스토리 조회
    
    **인증:** JWT Token 또는 Session 필요
    **응답:** AnalysisResult 배열
    """
    
    if not storage_service:
        raise HTTPException(
            status_code=503,
            detail="Storage 서비스가 설정되지 않았습니다"
        )
    
    user_id = user.get("sub")
    
    try:
        history = await storage_service.get_user_analyses_formatted(
            user_id=user_id,
            limit=limit
        )
        
        return history  # 배열 직접 반환
    
    except HTTPException:
        raise
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"히스토리 조회 실패: {str(e)}"
        )


@app.get("/api/v1/analysis/{analysis_id}", tags=["AI 분석"])
async def get_analysis_detail(
    analysis_id: str,
    user: dict = Depends(get_current_user_info)
):
    """
    특정 분석 결과 상세 조회
    
    **인증:** JWT Token 또는 Session 필요
    **권한:** 본인의 분석 결과만 조회 가능
    **응답:** AnalysisResult 객체
    """
    
    if not storage_service:
        raise HTTPException(
            status_code=503,
            detail="Storage 서비스가 설정되지 않았습니다"
        )
    
    user_id = user.get("sub")
    
    try:
        analysis = await storage_service.get_analysis_by_id_formatted(
            analysis_id=analysis_id,
            user_id=user_id
        )
        
        if not analysis:
            raise HTTPException(
                status_code=404,
                detail="분석 결과를 찾을 수 없습니다"
            )
        
        return analysis  # 객체 직접 반환
    
    except HTTPException:
        raise
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"조회 실패: {str(e)}"
        )


@app.get("/api/v1/analysis/health", tags=["AI 분석"])
async def check_ai_service_health():
    """
    AI 서비스(HF Space) 상태 확인
    
    **인증:** 불필요 (공개 엔드포인트)
    """
    
    if not ai_client:
        return {
            "status": "unavailable",
            "error": "AI client not configured"
        }
    
    try:
        health = await ai_client.check_health()
        return health
    except Exception as e:
        return {
            "status": "error",
            "error": str(e)
        }