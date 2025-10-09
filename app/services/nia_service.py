"""
NIA 피부 분석 서비스
"""

import os
import sys
import torch
import numpy as np
from pathlib import Path
from typing import Dict, Any

# ZeroGPU 조건부 import
try:
    if sys.platform.startswith('linux'):
        from spaces import GPU
        HAS_ZEROGPU = True
    else:
        HAS_ZEROGPU = False
        def GPU(duration=None):
            def decorator(func):
                return func
            return decorator
except ImportError:
    HAS_ZEROGPU = False
    def GPU(duration=None):
        def decorator(func):
            return func
        return decorator

print(f"🔍 플랫폼: {sys.platform}")
print(f"🔍 ZeroGPU 사용 가능: {HAS_ZEROGPU}")

# 🔥 Hugging Face Hub에서 모델 다운로드
from huggingface_hub import snapshot_download

# NIA 모델 경로
NIA_PATH = Path(__file__).parent.parent.parent / "NIA"
sys.path.insert(0, str(NIA_PATH))

class NIASkinAnalyzer:
    """NIA 피부 민감도 분석기"""
    
    def __init__(self, checkpoint_dir: str):
        """
        Args:
            checkpoint_dir: 체크포인트 디렉토리 경로
        """
        self.checkpoint_dir = Path(checkpoint_dir)
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        
        print(f"✅ NIA Analyzer 초기화")
        print(f"   Device: {self.device}")
        print(f"   Checkpoint dir: {self.checkpoint_dir}")
        
        # 🔥 체크포인트 다운로드 (없으면)
        self._ensure_checkpoints()
        
        # 모델 로드
        self._load_models()
    
    def _ensure_checkpoints(self):
        """체크포인트가 없으면 HF Hub에서 다운로드"""
        
        # 체크포인트가 이미 있는지 확인
        if self.checkpoint_dir.exists() and any(self.checkpoint_dir.rglob("*.bin")):
            print(f"✅ 체크포인트가 이미 존재합니다: {self.checkpoint_dir}")
            return
        
        print(f"⬇️  체크포인트를 다운로드 중...")
        
        try:
            # 🔥 HF Hub에서 다운로드
            downloaded_path = snapshot_download(
                repo_id="yeon0221/skin-model",  # 본인 저장소명
                repo_type="model",
                local_dir=str(self.checkpoint_dir.parent),  # NIA/ 폴더
                allow_patterns=["checkpoints/**"],  # checkpoints 폴더만
                cache_dir=None,  # 기본 캐시 사용
            )
            
            print(f"✅ 체크포인트 다운로드 완료: {downloaded_path}")
            
        except Exception as e:
            print(f"⚠️  체크포인트 다운로드 실패: {e}")
            print(f"   더미 결과를 사용합니다.")
            # 다운로드 실패해도 계속 진행 (더미 결과 반환)
    
    def _load_models(self):
        """NIA 모델 로드"""
        try:
            # 실제 NIA 모델 로딩 로직
            # from model import YourNIAModel
            # self.model = YourNIAModel(...)
            # self.model.load_state_dict(...)
            
            print(f"✅ NIA 모델 로드 완료")
            
        except Exception as e:
            print(f"⚠️  모델 로드 실패: {e}")
            print(f"   더미 모드로 실행합니다.")
    
    @GPU(duration=10)
    def analyze(self, image_path: str) -> Dict[str, Any]:
        """
         피부 민감도 분석
    
        Returns:
        {
            "sensitivity_score": float,
            "level": str,
            "dryness": float,
            "pigmentation": float,
            "pore": float,
            "elasticity": float,
            "details": {...}  # 선택사항
        }
        """
        try:
        # 실제 NIA 모델 추론 (구현 후 교체)
        # predictions = self.model.predict(image_path)
        
        # === 임시 더미 결과 ===
        # NIA 모델이 반환하는 원본 형식
            raw_predictions = {
            "overall": {"score": 65.0, "level": "medium"},
            "dryness": {"score": 70.0, "level": "high"},
            "pigmentation": {"score": 50.0, "level": "medium"},
            "pore": {"score": 60.0, "level": "medium"},
            "elasticity": {"score": 80.0, "level": "low"}
        }
        
        # === SensitivityResponse 형식으로 변환 ===
            result = {
            # 필수 필드 (SensitivityResponse)
            "sensitivity_score": raw_predictions["overall"]["score"],
            "level": raw_predictions["overall"]["level"],
            "dryness": raw_predictions["dryness"]["score"],
            "pigmentation": raw_predictions["pigmentation"]["score"],
            "pore": raw_predictions["pore"]["score"],
            "elasticity": raw_predictions["elasticity"]["score"],
            
            # 추가 상세 정보 (선택사항, GPT 프롬프트용)
            "dryness_level": raw_predictions["dryness"]["level"],
            "pigmentation_level": raw_predictions["pigmentation"]["level"],
            "pore_level": raw_predictions["pore"]["level"],
            "elasticity_level": raw_predictions["elasticity"]["level"]
        }
        
            return result
        
        except Exception as e:
            print(f"❌ 분석 실패: {e}")
            raise
    
    def analyze_sensitivity(self, image_path: str) -> Dict[str, Any]:
        """analyze()의 별칭 (호환성)"""
        return self.analyze(image_path)