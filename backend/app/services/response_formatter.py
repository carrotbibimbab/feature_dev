from datetime import datetime
from typing import Dict, Any, Optional, List
import uuid


class ResponseFormatter:
    """AI 서비스 응답을 Flutter AnalysisResult 모델로 변환"""
    
    @staticmethod
    def format_analysis_response(
        analysis_id: str,
        user_id: str,
        image_id: str,
        image_url: str,
        ai_result: Dict[str, Any],
        concerns: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        HF Space AI 응답 → Flutter AnalysisResult 모델 형식 변환
        
        Flutter 모델 구조 (analysis_result.dart 기준):
        - personal_color, best_colors, worst_colors (퍼스널 컬러)
        - detected_skin_type (피부 타입)
        - sensitivity_score, sensitivity_level, risk_factors (민감성)
        - pore_score, wrinkle_score, elasticity_score, acne_score, 
          pigmentation_score, redness_score (상세 분석 6개)
        - skincare_routine (List<SkincareStep>)
        - face_detected, face_quality_score
        - raw_analysis_data
        """
        
        sensitivity = ai_result.get("sensitivity_analysis", {})
        ai_guide = ai_result.get("ai_guide", {})
        
        # 스킨케어 루틴 파싱 (GPT 가이드에서 추출)
        skincare_routine = ResponseFormatter._extract_skincare_routine(ai_guide)
        
        return {
            # 기본 정보
            "id": analysis_id,
            "user_id": user_id,
            "image_id": image_id,
            
            # === 1. 퍼스널 컬러 (현재 미구현) ===
            "personal_color": None,
            "personal_color_confidence": None,
            "personal_color_description": None,
            "best_colors": None,
            "worst_colors": None,
            
            # === 2. 피부 타입 (현재 미구현) ===
            "detected_skin_type": None,
            "skin_type_description": None,
            
            # === 3. 민감성 위험도 ===
            "sensitivity_score": sensitivity.get("sensitivity_score", 0),  # 0-10
            "sensitivity_level": sensitivity.get("sensitivity_level", "moderate"),
            "risk_factors": sensitivity.get("risk_factors", []),
            
            # === 4. 피부 상세 분석 (6개 항목) ===
            "pore_score": sensitivity.get("pore_score", 0),
            "pore_description": ResponseFormatter._get_score_description(
                sensitivity.get("pore_score", 0),
                "모공"
            ),
            
            "wrinkle_score": None,  # HF Space에서 미제공
            "wrinkle_description": None,
            
            "elasticity_score": sensitivity.get("elasticity_score", 0),
            "elasticity_description": ResponseFormatter._get_score_description(
                sensitivity.get("elasticity_score", 0),
                "탄력"
            ),
            
            "acne_score": None,  # HF Space에서 미제공
            "acne_description": None,
            
            "pigmentation_score": sensitivity.get("pigmentation_score", 0),
            "pigmentation_description": ResponseFormatter._get_score_description(
                sensitivity.get("pigmentation_score", 0),
                "색소침착"
            ),
            
            "redness_score": None,  # HF Space에서 미제공
            "redness_description": None,
            
            # === 5. 스킨케어 루틴 ===
            "skincare_routine": skincare_routine,
            
            # === 6. 얼굴 인식 품질 ===
            "face_detected": True,  # HF Space가 분석했다면 얼굴 인식 성공
            "face_quality_score": 1.0,
            
            # === 7. 원본 데이터 (백업) ===
            "raw_analysis_data": {
                "hf_space_result": ai_result,
                "user_concerns": concerns,
                "analysis_version": ai_result.get("analysis_version", "nia_v1.0"),
                "analyzed_at": ai_result.get("analyzed_at", datetime.utcnow().isoformat()),
                "sensitivity_details": sensitivity,
                "ai_guide": ai_guide
            },
            
            # === 타임스탬프 ===
            "created_at": datetime.utcnow().isoformat()
        }
    
    @staticmethod
    def _get_score_description(score: int, category: str) -> Optional[str]:
        """점수에 따른 설명 생성"""
        if score is None:
            return None
        
        if score >= 80:
            return f"{category} 상태가 매우 좋습니다."
        elif score >= 60:
            return f"{category} 상태가 양호합니다."
        elif score >= 40:
            return f"{category}에 약간의 관리가 필요합니다."
        elif score >= 20:
            return f"{category} 개선이 필요합니다."
        else:
            return f"{category}에 집중적인 케어가 필요합니다."
    
    @staticmethod
    def _extract_skincare_routine(ai_guide: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        GPT 가이드에서 스킨케어 루틴 추출
        
        Flutter SkincareStep 모델:
        {
            "step": 1,
            "type": "cleanser",
            "description": "저자극 클렌저로 순한 세안",
            "product_example": null,
            "icon_asset": null
        }
        """
        
        recommendations = ai_guide.get("recommendations", [])
        
        if not recommendations:
            # 기본 루틴 제공
            return ResponseFormatter._get_default_routine()
        
        # GPT 추천사항을 단계별로 변환
        routine = []
        step_types = ["cleanser", "toner", "essence", "serum", "moisturizer", "sunscreen"]
        
        for i, recommendation in enumerate(recommendations[:6], 1):
            routine.append({
                "step": i,
                "type": step_types[i-1] if i <= len(step_types) else "treatment",
                "description": recommendation,
                "product_example": None,
                "icon_asset": None
            })
        
        return routine
    
    @staticmethod
    def _get_default_routine() -> List[Dict[str, Any]]:
        """기본 스킨케어 루틴"""
        return [
            {
                "step": 1,
                "type": "cleanser",
                "description": "저자극 클렌저로 아침 저녁 세안",
                "product_example": None,
                "icon_asset": None
            },
            {
                "step": 2,
                "type": "toner",
                "description": "수분 토너로 피부 결 정리",
                "product_example": None,
                "icon_asset": None
            },
            {
                "step": 3,
                "type": "essence",
                "description": "보습 에센스로 수분 공급",
                "product_example": None,
                "icon_asset": None
            },
            {
                "step": 4,
                "type": "moisturizer",
                "description": "촉촉한 보습 크림으로 수분 잠금",
                "product_example": None,
                "icon_asset": None
            },
            {
                "step": 5,
                "type": "sunscreen",
                "description": "SPF 50+ 자외선 차단제 (아침)",
                "product_example": None,
                "icon_asset": None
            }
        ]
    
    @staticmethod
    def format_error_response(
        error_message: str,
        error_code: Optional[str] = None
    ) -> Dict[str, Any]:
        """에러 응답 형식"""
        return {
            "success": False,
            "error": error_message,
            "error_code": error_code,
            "timestamp": datetime.utcnow().isoformat()
        }