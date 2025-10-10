import os
from datetime import datetime, timedelta
from typing import Optional
import uuid

from fastapi import FastAPI, Request, HTTPException, Depends, UploadFile, File, Form
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
from app.services.response_formatter import ResponseFormatter

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
# Supabase
# ────────────────────────────────────────────────────────────
supabase = None
try:
    from supabase import create_client, Client
    SUPABASE_URL = os.getenv("SUPABASE_URL")
    SUPABASE_KEY = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")
    if SUPABASE_URL and SUPABASE_KEY:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
except Exception:
    supabase = None

# ────────────────────────────────────────────────────────────
# Google OAuth
# ────────────────────────────────────────────────────────────
from authlib.integrations.starlette_client import OAuth

oauth = OAuth()
oauth.register(
    name="google",
    client_id=GOOGLE_CLIENT_ID or "",
    client_secret=GOOGLE_CLIENT_SECRET or "",
    server_metadata_url="https://accounts.google.com/.well-known/openid-configuration",
    client_kwargs={"scope": "openid email profile", "prompt": "select_account"},
)

state_signer = URLSafeSerializer(SECRET_KEY, salt="oauth-state")

# ────────────────────────────────────────────────────────────
# JWT
# ────────────────────────────────────────────────────────────
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

def create_access_token(subject: dict, expires_minutes: int | None = None) -> str:
    """우리 서버용 액세스 토큰 발급"""
    exp = datetime.utcnow() + timedelta(minutes=expires_minutes or ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode = {"exp": exp, **subject}
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str) -> dict:
    """우리 서버용 액세스 토큰 검증"""
    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

_bearer = HTTPBearer(auto_error=False)

def get_current_user(request: Request, creds: HTTPAuthorizationCredentials = Depends(_bearer)) -> dict:
    """
    보호 라우트에서 호출되는 공용 의존성
    1) Authorization: Bearer <JWT> 있으면 → JWT 검증
    2) 없으면 세션 로그인 사용자 허용
    """
    if creds and creds.scheme.lower() == "bearer":
        try:
            payload = decode_token(creds.credentials)
            return {
                "sub": payload.get("sub"),
                "email": payload.get("email"),
                "name": payload.get("name"),
                "picture": payload.get("picture"),
            }
        except Exception:
            raise HTTPException(status_code=401, detail="Invalid or expired token")

    user = request.session.get("user")
    if user:
        return user

    raise HTTPException(status_code=401, detail="Not authenticated")

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
def home(request: Request):
    """홈페이지"""
    user = request.session.get("user")
    return templates.TemplateResponse("login.html", {"request": request, "user": user})

@app.get("/login")
async def login(request: Request):
    """Google 로그인 시작"""
    redirect_uri = f"{BASE_URL.rstrip('/')}/auth/google/callback"
    state = state_signer.dumps({"next": request.query_params.get("next", "/profile")})
    return await oauth.google.authorize_redirect(request, redirect_uri, state=state)

@app.get("/auth/google/callback")
async def auth_callback(request: Request):
    # ... 기존 OAuth 처리 ...
    
    request.session["user"] = {
        "sub": userinfo.get("sub"),
        "email": userinfo.get("email"),
        "name": userinfo.get("name"),
        "picture": userinfo.get("picture"),
    }
    
    # 🔥 JWT 토큰 발급
    token = create_access_token({
        "sub": userinfo.get("sub"),
        "email": userinfo.get("email"),
        "name": userinfo.get("name"),
        "picture": userinfo.get("picture"),
    })
    
    # Flutter 앱으로 리디렉트 (토큰 포함)
    flutter_callback = f"myapp://login-callback?token={token}"
    return RedirectResponse(url=flutter_callback)

@app.get("/profile", response_class=HTMLResponse)
def profile_page(request: Request):
    """프로필 페이지"""
    user = request.session.get("user")
    if not user:
        return RedirectResponse(url="/")
    return templates.TemplateResponse("profile.html", {"request": request, "user": user})

@app.get("/me")
def me_api(request: Request):
    """현재 로그인 사용자 정보 (세션 기반)"""
    user = request.session.get("user")
    if not user:
        return JSONResponse({"authenticated": False}, status_code=401)
    return {"authenticated": True, "user": user}

@app.get("/logout")
def logout(request: Request):
    """로그아웃"""
    request.session.clear()
    return RedirectResponse(url="/")

# ────────────────────────────────────────────────────────────
# JWT 발급/검증
# ────────────────────────────────────────────────────────────
@app.post("/auth/google/jwt")
def issue_our_jwt(request: Request):
    """
    세션 기반으로 우리 JWT 발급
    (앱 클라이언트에서 사용)
    """
    user = request.session.get("user")
    if not user:
        raise HTTPException(status_code=401, detail="Login required (session)")

    token = create_access_token(
        {
            "sub": user.get("sub"),
            "email": user.get("email"),
            "name": user.get("name"),
            "picture": user.get("picture"),
            "provider": "google",
        }
    )
    return {"access_token": token, "token_type": "bearer"}

@app.get("/me-jwt")
def me_jwt(user: dict = Depends(get_current_user)):
    """현재 로그인 사용자 정보 (JWT 기반)"""
    return {"authenticated": True, "user": user}

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
    user: dict = Depends(get_current_user)
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
    user: dict = Depends(get_current_user)
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
    user: dict = Depends(get_current_user)
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