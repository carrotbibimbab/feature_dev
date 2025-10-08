"""
이미지 처리 유틸리티
"""

import cv2
import numpy as np
from io import BytesIO


def read_image_from_bytes(image_bytes: bytes) -> np.ndarray:
    """
    바이트에서 OpenCV 이미지로 변환
    
    Args:
        image_bytes: 이미지 바이트
        
    Returns:
        BGR 이미지 (OpenCV 형식)
    """
    nparr = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if image is None:
        raise ValueError("이미지 디코딩 실패")
    
    return image