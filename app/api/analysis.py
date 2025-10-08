"""
 종합 피부 분석 API
ColorInsight + NIA + GPT 통합
"""

from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from fastapi.responses import JSONResponse
from datetime import datetime
import os
import tempfile

from app.services.colorinsight_service import ColorInsightService
from app.services.nia_service import NIASkinAnalyzer
from app.services.gpt_service import GPTSkinAnalysisService
from app.models.analysis_models import (
    ComprehensiveAnalysisResponse,
    #PersonalColorResult,
    SensitivityResult,
    AIAnalysisResult,
    ErrorResponse
)


router = APIRouter(prefix="/api/analysis", tags=["분석"])

# 서비스 초기화 (싱글톤)
#colorinsight_service = ColorInsightService()
nia_analyzer = NIASkinAnalyzer(checkpoint_dir='./NIA/checkpoints')
gpt_service = GPTSkinAnalysisService()


@router.post("/comprehensive", response_model=ComprehensiveAnalysisResponse)
async def comprehensive_analysis(
    file: UploadFile = File(..., description="얼굴 정면 이미지"),
    concerns: str = Form(None, description="피부 고민 (선택)")
):
    """
    종합 피부 분석
    
    1. 퍼스널 컬러 분석 (ColorInsight)
    2. 피부 민감도 분석 (NIA)
    3. AI 개인화 리포트 (GPT)
    
    Returns:
        종합 분석 결과
    """
    
    temp_path = None
    
    try:
        # 임시 파일 저장
        with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
            content = await file.read()
            tmp.write(content)
            temp_path = tmp.name
        
        # # 1. 퍼스널 컬러 분석
        # try:
        #     pc_result = colorinsight_service.analyze_personal_color(temp_path)
        #     personal_color = PersonalColorResult(
        #         season=pc_result['season'],
        #         confidence=pc_result['confidence'],
        #         description=pc_result.get('description')
        #     )
        # except Exception as e:
        #     raise HTTPException(
        #         status_code=500,
        #         detail=f"퍼스널 컬러 분석 실패: {str(e)}"
        #     )
        
        # 2. 피부 민감도 분석
        try:
            sens_result = nia_analyzer.analyze_sensitivity(temp_path)
            sensitivity = SensitivityResult(**sens_result)
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"민감도 분석 실패: {str(e)}"
            )
        
        # 3. GPT AI 분석
        try:
            ai_result = gpt_service.generate_comprehensive_analysis(
                #personal_color=personal_color.dict(),
                sensitivity=sensitivity.dict(),
                user_concerns=concerns
            )
            ai_analysis = AIAnalysisResult(**ai_result)
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"AI 분석 실패: {str(e)}"
            )
        
        # 종합 응답
        return ComprehensiveAnalysisResponse(
            #personal_color=personal_color,
            sensitivity=sensitivity,
            ai_analysis=ai_analysis,
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


# @router.post("/personal-color")
# async def analyze_personal_color(
#     file: UploadFile = File(..., description="얼굴 정면 이미지")
# ):
#     # """퍼스널 컬러만 분석"""
    
#     # temp_path = None
    
    # try:
    #     with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
    #         content = await file.read()
    #         tmp.write(content)
    #         temp_path = tmp.name
        
    #     result = colorinsight_service.analyze_personal_color(temp_path)
        
    #     return {
    #         "success": True,
    #         "data": result,
    #         "timestamp": datetime.now().isoformat()
    #     }
    
    # except Exception as e:
    #     raise HTTPException(
    #         status_code=500,
    #         detail=f"퍼스널 컬러 분석 실패: {str(e)}"
    #     )
    
    # finally:
    #     if temp_path and os.path.exists(temp_path):
    #         os.remove(temp_path)


@router.post("/sensitivity")
async def analyze_sensitivity(
    file: UploadFile = File(..., description="얼굴 정면 이미지")
):
    """피부 민감도만 분석"""
    
    temp_path = None
    
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
            content = await file.read()
            tmp.write(content)
            temp_path = tmp.name
        
        result = nia_analyzer.analyze_sensitivity(temp_path)
        
        return {
            "success": True,
            "data": result,
            "timestamp": datetime.now().isoformat()
        }
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"민감도 분석 실패: {str(e)}"
        )
    
    finally:
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)


@router.get("/health")
async def health_check():
    """서비스 상태 확인"""
    
    status = {
        "colorinsight": False,
        "nia": False,
        "gpt": False
    }
    
    # ColorInsight 체크
    # try:
    #     # 모델 로드 확인
    #     status["colorinsight"] = colorinsight_service.model is not None
    # except:
    #     pass
    
    # NIA 체크
    try:
        # 체크포인트 존재 확인
        import os
        checkpoint_dir = './NIA/checkpoints/class/100%/1,2,3'
        status["nia"] = os.path.exists(checkpoint_dir)
    except:
        pass
    
    # GPT 체크
    try:
        # API 키 확인
        status["gpt"] = os.getenv('OPENAI_API_KEY') is not None
    except:
        pass
    
    all_ready = all(status.values())
    
    return {
        "status": "healthy" if all_ready else "partial",
        "services": status,
        "timestamp": datetime.now().isoformat()
    }


@router.post("/explain-score")
async def explain_sensitivity_score(
    score: float = Form(..., ge=0, le=100),
    level: str = Form(..., regex="^(low|medium|high)$")
):
    """민감도 점수 해석 (GPT 활용)"""
    
    try:
        explanation = gpt_service.explain_sensitivity_score(score, level)
        
        return {
            "success": True,
            "explanation": explanation,
            "timestamp": datetime.now().isoformat()
        }
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"점수 해석 실패: {str(e)}"
        )