import os
import uuid
from datetime import datetime
from typing import Dict, Any, List, Optional
from fastapi import UploadFile
from supabase import create_client, Client


class StorageService:
    """Supabase Storage 및 DB 연동 서비스 (Flutter 모델 완벽 매칭)"""
    
    def __init__(self):
        supabase_url = os.getenv("SUPABASE_URL")
        supabase_key = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")
        
        if not supabase_url or not supabase_key:
            raise ValueError("SUPABASE_URL 및 SUPABASE_KEY 환경변수가 필요합니다")
        
        self.client: Client = create_client(supabase_url, supabase_key)
        self.bucket_name = "analysis-images"
    
    async def upload_analysis_image(
        self,
        user_id: str,
        file: UploadFile
    ) -> Dict[str, Any]:
        """분석용 이미지를 Supabase Storage에 업로드"""
        
        try:
            image_id = str(uuid.uuid4())
            file_extension = file.filename.split(".")[-1] if "." in file.filename else "jpg"
            file_path = f"{user_id}/{image_id}.{file_extension}"
            
            file_bytes = await file.read()
            
            # Supabase Storage 업로드
            response = self.client.storage.from_(self.bucket_name).upload(
                file_path,
                file_bytes,
                {"content-type": file.content_type}
            )
            
            # Public URL 생성
            public_url = self.client.storage.from_(self.bucket_name).get_public_url(file_path)
            
            return {
                "image_id": image_id,
                "image_url": public_url,
                "file_path": file_path
            }
        
        except Exception as e:
            raise Exception(f"이미지 업로드 실패: {str(e)}")
    
    async def save_analysis_result_formatted(
        self,
        user_id: str,
        formatted_result: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        포맷된 분석 결과를 DB에 저장 (Flutter AnalysisResult 형식)
        
        테이블: analyses
        컬럼: analysis_result.dart의 모든 필드와 일치
        """
        
        try:
            # skincare_routine 변환 (List → JSONB)
            skincare_routine = formatted_result.get("skincare_routine")
            
            insert_data = {
                # 기본 정보
                "id": formatted_result["id"],
                "user_id": user_id,
                "image_id": formatted_result["image_id"],
                
                # 퍼스널 컬러
                "personal_color": formatted_result.get("personal_color"),
                "personal_color_confidence": formatted_result.get("personal_color_confidence"),
                "personal_color_description": formatted_result.get("personal_color_description"),
                "best_colors": formatted_result.get("best_colors"),
                "worst_colors": formatted_result.get("worst_colors"),
                
                # 피부 타입
                "detected_skin_type": formatted_result.get("detected_skin_type"),
                "skin_type_description": formatted_result.get("skin_type_description"),
                
                # 민감성 위험도
                "sensitivity_score": formatted_result.get("sensitivity_score"),
                "sensitivity_level": formatted_result.get("sensitivity_level"),
                "risk_factors": formatted_result.get("risk_factors", []),
                
                # 피부 상세 분석 (6개)
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
                "skincare_routine": skincare_routine,
                
                # 얼굴 인식
                "face_detected": formatted_result.get("face_detected", True),
                "face_quality_score": formatted_result.get("face_quality_score", 1.0),
                
                # 원본 데이터
                "raw_analysis_data": formatted_result.get("raw_analysis_data", {}),
                
                # 타임스탬프
                "created_at": formatted_result.get("created_at", datetime.utcnow().isoformat())
            }
            
            response = self.client.table("analyses").insert(insert_data).execute()
            
            if not response.data:
                print("⚠️ 분석 결과 저장 실패 (응답 없음)")
                return {}
            
            print(f"✅ 분석 결과 저장 성공: {response.data[0]['id']}")
            return response.data[0]
        
        except Exception as e:
            print(f"⚠️ 분석 결과 저장 실패 (계속 진행): {str(e)}")
            return {}
    
    async def get_user_analyses_formatted(
        self,
        user_id: str,
        limit: int = 10
    ) -> List[Dict[str, Any]]:
        """사용자의 분석 히스토리 조회 (Flutter AnalysisResult 형식)"""
        
        try:
            response = self.client.table("analyses")\
                .select("*")\
                .eq("user_id", user_id)\
                .order("created_at", desc=True)\
                .limit(limit)\
                .execute()
            
            # DB 데이터가 이미 Flutter 형식이므로 그대로 반환
            return response.data if response.data else []
        
        except Exception as e:
            raise Exception(f"히스토리 조회 실패: {str(e)}")
    
    async def get_analysis_by_id_formatted(
        self,
        analysis_id: str,
        user_id: str
    ) -> Optional[Dict[str, Any]]:
        """특정 분석 결과 조회 (본인 확인 포함)"""
        
        try:
            response = self.client.table("analyses")\
                .select("*")\
                .eq("id", analysis_id)\
                .eq("user_id", user_id)\
                .single()\
                .execute()
            
            # DB 데이터가 이미 Flutter 형식
            return response.data if response.data else None
        
        except Exception as e:
            print(f"⚠️ 조회 실패: {str(e)}")
            return None


# 싱글톤 인스턴스
try:
    storage_service = StorageService()
    print("✅ Storage Service 초기화 성공")
except Exception as e:
    print(f"⚠️ Storage Service 초기화 실패: {e}")
    storage_service = None