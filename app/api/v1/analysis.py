"""
 분석 API 엔드포인트 (v1)
"""

from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from datetime import datetime
import os
import tempfile

from app.services.analysis_orchestrator import AnalysisOrchestrator
from app.models.response import (
    ComprehensiveAnalysisResponse,
    #PersonalColorResponse,
    SensitivityResponse,
    AIAnalysisResponse,
    SingleAnalysisResponse,
    ErrorResponse,
    HealthCheckResponse
)
from app.models.request import (
    AnalysisRequest,
    SensitivityScoreExplainRequest
)


router = APIRouter(prefix="/analysis", tags=["분석"])

# 오케스트레이터 초기화 (싱글톤)
orchestrator = AnalysisOrchestrator()


@router.post(
    "/comprehensive",
    response_model=ComprehensiveAnalysisResponse,
    summary="종합 피부 분석",
    description="""
     피부 민감도 + AI 분석을 통합 수행
    
    - NIA: 피부 민감도 (건조도, 색소침착, 모공, 탄력)
    - GPT: 개인화된 뷰티 가이드
    """
)
async def comprehensive_analysis(
    file: UploadFile = File(..., description="얼굴 정면 이미지 (JPG, PNG)"),
    concerns: str = Form(None, description="피부 고민 (선택)")
):
    """종합 피부 분석"""
    
    temp_path = None
    
    try:
        # 파일 검증
        if not file.content_type.startswith('image/'):
            raise HTTPException(
                status_code=400,
                detail="이미지 파일만 업로드 가능합니다"
            )
        
        # 임시 파일 저장
        with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
            content = await file.read()
            tmp.write(content)
            temp_path = tmp.name
        
        # 종합 분석 실행
        result = await orchestrator.comprehensive_analysis(
            image_path=temp_path,
            user_concerns=concerns
        )
        
        # 응답 생성
        return ComprehensiveAnalysisResponse(
            #personal_color=PersonalColorResponse(**result['personal_color']),
            sensitivity=SensitivityResponse(**result['sensitivity']),
            ai_analysis=AIAnalysisResponse(**result['ai_analysis']),
            timestamp=datetime.now().isoformat()
        )
    
    except HTTPException:
        raise
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"분석 중 오류 발생: {str(e)}"
        )
    
    finally:
        # 임시 파일 삭제
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)


# @router.post(
#     "/personal-color",
#     response_model=SingleAnalysisResponse,
#     summary="퍼스널 컬러 분석",
#     description="퍼스널 컬러 시즌만 분석 (Spring/Summer/Autumn/Winter)"
# )
# async def analyze_personal_color(
#     file: UploadFile = File(..., description="얼굴 정면 이미지")
# ):
#     """퍼스널 컬러만 분석"""
    
#     temp_path = None
    
#     try:
#         if not file.content_type.startswith('image/'):
#             raise HTTPException(
#                 status_code=400,
#                 detail="이미지 파일만 업로드 가능합니다"
#             )
        
#         with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
#             content = await file.read()
#             tmp.write(content)
#             temp_path = tmp.name
        
#         result = await orchestrator.personal_color_only(temp_path)
        
#         return SingleAnalysisResponse(
#             success=True,
#             data=result,
#             timestamp=datetime.now().isoformat()
#         )
    
#     except Exception as e:
#         raise HTTPException(
#             status_code=500,
#             detail=f"퍼스널 컬러 분석 실패: {str(e)}"
#         )
    
#     finally:
#         if temp_path and os.path.exists(temp_path):
#             os.remove(temp_path)


@router.post(
    "/sensitivity",
    response_model=SingleAnalysisResponse,
    summary="피부 민감도 분석",
    description="NIA 모델을 사용한 피부 민감도 분석 (건조도, 색소침착, 모공, 탄력)"
)
async def analyze_sensitivity(
    file: UploadFile = File(..., description="얼굴 정면 이미지")
):
    """피부 민감도만 분석"""
    
    temp_path = None
    
    try:
        if not file.content_type.startswith('image/'):
            raise HTTPException(
                status_code=400,
                detail="이미지 파일만 업로드 가능합니다"
            )
        
        with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
            content = await file.read()
            tmp.write(content)
            temp_path = tmp.name
        
        result = await orchestrator.sensitivity_only(temp_path)
        
        return SingleAnalysisResponse(
            success=True,
            data=result,
            timestamp=datetime.now().isoformat()
        )
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"민감도 분석 실패: {str(e)}"
        )
    
    finally:
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)


@router.get(
    "/health",
    response_model=HealthCheckResponse,
    summary="서비스 상태 확인",
    description="ColorInsight, NIA, GPT 서비스 상태 확인"
)
async def health_check():
    """서비스 상태 확인"""
    
    status_dict = orchestrator.check_services_health()
    
    all_ready = all(status_dict.values())
    
    return HealthCheckResponse(
        status="healthy" if all_ready else "partial",
        services=status_dict,
        timestamp=datetime.now().isoformat()
    )


@router.post(
    "/explain-score",
    summary="민감도 점수 해석",
    description="GPT를 사용하여 민감도 점수의 의미를 쉽게 설명"
)
async def explain_sensitivity_score(
    score: float = Form(..., ge=0, le=100, description="민감도 점수"),
    level: str = Form(..., description="low, medium, high")
):
    """민감도 점수 해석 (GPT 활용)"""
    
    try:
        # 레벨 검증
        if level not in ['low', 'medium', 'high']:
            raise HTTPException(
                status_code=400,
                detail="level은 'low', 'medium', 'high' 중 하나여야 합니다"
            )
        
        explanation = await orchestrator.explain_score(score, level)
        
        return {
            "success": True,
            "explanation": explanation,
            "timestamp": datetime.now().isoformat()
        }
    
    except HTTPException:
        raise
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"점수 해석 실패: {str(e)}"
        )