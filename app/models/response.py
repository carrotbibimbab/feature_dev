"""
 응답 모델
기존 response.py에 추가할 내용
"""

from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime


# ============================================================================
# 퍼스널 컬러 응답
# ============================================================================

class PersonalColorResponse(BaseModel):
    """퍼스널 컬러 분석 결과"""
    season: str = Field(..., description="Spring, Summer, Autumn, Winter")
    confidence: float = Field(..., ge=0, le=100, description="신뢰도 (%)")
    description: Optional[str] = Field(None, description="시즌 설명")
    
    class Config:
        json_schema_extra = {
            "example": {
                "season": "Spring",
                "confidence": 85.5,
                "description": "따뜻하고 밝은 봄 웜톤"
            }
        }


# ============================================================================
# 민감도 분석 응답
# ============================================================================

class SensitivityResponse(BaseModel):
    """피부 민감도 분석 결과"""
    sensitivity_score: float = Field(..., ge=0, le=100, description="종합 민감도 점수")
    level: str = Field(..., description="low, medium, high")
    dryness: float = Field(..., ge=0, le=100, description="건조도")
    pigmentation: float = Field(..., ge=0, le=100, description="색소침착")
    pore: float = Field(..., ge=0, le=100, description="모공")
    elasticity: float = Field(..., ge=0, le=100, description="탄력")
    details: Optional[dict] = Field(None, description="상세 분석 데이터")
    
    class Config:
        json_schema_extra = {
            "example": {
                "sensitivity_score": 67.3,
                "level": "medium",
                "dryness": 72.5,
                "pigmentation": 45.2,
                "pore": 68.1,
                "elasticity": 55.9,
                "details": {
                    "lip_dryness_grade": 3,
                    "cheek_moisture": 0.412
                }
            }
        }


# ============================================================================
# AI 분석 응답
# ============================================================================

class AIAnalysisResponse(BaseModel):
    """GPT AI 분석 결과"""
    summary: str = Field(..., description="핵심 요약")
    #personal_color_guide: str = Field(..., description="퍼스널 컬러 가이드")
    skin_condition: str = Field(..., description="피부 상태 분석")
    recommendations: List[str] = Field(..., description="추천 사항")
    warnings: List[str] = Field(..., description="주의 사항")
    full_text: Optional[str] = Field(None, description="전체 분석 텍스트")
    
    class Config:
        json_schema_extra = {
            "example": {
                "summary": "중간 민감도 피부로...",
                "skin_condition": "건조도가 다소 높아 보습 관리가 필요합니다...",
                "recommendations": [
                    "아침저녁 세안 후 즉시 보습제 사용",
                    "SPF 30 이상 자외선 차단제 필수",
                    "순한 성분의 클렌징 제품 사용"
                ],
                "warnings": [
                    "알코올 함량 높은 제품 피하기",
                    "과도한 각질 제거 자제"
                ]
            }
        }


# ============================================================================
# 종합 분석 응답
# ============================================================================

class ComprehensiveAnalysisResponse(BaseModel):
    """종합 피부 분석 응답"""
    success: bool = True
    #personal_color: PersonalColorResponse
    sensitivity: SensitivityResponse
    ai_analysis: AIAnalysisResponse
    timestamp: str = Field(default_factory=lambda: datetime.now().isoformat())
    disclaimer: str = Field(
        default="본 분석은 AI 기반 일반적인 뷰티 가이드이며, 의학적 진단이 아닙니다. "
                "피부 질환이 의심되는 경우 피부과 전문의와 상담하세요."
    )
    
    class Config:
        json_schema_extra = {
            "example": {
                "success": True,
                "personal_color": {
                    "season": "Spring",
                    "confidence": 85.5
                },
                "sensitivity": {
                    "sensitivity_score": 67.3,
                    "level": "medium",
                    "dryness": 72.5,
                    "pigmentation": 45.2,
                    "pore": 68.1,
                    "elasticity": 55.9
                },
                "ai_analysis": {
                    "summary": "Spring 웜톤...",
                    "recommendations": ["..."]
                },
                "timestamp": "2024-01-15T10:30:00"
            }
        }


# ============================================================================
# 단일 분석 응답 (퍼스널 컬러 또는 민감도만)
# ============================================================================

class SingleAnalysisResponse(BaseModel):
    """단일 분석 응답 (퍼스널 컬러 또는 민감도)"""
    success: bool = True
    data: dict
    timestamp: str = Field(default_factory=lambda: datetime.now().isoformat())


# ============================================================================
# 에러 응답
# ============================================================================

class ErrorResponse(BaseModel):
    """에러 응답"""
    success: bool = False
    error: str
    detail: Optional[str] = None
    timestamp: str = Field(default_factory=lambda: datetime.now().isoformat())
    
    class Config:
        json_schema_extra = {
            "example": {
                "success": False,
                "error": "분석 실패",
                "detail": "이미지 파일을 읽을 수 없습니다",
                "timestamp": "2024-01-15T10:30:00"
            }
        }


# ============================================================================
# 헬스 체크 응답
# ============================================================================

class HealthCheckResponse(BaseModel):
    """서비스 상태 확인 응답"""
    status: str = Field(..., description="healthy, partial, unhealthy")
    services: dict = Field(..., description="각 서비스별 상태")
    timestamp: str = Field(default_factory=lambda: datetime.now().isoformat())
    
    class Config:
        json_schema_extra = {
            "example": {
                "status": "healthy",
                "services": {
                    "colorinsight": True,
                    "nia": True,
                    "gpt": True
                },
                "timestamp": "2024-01-15T10:30:00"
            }
        }