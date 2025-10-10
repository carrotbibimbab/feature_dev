from pydantic_settings import BaseSettings
from functools import lru_cache
from pathlib import Path
from typing import Optional
import os

class Settings(BaseSettings):
   # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str
    SUPABASE_SERVICE_KEY: str
    
    # OpenAI
    OPENAI_API_KEY: str
    environment: str = "development"
    # Server - 
    HOST: str = "0.0.0.0"  
    PORT: int = 8000 
    DEBUG: bool = False  # 프로덕션에서는 False

    ALLOWED_ORIGINS: str = "*"
    
    # Storage
    STORAGE_BUCKET: str = "user-images"
    MAX_FILE_SIZE_MB: int = 10
    
    # Model Paths - 절대 경로 사용
    colorinsight_path: str = "Colorinsight-main"  
    nia_checkpoint_path: str = "NIA/checkpoints"
    colorinsight_model_path: str = "Colorinsight-main/facer/best_model_resnet_ALL.pth"
    colorinsight_cp_path: str = "Colorinsight-main/facer/cp/79999_iter.pth"
    
    # Analysis Thresholds
    MIN_FACE_CONFIDENCE: float = 0.5
    IMAGE_QUALITY_THRESHOLD: float = 0.6
    
    
    
    class Config:
        env_file = ".env"
        extra ="ignore"
        case_sensitive = False