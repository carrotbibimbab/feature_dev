"""
 요청 모델
기존 request.py에 추가할 내용
"""

from pydantic import BaseModel, Field
from typing import Optional


class AnalysisRequest(BaseModel):
    """종합 분석 요청"""
    user_id: Optional[str] = Field(None, description="사용자 ID (로그인 시)")
    concerns: Optional[str] = Field(
        None,
        description="피부 고민 (예: '건조함, 색소침착 심함')",
        max_length=500
    )
    include_product_recommendations: bool = Field(
        default=False,
        description="제품 추천 포함 여부"
    )
    
    class Config:
        json_schema_extra = {
            "example": {
                "user_id": "user123",
                "concerns": "건조하고 색소침착이 심해요",
                "include_product_recommendations": False
            }
        }


class SensitivityScoreExplainRequest(BaseModel):
    """민감도 점수 해석 요청"""
    score: float = Field(..., ge=0, le=100, description="민감도 점수")
    level: str = Field(..., pattern="^(low|medium|high)$", description="민감도 등급")
    
    class Config:
        json_schema_extra = {
            "example": {
                "score": 67.3,
                "level": "medium"
            }
        }