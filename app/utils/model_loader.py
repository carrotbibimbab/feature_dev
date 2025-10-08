"""
Supabase Storage에서 모델 다운로드
"""

import os
from pathlib import Path
import requests
from supabase import create_client
from app.config import get_settings

settings = get_settings()

def download_model_from_supabase(storage_path: str, local_path: str) -> bool:
    """
    Supabase Storage에서 모델 다운로드
    
    Args:
        storage_path: Supabase Storage 경로 (예: "colorinsight/best_model_resnet_ALL.pth")
        local_path: 로컬 저장 경로
        
    Returns:
        성공 여부
    """
    try:
        # 이미 파일이 있으면 스킵
        if os.path.exists(local_path):
            print(f"Model already exists: {local_path}")
            return True
        
        print(f"⬇ Downloading: {storage_path} -> {local_path}")
        
        # Supabase 클라이언트
        supabase = create_client(
            settings.SUPABASE_URL,
            settings.SUPABASE_SERVICE_KEY
        )
        
        # 파일 다운로드
        data = supabase.storage.from_('ai-models').download(storage_path)
        
        # 디렉토리 생성
        os.makedirs(os.path.dirname(local_path), exist_ok=True)
        
        # 저장
        with open(local_path, 'wb') as f:
            f.write(data)
        
        print(f" Downloaded: {local_path} ({len(data) / 1024 / 1024:.1f} MB)")
        return True
        
    except Exception as e:
        print(f"Error downloading {storage_path}: {e}")
        return False


def download_all_models():
    """앱 시작 시 모든 모델 다운로드"""
    
    models = [
        # ColorInsight
        {
            "storage": "colorinsight/best_model_resnet_ALL.pth",
            "local": "Colorinsight-main/facer/best_model_resnet_ALL.pth"
        },
        {
            "storage": "colorinsight/cp/79999_iter.pth",
            "local": "Colorinsight-main/facer/cp/79999_iter.pth"
        },
        
        # NIA
        {
            "storage": "nia/moisture_model.pth",
            "local": "NIA/checkpoints/moisture_model.pth"
        },
        {
            "storage": "nia/pigmentation_model.pth",
            "local": "NIA/checkpoints/pigmentation_model.pth"
        },
        {
            "storage": "nia/pore_model.pth",
            "local": "NIA/checkpoints/pore_model.pth"
        },
        {
            "storage": "nia/elasticity_model.pth",
            "local": "NIA/checkpoints/elasticity_model.pth"
        },
    ]
    
    print("\n" + "="*50)
    print("    Loading AI models from Supabase Storage")
    print("="*50)
    
    success_count = 0
    for model in models:
        if download_model_from_supabase(model["storage"], model["local"]):
            success_count += 1
    
    print(f"\nModels loaded: {success_count}/{len(models)}")
    print("="*50 + "\n")
    
    if success_count < len(models):
        print("    Warning: Some models failed to download")
        print("    The application may not work correctly")
    
    return success_count == len(models)