# app/services/model_loader.py

import os
import requests
from pathlib import Path

def download_model_if_needed(url: str, local_path: str):
    """모델이 없으면 다운로드"""
    if not os.path.exists(local_path):
        print(f"Downloading model to {local_path}...")
        response = requests.get(url, stream=True)
        
        os.makedirs(os.path.dirname(local_path), exist_ok=True)
        
        with open(local_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print("Download complete!")

# 사용
download_model_if_needed(
    "https://your-storage.com/best_model_resnet_ALL.pth",
    "Colorinsight-main/facer/best_model_resnet_ALL.pth"
)