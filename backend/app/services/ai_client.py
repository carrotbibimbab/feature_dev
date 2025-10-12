import os
import httpx
from typing import Optional, Dict, Any
from fastapi import UploadFile


class AIClient:
    """HuggingFace Space의 FastAPI 엔드포인트 직접 호출"""
    
    def __init__(self):
        self.base_url = os.getenv("AI_API_URL", "").rstrip('/')
        self.hf_token = os.getenv("HF_TOKEN")
        self.timeout = 180.0  # NIA 모델 + GPT 처리 시간
        
        if not self.base_url:
            raise ValueError("AI_API_URL 환경변수가 설정되지 않았습니다")
        
        # FastAPI 엔드포인트
        self.analysis_endpoint = f"{self.base_url}/api/v1/analysis/comprehensive"
        self.health_endpoint = f"{self.base_url}/api/v1/analysis/health"
    
    def _get_headers(self) -> Dict[str, str]:
        """요청 헤더"""
        headers = {}
        if self.hf_token:
            headers["Authorization"] = f"Bearer {self.hf_token}"
        return headers
    
    async def check_health(self) -> Dict[str, Any]:
        """HF Space 상태 확인"""
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(
                    self.health_endpoint,
                    headers=self._get_headers()
                )
                
                if response.status_code == 200:
                    health_data = response.json()
                    return {
                        "status": "healthy" if health_data.get("status") == "healthy" else "partial",
                        "url": self.base_url,
                        "services": health_data.get("services", {}),
                        "message": "HF Space FastAPI is running"
                    }
                else:
                    return {
                        "status": "unhealthy",
                        "url": self.base_url,
                        "status_code": response.status_code
                    }
        except Exception as e:
            return {
                "status": "error",
                "url": self.base_url,
                "error": str(e)
            }
    
    async def comprehensive_analysis(
        self,
        image_file: UploadFile,
        concerns: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        HF Space의 FastAPI 엔드포인트 직접 호출
        
        POST /api/v1/analysis/comprehensive
        - file: 이미지 파일
        - user_id: 사용자 ID (임시값 사용)
        - concerns: 피부 고민
        
        Returns:
            HF Space의 응답을 Flutter 모델 형식으로 변환
        """
        
        try:
            # 이미지 데이터 읽기
            image_bytes = await image_file.read()
            
            async with httpx.AsyncClient(timeout=self.timeout) as client:
                
                # multipart/form-data 요청
                files = {
                    'file': (image_file.filename, image_bytes, image_file.content_type)
                }
                
                data = {
                    'user_id': '00000000-0000-0000-0000-000000000001',  # 임시 ID
                    'concerns': concerns or ''
                }
                
                print(f"🔄 HF Space 요청: {self.analysis_endpoint}")
                
                response = await client.post(
                    self.analysis_endpoint,
                    files=files,
                    data=data,
                    headers=self._get_headers()
                )
                
                if response.status_code != 200:
                    raise Exception(
                        f"HF Space 분석 실패: {response.status_code} - {response.text[:200]}"
                    )
                
                result = response.json()
                
                print(f"✅ HF Space 응답 수신")
                print(f"   - success: {result.get('success')}")
                print(f"   - sensitivity_score: {result.get('sensitivity', {}).get('sensitivity_score')}")
                
                # HF Space 응답 → 표준 형식 변환
                return self._parse_hf_space_response(result)
        
        except httpx.TimeoutException:
            raise Exception(
                "AI 서비스 응답 시간 초과 (3분). "
                "HF Space가 슬립 상태일 수 있습니다. 다시 시도해주세요."
            )
        except Exception as e:
            raise Exception(f"AI 분석 중 오류 발생: {str(e)}")
    
    def _parse_hf_space_response(self, raw_result: Dict[str, Any]) -> Dict[str, Any]:
        """
        HF Space의 응답을 표준 형식으로 변환
        
        HF Space 응답 구조:
        {
            "success": true,
            "sensitivity": {
                "sensitivity_score": 75.0,
                "level": "medium",
                "dryness": 60.0,
                "pigmentation": 50.0,
                "pore": 70.0,
                "elasticity": 80.0,
                "risk_factors": [...],
                "caution_ingredients": [...],
                "safe_ingredients": [...],
                "recommendations": [...]
            },
            "ai_analysis": {
                "summary": "...",
                "recommendations": [...],
                "cautions": [...],
                "full_content": "...",
                "tokens_used": 1234
            },
            "timestamp": "2025-01-15T10:30:00"
        }
        """
        
        if not raw_result.get("success"):
            raise Exception("HF Space 분석 실패")
        
        sensitivity = raw_result.get("sensitivity", {})
        ai_analysis = raw_result.get("ai_analysis", {})
        
        # 민감도 레벨 매핑 (HF Space → Flutter)
        level_mapping = {
            'low': 'safe',
            'medium': 'moderate',
            'high': 'caution'
        }
        hf_level = sensitivity.get('level', 'medium')
        flutter_level = level_mapping.get(hf_level, 'moderate')
        
        # 민감도 점수 (0-100 → 0-10)
        sensitivity_score = sensitivity.get('sensitivity_score', 0)
        normalized_score = min(sensitivity_score / 10, 10.0)
        
        return {
            # NIA 민감도 분석
            "sensitivity_analysis": {
                "sensitivity_score": normalized_score,  # 0-10
                "sensitivity_level": flutter_level,
                "risk_factors": sensitivity.get('risk_factors', []),
                
                # 상세 지표 (0-100)
                "pore_score": int(sensitivity.get('pore', 0)),
                "elasticity_score": int(sensitivity.get('elasticity', 0)),
                "pigmentation_score": int(sensitivity.get('pigmentation', 0)),
                "dryness": sensitivity.get('dryness', 0),
                
                # 성분 정보
                "caution_ingredients": sensitivity.get('caution_ingredients', []),
                "safe_ingredients": sensitivity.get('safe_ingredients', []),
                "recommendations": sensitivity.get('recommendations', [])
            },
            
            # GPT AI 가이드
            "ai_guide": {
                "summary": ai_analysis.get('summary', ''),
                "recommendations": ai_analysis.get('recommendations', []),
                "cautions": ai_analysis.get('cautions', []),
                "full_content": ai_analysis.get('full_content', ''),
                "tokens_used": ai_analysis.get('tokens_used', 0)
            },
            
            # 메타데이터
            "analyzed_at": raw_result.get('timestamp', ''),
            "analysis_version": "nia_v1.0"
        }


# 싱글톤 인스턴스
try:
    ai_client = AIClient()
    print(f"✅ AI Client 초기화 성공: {ai_client.base_url}")
except Exception as e:
    print(f"⚠️ AI Client 초기화 실패: {e}")
    ai_client = None