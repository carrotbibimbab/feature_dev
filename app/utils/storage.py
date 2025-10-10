"""
Supabase Storage 유틸리티
"""

from supabase import Client
from datetime import datetime
import uuid


def upload_to_supabase_storage(
    supabase: Client,
    bucket: str,
    file_path: str,
    file_data: bytes
) -> tuple:
    """
    Supabase Storage에 파일 업로드
    
    Returns:
        (storage_path, public_url)
    """
    try:
        # 업로드
        response = supabase.storage.from_(bucket).upload(
            file_path,
            file_data,
            file_options={"content-type": "image/jpeg"}
        )
        
        # Public URL 생성
        public_url = supabase.storage.from_(bucket).get_public_url(file_path)
        
        return file_path, public_url
        
    except Exception as e:
        raise Exception(f"Storage 업로드 실패: {str(e)}")