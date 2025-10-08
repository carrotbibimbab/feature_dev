"""
피부 분석 응답 모델
Pydantic 스키마 정의
"""

from pydantic import BaseModel, Field
from typing import List, Optional


# class PersonalColorResult(BaseModel):
#     """퍼스널 컬러 분석 결과"""
#     season: str = Field(..., description="Spring, Summer, Autumn, Winter")
#     confidence: float = Field(..., ge=0, le=100, description="신뢰도 (%)")
#     description: Optional[str] = Field(None, description="시즌 설명")


class SensitivityResult(BaseModel):
    """피부 민감도 분석 결과"""
    sensitivity_score: float = Field(..., ge=0, le=100)
    level: str = Field(..., description="low, medium, high")
    dryness: float = Field(..., ge=0, le=100)
    pigmentation: float = Field(..., ge=0, le=100)
    pore: float = Field(..., ge=0, le=100)
    elasticity: float = Field(..., ge=0, le=100)
    details: Optional[dict] = None


class AIAnalysisResult(BaseModel):
    """GPT AI 분석 결과"""
    summary: str = Field(..., description="핵심 요약")
    #personal_color_guide: str = Field(..., description="퍼스널 컬러 가이드")
    skin_condition: str = Field(..., description="피부 상태 분석")
    recommendations: List[str] = Field(..., description="추천 사항")
    warnings: List[str] = Field(..., description="주의 사항")
    full_text: Optional[str] = Field(None, description="전체 분석 텍스트")


class ComprehensiveAnalysisResponse(BaseModel):
    """종합 분석 응답"""
    success: bool = True
    #personal_color: PersonalColorResult
    sensitivity: SensitivityResult
    ai_analysis: AIAnalysisResult
    timestamp: str
    disclaimer: str = Field(
        default="본 분석은 AI 기반 일반적인 뷰티 가이드이며, 의학적 진단이 아닙니다. "
                "피부 질환이 의심되는 경우 피부과 전문의와 상담하세요."
    )


class AnalysisRequest(BaseModel):
    """분석 요청"""
    user_id: Optional[str] = None
    concerns: Optional[str] = Field(
        None,
        description="사용자 피부 고민 (예: '건조함, 색소침착 심함')"
    )
    include_product_recommendations: bool = Field(
        default=False,
        description="제품 추천 포함 여부"
    )


class ErrorResponse(BaseModel):
    """에러 응답"""
    success: bool = False
    error: str
    detail: Optional[str] = None