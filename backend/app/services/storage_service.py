"""
Supabase Storage & Database 서비스
이미지 업로드 및 분석 결과 저장
"""
import os
import uuid
from typing import Dict, Any, List, Optional
from datetime import datetime
from fastapi import UploadFile, HTTPException
from supabase import create_client, Client


class StorageService:
    """Supabase Storage & Database 서비스"""
    
    def __init__(self):
        supabase_url = os.getenv("SUPABASE_URL")
        supabase_key = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")
        
        if not supabase_url or not supabase_key:
            raise ValueError("SUPABASE_URL 및 SUPABASE_KEY 환경변수가 필요합니다")
        
        self.client: Client = create_client(supabase_url, supabase_key)
    
    async def upload_analysis_image(
        self,
        user_id: str,
        file: UploadFile
    ) -> Dict[str, str]:
        """
        분석용 이미지를 Supabase Storage에 업로드
        
        Returns:
            {
                "image_id": "uuid",
                "storage_path": "user_id/filename.jpg",
                "image_url": "https://..."
            }
        """
        
        # 고유 파일명 생성
        file_ext = file.filename.split('.')[-1] if '.' in file.filename else 'jpg'
        unique_filename = f"{uuid.uuid4()}.{file_ext}"
        storage_path = f"{user_id}/{unique_filename}"
        
        try:
            # 파일 읽기
            image_content = await file.read()
            await file.seek(0)  # 리셋
            
            # Supabase Storage 업로드
            # bucket name: 'analysis-images' (Supabase Dashboard에서 생성 필요)
            self.client.storage.from_("analysis-images").upload(
                path=storage_path,
                file=image_content,
                file_options={"content-type": file.content_type}
            )
            
            # Public URL 생성
            public_url = self.client.storage.from_("analysis-images").get_public_url(storage_path)
            
            # uploaded_images 테이블에 기록
            image_record = {
                "user_id": user_id,
                "storage_path": storage_path,
                "image_url": public_url,
                "file_size": len(image_content),
                "analysis_status": "pending",
                "uploaded_at": datetime.utcnow().isoformat()
            }
            
            result = self.client.table("uploaded_images").insert(image_record).execute()
            image_id = result.data[0]["id"]
            
            return {
                "image_id": image_id,
                "storage_path": storage_path,
                "image_url": public_url
            }
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"이미지 업로드 실패: {str(e)}"
            )
    
    async def save_analysis_result(
        self,
        user_id: str,
        image_id: str,
        ai_result: Dict[str, Any],
        concerns: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        AI 분석 결과를 analyses 테이블에 저장
        
        Args:
            user_id: 사용자 ID
            image_id: 업로드된 이미지 ID
            ai_result: AI API 응답 결과
            concerns: 사용자가 입력한 피부 고민
        """
        
        try:
            # 이미지 상태 업데이트
            self.client.table("uploaded_images").update({
                "analysis_status": "completed",
                "analyzed_at": datetime.utcnow().isoformat()
            }).eq("id", image_id).execute()
            
            # 분석 결과 추출
            sensitivity = ai_result.get("sensitivity", {})
            ai_analysis = ai_result.get("analysis", {})
            
            # analyses 테이블에 저장
            analysis_data = {
                "user_id": user_id,
                "image_id": image_id,
                
                # 민감성 분석 결과 저장
                "sensitivity_score": sensitivity.get("sensitivity_score"),
                "risk_factors": sensitivity.get("risk_factors", []),
                "caution_ingredients": sensitivity.get("caution_ingredients", []),
                "safe_ingredients": sensitivity.get("safe_ingredients", []),
                "recommendations": ai_analysis.get("recommendations", []),
                
                # 전체 데이터 백업 (JSONB)
                "analysis_data": {
                    "sensitivity": sensitivity,
                    "analysis": ai_analysis,
                    "user_concerns": concerns
                },
                
                "created_at": datetime.utcnow().isoformat()
            }
            
            result = self.client.table("analyses").insert(analysis_data).execute()
            
            return result.data[0] if result.data else {}
        
        except Exception as e:
            # 실패 시 이미지 상태 업데이트
            try:
                self.client.table("uploaded_images").update({
                    "analysis_status": "failed"
                }).eq("id", image_id).execute()
            except:
                pass
            
            raise HTTPException(
                status_code=500,
                detail=f"분석 결과 저장 실패: {str(e)}"
            )
    
    async def get_user_analyses(
        self,
        user_id: str,
        limit: int = 10
    ) -> List[Dict[str, Any]]:
        """사용자의 분석 히스토리 조회"""
        
        try:
            result = self.client.table("analyses")\
                .select("*, uploaded_images(image_url, uploaded_at)")\
                .eq("user_id", user_id)\
                .order("created_at", desc=True)\
                .limit(limit)\
                .execute()
            
            return result.data
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"히스토리 조회 실패: {str(e)}"
            )
    
    async def get_analysis_by_id(
        self,
        analysis_id: str,
        user_id: str
    ) -> Optional[Dict[str, Any]]:
        """특정 분석 결과 조회 (본인만)"""
        
        try:
            result = self.client.table("analyses")\
                .select("*, uploaded_images(image_url, uploaded_at)")\
                .eq("id", analysis_id)\
                .eq("user_id", user_id)\
                .single()\
                .execute()
            
            return result.data if result.data else None
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"분석 조회 실패: {str(e)}"
            )


# 싱글톤 인스턴스
storage_service = StorageService()