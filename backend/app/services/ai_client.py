"""
AI 서비스 클라이언트
HuggingFace Space의 AI API와 통신
"""
import httpx
import os
from typing import Optional, Dict, Any
from fastapi import UploadFile, HTTPException
from dotenv import load_dotenv  

load_dotenv()

class AIServiceClient:
    """AI 분석 서비스 클라이언트"""
    
    def __init__(self):
        
        raw_url = os.getenv("AI_API_URL", "")
        
        # URL 정리
        self.base_url = raw_url.strip().rstrip('/')
        
        # URL 검증 및 수정
        if self.base_url and not self.base_url.startswith('http'):
            # http 없으면 추가
            self.base_url = f"https://{self.base_url}"
        
        # 잘못된 슬래시 제거
        self.base_url = self.base_url.replace('https://', 'https://')  # 중복 방지
        self.base_url = self.base_url.replace(':///', '://')  # 슬래시 3개 수정
        
        self.timeout = int(os.getenv("AI_API_TIMEOUT", "120"))
        
        if not self.base_url:
            raise ValueError("AI_API_URL 환경변수가 설정되지 않았습니다")
        
        # 디버깅 출력
        print(f"🔗 AI Service URL: {self.base_url}")
    
    async def comprehensive_analysis(
        self,
        image_file: UploadFile,
        concerns: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        종합 피부 분석 요청
        
        Args:
            image_file: 업로드된 이미지 파일
            concerns: 사용자 피부 고민 (선택)
        
        Returns:
            {
                "sensitivity": {...},
                "ai_analysis": {...},
                "timestamp": "..."
            }
        """
        
        url = f"{self.base_url}/api/v1/analysis/comprehensive"
        
        # 파일 준비
        image_content = await image_file.read()
        await image_file.seek(0)  # 파일 포인터 리셋
        
        files = {
            "file": (image_file.filename, image_content, image_file.content_type)
        }
        
        # Form 데이터 준비
        data = {}
        if concerns:
            data["concerns"] = concerns
        
        try:
            async with httpx.AsyncClient(timeout=self.timeout) as client:
                response = await client.post(
                    url,
                    files=files,
                    data=data
                )
                
                response.raise_for_status()
                return response.json()
        
        except httpx.TimeoutException:
            raise HTTPException(
                status_code=504,
                detail="AI 분석 시간 초과. 다시 시도해주세요."
            )
        
        except httpx.HTTPStatusError as e:
            error_detail = f"AI 분석 실패 (status {e.response.status_code})"
            try:
                error_body = e.response.json()
                error_detail = f"{error_detail}: {error_body.get('detail', '')}"
            except:
                error_detail = f"{error_detail}: {e.response.text[:200]}"
            
            raise HTTPException(
                status_code=e.response.status_code,
                detail=error_detail
            )
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"AI 서비스 오류: {str(e)}"
            )
    
    async def sensitivity_only(
        self,
        image_file: UploadFile
    ) -> Dict[str, Any]:
        """피부 민감도만 분석"""
        
        url = f"{self.base_url}/api/v1/analysis/sensitivity"
        
        image_content = await image_file.read()
        await image_file.seek(0)
        
        files = {
            "file": (image_file.filename, image_content, image_file.content_type)
        }
        
        try:
            async with httpx.AsyncClient(timeout=self.timeout) as client:
                response = await client.post(url, files=files)
                response.raise_for_status()
                return response.json()
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"민감도 분석 실패: {str(e)}"
            )
    
    async def check_health(self) -> Dict[str, Any]:
        """AI 서비스 상태 확인"""
        
        url = f"{self.base_url}/api/v1/analysis/health"
        
        try:
            async with httpx.AsyncClient(timeout=10) as client:
                response = await client.get(url)
                response.raise_for_status()
                return response.json()
        
        except Exception as e:
            return {
                "status": "unhealthy",
                "error": str(e)
            }


# 싱글톤 인스턴스
ai_client = AIServiceClient()