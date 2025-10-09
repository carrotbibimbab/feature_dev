"""
 분석 오케스트레이터
ColorInsight, NIA, GPT 서비스를 조합하여 종합 분석 수행
"""

from typing import Dict, Any, Optional
import asyncio

from app.services.nia_service import NIASkinAnalyzer
from app.services.gpt_service import GPTSkinAnalysisService
from app.config import Settings

settings = Settings()

class AnalysisOrchestrator:
    """종합 피부 분석 오케스트레이터"""
    
    def __init__(self):
        """서비스 초기화"""
        self.nia_analyzer = NIASkinAnalyzer(
            checkpoint_dir=settings.nia_checkpoint_path
        )
        self.gpt_service = GPTSkinAnalysisService()
    
    async def comprehensive_analysis(
        self,
        image_path: str,
        user_concerns: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        종합 피부 분석 실행
        
        Args:
            image_path: 얼굴 이미지 경로
            user_concerns: 사용자 피부 고민 (선택)
        
        Returns:
            {
                'sensitivity': {...},
                'ai_analysis': {...}
            }
        
        Raises:
            Exception: 분석 실패 시
        """
        
        # 1. 피부 민감도 분석
        try:
            sensitivity_result = await self._analyze_sensitivity(image_path)
        except Exception as e:
            raise Exception(f"민감도 분석 실패: {str(e)}")
        
        # 2. GPT AI 분석
        try:
            ai_result = await self._generate_ai_analysis(
                sensitivity_result,
                user_concerns
            )
        except Exception as e:
            raise Exception(f"AI 분석 실패: {str(e)}")
        
        return {
            'sensitivity': sensitivity_result,
            'ai_analysis': ai_result
        }
    
    async def _analyze_sensitivity(self, image_path: str) -> Dict[str, Any]:
        """피부 민감도 분석 (비동기)"""
        
        # NIA는 동기 함수이므로 run_in_executor 사용
        loop = asyncio.get_event_loop()
        result = await loop.run_in_executor(
            None,
            self.nia_analyzer.analyze_sensitivity,
            image_path
        )
        
        return result
    
    async def _generate_ai_analysis(
        self,
        sensitivity: Dict[str, Any],
        user_concerns: Optional[str]
    ) -> Dict[str, Any]:
        """GPT AI 분석 (비동기)"""
        
        # 🔥 수정: generate_guide → generate_comprehensive_analysis
        result = await self.gpt_service.generate_comprehensive_analysis(
            sensitivity=sensitivity,
            user_concerns=user_concerns
        )
        
        return result
    
    async def sensitivity_only(self, image_path: str) -> Dict[str, Any]:
        """피부 민감도만 분석"""
        return await self._analyze_sensitivity(image_path)
    
    async def explain_score(self, score: float, level: str) -> str:
        """민감도 점수 해석"""
        result = await self.gpt_service.explain_sensitivity_score(score, level)
        return result
    
    def check_services_health(self) -> Dict[str, bool]:
        """서비스 상태 확인"""
        
        import os
        
        status = {
            "nia": False,
            "gpt": False
        }
        
        # NIA 체크
        try:
            nia_checkpoint_dir = './NIA/checkpoints/class/100%/1,2,3'
            status["nia"] = os.path.exists(nia_checkpoint_dir)
        except:
            pass
        
        # GPT 체크
        try:
            status["gpt"] = os.getenv('OPENAI_API_KEY') is not None
        except:
            pass
        
        return status