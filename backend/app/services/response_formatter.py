"""
AI 응답을 프론트엔드 형식으로 변환하는 포맷터
"""
from typing import Dict, Any, List, Optional
from datetime import datetime
import random


class ResponseFormatter:
    """HF Space AI 응답을 프론트엔드 AnalysisResult 형식으로 변환"""
    
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
        AI 분석 결과를 프론트엔드 형식으로 변환
        
        Args:
            analysis_id: 분석 ID (UUID)
            user_id: 사용자 ID
            image_id: 이미지 ID
            image_url: 이미지 URL
            ai_result: HF Space AI 원본 응답
            concerns: 사용자 피부 고민
        
        Returns:
            프론트엔드 AnalysisResult 형식의 딕셔너리
        """
        
        sensitivity = ai_result.get('sensitivity', {})
        ai_analysis = ai_result.get('ai_analysis', {})
        
        # 민감도 점수 변환 (0-100 → 0-10)
        sensitivity_score_100 = sensitivity.get('sensitivity_score', 50.0)
        sensitivity_score = sensitivity_score_100 / 10.0
        
        # 레벨 매핑
        sensitivity_level = ResponseFormatter._map_sensitivity_level(
            sensitivity.get('level', 'medium')
        )
        
        # 피부 타입 추정
        detected_skin_type = ResponseFormatter._estimate_skin_type(sensitivity)
        
        # 스킨케어 루틴 생성
        skincare_routine = ResponseFormatter._create_skincare_routine(
            ai_analysis.get('recommendations', []),
            sensitivity
        )
        
        # 위험 요소 추출
        risk_factors = ai_analysis.get('warnings', [])
        if concerns:
            risk_factors.insert(0, f"사용자 고민: {concerns}")
        
        return {
            # === 기본 정보 ===
            "id": analysis_id,
            "user_id": user_id,
            "image_id": image_id,
            
            # === 1. 퍼스널 컬러 진단 (TODO: 실제 분석 추가) ===
            "personal_color": ResponseFormatter._generate_personal_color(),
            "personal_color_confidence": 0.75,
            "personal_color_description": "자연스러운 컬러 톤을 가지고 있습니다.",
            "best_colors": ResponseFormatter._get_best_colors(),
            "worst_colors": ResponseFormatter._get_worst_colors(),
            
            # === 2. 피부 타입 분석 ===
            "detected_skin_type": detected_skin_type,
            "skin_type_description": ai_analysis.get('skin_condition', ''),
            
            # === 3. 민감성 위험도 ===
            "sensitivity_score": round(sensitivity_score, 2),
            "sensitivity_level": sensitivity_level,
            "risk_factors": risk_factors,
            
            # === 4. 피부 상세 분석 ===
            "pore_score": ResponseFormatter._convert_score(
                sensitivity.get('pore', {}).get('score')
            ),
            "pore_description": sensitivity.get('pore', {}).get('level', ''),
            
            "wrinkle_score": ResponseFormatter._estimate_wrinkle_score(sensitivity),
            "wrinkle_description": "양호",
            
            "elasticity_score": ResponseFormatter._convert_score(
                sensitivity.get('elasticity', {}).get('score')
            ),
            "elasticity_description": sensitivity.get('elasticity', {}).get('level', ''),
            
            "acne_score": ResponseFormatter._estimate_acne_score(sensitivity),
            "acne_description": "관리 필요",
            
            "pigmentation_score": ResponseFormatter._convert_score(
                sensitivity.get('pigmentation', {}).get('score')
            ),
            "pigmentation_description": sensitivity.get('pigmentation', {}).get('level', ''),
            
            "redness_score": ResponseFormatter._estimate_redness_score(sensitivity),
            "redness_description": "정상",
            
            # === 5. 스킨케어 루틴 ===
            "skincare_routine": skincare_routine,
            
            # === 6. 얼굴 인식 품질 ===
            "face_detected": True,
            "face_quality_score": 0.92,
            
            # === 7. 원본 데이터 (백업) ===
            "raw_analysis_data": {
                "sensitivity": sensitivity,
                "ai_analysis": ai_analysis,
                "image_url": image_url,
                "concerns": concerns
            },
            
            # === 타임스탬프 ===
            "created_at": datetime.utcnow().isoformat() + "Z"
        }
    
    @staticmethod
    def _map_sensitivity_level(backend_level: str) -> str:
        """민감도 레벨 매핑"""
        mapping = {
            'low': 'low',
            'medium': 'moderate',
            'high': 'high'
        }
        return mapping.get(backend_level.lower(), 'moderate')
    
    @staticmethod
    def _convert_score(score: Optional[float]) -> Optional[int]:
        """점수 변환 (float → int, 0-100 범위)"""
        if score is None:
            return None
        if isinstance(score, (int, float)):
            return int(min(100, max(0, score)))
        return None
    
    @staticmethod
    def _estimate_skin_type(sensitivity: Dict[str, Any]) -> str:
        """피부 타입 추정 (건조도 기반)"""
        dryness_score = sensitivity.get('dryness', {}).get('score', 50.0)
        
        if dryness_score > 70:
            return 'dry'
        elif dryness_score < 30:
            return 'oily'
        elif dryness_score < 50:
            return 'combination'
        else:
            return 'normal'
    
    @staticmethod
    def _generate_personal_color() -> str:
        """
        임시 퍼스널 컬러 생성
        TODO: 실제 ColorInsight 모델 연동 후 제거
        """
        colors = [
            'spring_warm_light',
            'spring_warm_bright',
            'summer_cool_light',
            'summer_cool_muted',
            'autumn_warm_muted',
            'autumn_warm_deep',
            'winter_cool_bright',
            'winter_cool_deep'
        ]
        return random.choice(colors)
    
    @staticmethod
    def _get_best_colors() -> List[str]:
        """BEST 컬러 팔레트 (HEX)"""
        return [
            "#FFB6C1", "#FFD700", "#98FB98", "#87CEEB", "#DDA0DD"
        ]
    
    @staticmethod
    def _get_worst_colors() -> List[str]:
        """WORST 컬러 팔레트 (HEX)"""
        return [
            "#000000", "#696969", "#8B4513", "#2F4F4F", "#800000"
        ]
    
    @staticmethod
    def _estimate_wrinkle_score(sensitivity: Dict[str, Any]) -> int:
        """주름 점수 추정 (탄력도 기반)"""
        elasticity_score = sensitivity.get('elasticity', {}).get('score', 70.0)
        return int(elasticity_score)
    
    @staticmethod
    def _estimate_acne_score(sensitivity: Dict[str, Any]) -> int:
        """여드름 점수 추정 (임시)"""
        # TODO: 실제 여드름 분석 추가
        return 75
    
    @staticmethod
    def _estimate_redness_score(sensitivity: Dict[str, Any]) -> int:
        """홍조 점수 추정 (임시)"""
        # TODO: 실제 홍조 분석 추가
        return 80
    
    @staticmethod
    def _create_skincare_routine(
        recommendations: List[str],
        sensitivity: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """
        GPT 추천사항을 스킨케어 루틴으로 변환
        
        Returns:
            [
                {
                    "step": 1,
                    "type": "cleanser",
                    "description": "...",
                    "product_example": null,
                    "icon_asset": null
                },
                ...
            ]
        """
        
        if not recommendations:
            # 기본 루틴 생성
            return ResponseFormatter._create_default_routine(sensitivity)
        
        routine = []
        product_types = ['cleanser', 'toner', 'essence', 'serum', 'moisturizer', 'sunscreen']
        
        for idx, rec in enumerate(recommendations[:6]):  # 최대 6단계
            routine.append({
                "step": idx + 1,
                "type": ResponseFormatter._guess_product_type(rec, product_types[idx] if idx < len(product_types) else 'essence'),
                "description": rec,
                "product_example": None,
                "icon_asset": None
            })
        
        return routine
    
    @staticmethod
    def _create_default_routine(sensitivity: Dict[str, Any]) -> List[Dict[str, Any]]:
        """기본 스킨케어 루틴 생성"""
        dryness = sensitivity.get('dryness', {}).get('score', 50.0)
        
        if dryness > 70:  # 건성
            return [
                {"step": 1, "type": "cleanser", "description": "저자극 클렌저로 부드럽게 세안하세요", "product_example": None, "icon_asset": None},
                {"step": 2, "type": "toner", "description": "보습 토너로 수분을 공급하세요", "product_example": None, "icon_asset": None},
                {"step": 3, "type": "essence", "description": "히알루론산 에센스를 사용하세요", "product_example": None, "icon_asset": None},
                {"step": 4, "type": "moisturizer", "description": "크림 타입 보습제로 마무리하세요", "product_example": None, "icon_asset": None},
                {"step": 5, "type": "sunscreen", "description": "자외선 차단제를 꼭 바르세요", "product_example": None, "icon_asset": None},
            ]
        elif dryness < 30:  # 지성
            return [
                {"step": 1, "type": "cleanser", "description": "클렌징 폼으로 깨끗하게 세안하세요", "product_example": None, "icon_asset": None},
                {"step": 2, "type": "toner", "description": "수렴 토너로 모공을 관리하세요", "product_example": None, "icon_asset": None},
                {"step": 3, "type": "serum", "description": "가벼운 세럼을 사용하세요", "product_example": None, "icon_asset": None},
                {"step": 4, "type": "moisturizer", "description": "젤 타입 보습제를 사용하세요", "product_example": None, "icon_asset": None},
                {"step": 5, "type": "sunscreen", "description": "논코메도제닉 선크림을 바르세요", "product_example": None, "icon_asset": None},
            ]
        else:  # 정상/복합성
            return [
                {"step": 1, "type": "cleanser", "description": "pH 밸런스 클렌저로 세안하세요", "product_example": None, "icon_asset": None},
                {"step": 2, "type": "toner", "description": "밸런싱 토너를 사용하세요", "product_example": None, "icon_asset": None},
                {"step": 3, "type": "essence", "description": "피부 타입에 맞는 에센스를 사용하세요", "product_example": None, "icon_asset": None},
                {"step": 4, "type": "moisturizer", "description": "가볍게 보습하세요", "product_example": None, "icon_asset": None},
                {"step": 5, "type": "sunscreen", "description": "자외선 차단제는 필수입니다", "product_example": None, "icon_asset": None},
            ]
    
    @staticmethod
    def _guess_product_type(text: str, default: str = 'essence') -> str:
        """텍스트에서 제품 타입 추정"""
        text_lower = text.lower()
        
        if any(word in text_lower for word in ['cleanse', '클렌저', '세안', 'wash']):
            return 'cleanser'
        if any(word in text_lower for word in ['toner', '토너', 'skin']):
            return 'toner'
        if any(word in text_lower for word in ['essence', '에센스']):
            return 'essence'
        if any(word in text_lower for word in ['serum', '세럼', 'ampoule']):
            return 'serum'
        if any(word in text_lower for word in ['moistur', '보습', 'cream', '크림', 'lotion']):
            return 'moisturizer'
        if any(word in text_lower for word in ['sun', '자외선', 'spf', 'sunscreen']):
            return 'sunscreen'
        
        return default