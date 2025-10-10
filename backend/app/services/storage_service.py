"""
Supabase Storage & Database 서비스
이미지 업로드 및 분석 결과 저장 (프론트엔드 형식)
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
    
    async def save_analysis_result_formatted(
        self,
        user_id: str,
        formatted_result: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        프론트엔드 형식의 분석 결과를 analyses 테이블에 저장
        
        Args:
            user_id: 사용자 ID
            formatted_result: ResponseFormatter로 변환된 결과
        
        Returns:
            저장된 레코드
        """
        
        try:
            # 이미지 상태 업데이트
            image_id = formatted_result.get("image_id")
            if image_id:
                self.client.table("uploaded_images").update({
                    "analysis_status": "completed",
                    "analyzed_at": datetime.utcnow().isoformat()
                }).eq("id", image_id).execute()
            
            # analyses 테이블에 저장 (프론트엔드 형식 그대로)
            analysis_data = {
                "id": formatted_result.get("id"),
                "user_id": user_id,
                "image_id": formatted_result.get("image_id"),
                
                # 퍼스널 컬러
                "personal_color": formatted_result.get("personal_color"),
                "personal_color_confidence": formatted_result.get("personal_color_confidence"),
                "personal_color_description": formatted_result.get("personal_color_description"),
                "best_colors": formatted_result.get("best_colors"),
                "worst_colors": formatted_result.get("worst_colors"),
                
                # 피부 타입
                "detected_skin_type": formatted_result.get("detected_skin_type"),
                "skin_type_description": formatted_result.get("skin_type_description"),
                
                # 민감성
                "sensitivity_score": formatted_result.get("sensitivity_score"),
                "sensitivity_level": formatted_result.get("sensitivity_level"),
                "risk_factors": formatted_result.get("risk_factors"),
                
                # 피부 상세 분석
                "pore_score": formatted_result.get("pore_score"),
                "pore_description": formatted_result.get("pore_description"),
                "wrinkle_score": formatted_result.get("wrinkle_score"),
                "wrinkle_description": formatted_result.get("wrinkle_description"),
                "elasticity_score": formatted_result.get("elasticity_score"),
                "elasticity_description": formatted_result.get("elasticity_description"),
                "acne_score": formatted_result.get("acne_score"),
                "acne_description": formatted_result.get("acne_description"),
                "pigmentation_score": formatted_result.get("pigmentation_score"),
                "pigmentation_description": formatted_result.get("pigmentation_description"),
                "redness_score": formatted_result.get("redness_score"),
                "redness_description": formatted_result.get("redness_description"),
                
                # 스킨케어 루틴
                "skincare_routine": formatted_result.get("skincare_routine"),
                
                # 얼굴 인식
                "face_detected": formatted_result.get("face_detected"),
                "face_quality_score": formatted_result.get("face_quality_score"),
                
                # 원본 데이터
                "raw_analysis_data": formatted_result.get("raw_analysis_data"),
                
                # 타임스탬프
                "created_at": formatted_result.get("created_at")
            }
            
            result = self.client.table("analyses").insert(analysis_data).execute()
            
            return result.data[0] if result.data else formatted_result
        
        except Exception as e:
            # 실패 시 이미지 상태 업데이트
            try:
                if image_id:
                    self.client.table("uploaded_images").update({
                        "analysis_status": "failed"
                    }).eq("id", image_id).execute()
            except:
                pass
            
            raise HTTPException(
                status_code=500,
                detail=f"분석 결과 저장 실패: {str(e)}"
            )
    
    async def get_user_analyses_formatted(
        self,
        user_id: str,
        limit: int = 10
    ) -> List[Dict[str, Any]]:
        """
        사용자의 분석 히스토리 조회 (프론트엔드 형식)
        
        Returns:
            AnalysisResult 형식의 배열
        """
        
        try:
            result = self.client.table("analyses")\
                .select("*")\
                .eq("user_id", user_id)\
                .order("created_at", desc=True)\
                .limit(limit)\
                .execute()
            
            # 데이터가 없으면 빈 배열 반환
            if not result.data:
                return []
            
            # 프론트엔드 형식 그대로 반환
            return result.data
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"히스토리 조회 실패: {str(e)}"
            )
    
    async def get_analysis_by_id_formatted(
        self,
        analysis_id: str,
        user_id: str
    ) -> Optional[Dict[str, Any]]:
        """
        특정 분석 결과 조회 (프론트엔드 형식, 본인만)
        
        Returns:
            AnalysisResult 형식의 객체 또는 None
        """
        
        try:
            result = self.client.table("analyses")\
                .select("*")\
                .eq("id", analysis_id)\
                .eq("user_id", user_id)\
                .single()\
                .execute()
            
            # 프론트엔드 형식 그대로 반환
            return result.data if result.data else None
        
        except Exception as e:
            # single()은 데이터가 없으면 에러를 발생시킬 수 있음
            print(f"분석 조회 에러: {e}")
            return None


# 싱글톤 인스턴스
storage_service = StorageService()