"""
NIA 한국인 피부상태 분석 모델 - VUPA 통합 서비스
torchvision ResNet50 기반 (NIA 원본 구조 완전 호환)
"""

import torch
import torch.nn as nn
from torchvision import models
from torchvision.models import ResNet50_Weights
from torchvision import transforms
from PIL import Image
import os
import sys
import numpy as np

try:
    # Linux (HF Spaces)에서만 작동
    if sys.platform.startswith('linux'):
        from spaces import GPU
        HAS_ZEROGPU = True
    else:
        # Windows/Mac에서는 더미 데코레이터
        HAS_ZEROGPU = False
        def GPU(duration=None):
            """더미 GPU 데코레이터 (로컬 개발용)"""
            def decorator(func):
                return func
            return decorator
except ImportError:
    # spaces 패키지가 없는 경우 (로컬 개발)
    HAS_ZEROGPU = False
    def GPU(duration=None):
        """더미 GPU 데코레이터 (로컬 개발용)"""
        def decorator(func):
            return func
        return decorator

print(f"🔍 ZeroGPU 사용 가능: {HAS_ZEROGPU}")
class NIASkinAnalyzer:
    """NIA 한국인 피부상태 분석 모델 (원본 구조 완전 호환)"""
    
    def __init__(self, checkpoint_dir: str = '../NIA/checkpoints'):
        self.checkpoint_dir = checkpoint_dir
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
        # 이미지 전처리 (ResNet50 표준)
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(
                mean=[0.485, 0.456, 0.406],
                std=[0.229, 0.224, 0.225]
            )
        ])
        
        # 모델 출력 크기 정의 (NIA 원본과 동일)
        self.class_num_output = [np.nan, 15, 7, 7, 0, 12, 0, 5, 7]
        #                        [0,     1,  2, 3, 4, 5,  6, 7, 8]
        #                        [전체, 이마, 미간, 눈가, -, 볼, -, 입술, 턱]
        
        self.regression_num_output = [1, 2, np.nan, 1, 0, 3, 0, np.nan, 2]
        #                             [0, 1, 2,     3, 4, 5, 6, 7,     8]
        
        # 부위별 이름 매핑
        self.area_names = {
            0: 'overall',      # 전체
            1: 'forehead',     # 이마
            2: 'glabella',     # 미간
            3: 'eye',          # 눈가
            5: 'cheek',        # 볼
            7: 'lip',          # 입술
            8: 'jaw'           # 턱
        }
        
        # 분류 항목 상세 (BF 민감도 분석용)
        self.class_features = {
            1: {'name': 'forehead_wrinkle', 'desc': '이마 주름', 'classes': 15},
            2: {'name': 'glabella_wrinkle', 'desc': '미간 주름', 'classes': 7},
            3: {'name': 'eye_wrinkle', 'desc': '눈가 주름', 'classes': 7},
            5: {'name': 'cheek_pigmentation', 'desc': '볼 색소침착', 'classes': 12},
            7: {'name': 'lip_dryness', 'desc': '입술 건조도', 'classes': 5},
            8: {'name': 'jaw_sagging', 'desc': '턱선 처짐', 'classes': 7}
        }
        
        self.regression_features = {
            0: {'name': 'overall_pigmentation', 'desc': '전체 색소침착', 'outputs': 1},
            1: {'name': 'forehead_moisture_elasticity', 'desc': '이마 수분/탄력', 'outputs': 2},
            3: {'name': 'eye_wrinkle', 'desc': '눈가 주름', 'outputs': 1},
            5: {'name': 'cheek_moisture_elasticity_pore', 'desc': '볼 수분/탄력/모공', 'outputs': 3},
            8: {'name': 'jaw_moisture_elasticity', 'desc': '턱 수분/탄력', 'outputs': 2}
        }
        
        # 모델 캐시 (lazy loading)
        self.loaded_class_models = {}
        self.loaded_regression_models = {}
    
    
    def _create_model(self, num_classes: int):
        """
        NIA 원본과 동일한 방식으로 ResNet50 모델 생성
        
        Args:
            num_classes: fc layer 출력 크기
        
        Returns:
            수정된 ResNet50 모델
        """
        # torchvision ResNet50 로드 (ImageNet pretrained)
        model = models.resnet50(weights=ResNet50_Weights.DEFAULT)
        
        # fc layer만 교체 (NIA 원본 방식)
        model.fc = nn.Linear(model.fc.in_features, num_classes)
        
        return model
    
    
    def _load_model(self, mode: str, model_id: int):
        """
        체크포인트에서 모델 로드 (처음 사용 시에만)
        
        Args:
            mode: 'class' 또는 'regression'
            model_id: 모델 인덱스 (0-8)
        
        Returns:
            로드된 모델
        """
        # 캐시 확인
        if mode == 'class':
            if model_id in self.loaded_class_models:
                return self.loaded_class_models[model_id]
            num_classes = self.class_num_output[model_id]
        else:
            if model_id in self.loaded_regression_models:
                return self.loaded_regression_models[model_id]
            num_classes = self.regression_num_output[model_id]
        
        # nan 체크
        if np.isnan(num_classes):
            raise ValueError(f"{mode} 모드에서 모델 {model_id}는 사용할 수 없습니다")
        
        # 모델 생성
        model = self._create_model(int(num_classes))
        
        # 체크포인트 경로
        checkpoint_path = os.path.join(
            self.checkpoint_dir,
            mode,
            '100%/1,2,3',
            str(model_id),
            'state_dict.bin'
        )
        
        if not os.path.exists(checkpoint_path):
            raise FileNotFoundError(f"체크포인트 없음: {checkpoint_path}")
        
        # state_dict 로드
        checkpoint = torch.load(checkpoint_path, map_location=self.device)
        
        # NIA는 전체 checkpoint를 저장 (model_state, epoch, best_loss)
        if 'model_state' in checkpoint:
            model.load_state_dict(checkpoint['model_state'])
        else:
            model.load_state_dict(checkpoint)
        
        model.to(self.device)
        model.eval()
        
        # 캐시에 저장
        if mode == 'class':
            self.loaded_class_models[model_id] = model
        else:
            self.loaded_regression_models[model_id] = model
        
        return model
    
    @GPU(duration=10)  # 10초 GPU 할당

    def analyze_sensitivity(self, image_path: str) -> dict:
        """
        BF 민감도 종합 분석
        
        Args:
            image_path: 얼굴 이미지 경로
        
        Returns:
            {
                'sensitivity_score': 0-100,
                'dryness': 0-100,
                'pigmentation': 0-100,
                'pore': 0-100,
                'elasticity': 0-100,
                'level': 'low'|'medium'|'high',
                'details': {...}
            }
        """
        # 이미지 로드 및 전처리
        image = Image.open(image_path).convert('RGB')
        input_tensor = self.transform(image).unsqueeze(0).to(self.device)
        
        with torch.no_grad():
            # 1. 건조도 분석 (입술 건조도 - Classification)
            # model_id=7, classes=5 (0~4등급)
            lip_model = self._load_model('class', 7)
            lip_output = lip_model(input_tensor)
            lip_class = torch.argmax(lip_output, dim=1).item()
            dryness_score = (lip_class / 4) * 100  # 0-4 → 0-100
            
            # 2. 색소침착 분석 (전체 - Regression)
            # model_id=0, outputs=1
            pigment_model = self._load_model('regression', 0)
            pigment_value = pigment_model(input_tensor).squeeze().item()
            pigmentation_score = min(max(pigment_value * 100, 0), 100)
            
            # 3. 모공 분석 (볼 - Regression, 3번째 출력값)
            # model_id=5, outputs=3 (수분, 탄력, 모공)
            cheek_model = self._load_model('regression', 5)
            cheek_values = cheek_model(input_tensor).squeeze()
            pore_value = cheek_values[2].item()  # 모공은 3번째
            pore_score = min(max(pore_value * 100, 0), 100)
            
            # 4. 탄력 분석 (턱 - Regression, 2번째 출력값)
            # model_id=8, outputs=2 (수분, 탄력)
            jaw_model = self._load_model('regression', 8)
            jaw_values = jaw_model(input_tensor).squeeze()
            elasticity_value = jaw_values[1].item()  # 탄력은 2번째
            elasticity_score = min(max((1 - elasticity_value) * 100, 0), 100)
        
        # 민감도 종합 점수 (가중 평균)
        sensitivity_score = (
            dryness_score * 0.3 +        # 건조도 30%
            pigmentation_score * 0.3 +   # 색소침착 30%
            pore_score * 0.2 +           # 모공 20%
            elasticity_score * 0.2       # 탄력 20%
        )
        
        return {
            'sensitivity_score': round(sensitivity_score, 1),
            'dryness': round(dryness_score, 1),
            'pigmentation': round(pigmentation_score, 1),
            'pore': round(pore_score, 1),
            'elasticity': round(elasticity_score, 1),
            'level': self._get_sensitivity_level(sensitivity_score),
            'details': {
                'lip_dryness_grade': lip_class,
                'cheek_moisture': round(cheek_values[0].item(), 3),
                'cheek_elasticity': round(cheek_values[1].item(), 3),
                'jaw_moisture': round(jaw_values[0].item(), 3)
            }
        }
    
    
    def _get_sensitivity_level(self, score: float) -> str:
        """민감도 등급 반환"""
        if score >= 70:
            return 'high'
        elif score >= 40:
            return 'medium'
        else:
            return 'low'
    
    
    def get_full_analysis(self, image_path: str) -> dict:
        """
        전체 항목 상세 분석 (디버깅/검증용)
        
        Returns:
            {
                'classification': {...},
                'regression': {...}
            }
        """
        image = Image.open(image_path).convert('RGB')
        input_tensor = self.transform(image).unsqueeze(0).to(self.device)
        
        classification_results = {}
        regression_results = {}
        
        with torch.no_grad():
            # Classification 모델 전체 실행
            for model_id, info in self.class_features.items():
                try:
                    model = self._load_model('class', model_id)
                    output = model(input_tensor)
                    class_pred = torch.argmax(output, dim=1).item()
                    confidence = torch.softmax(output, dim=1)[0][class_pred].item()
                    
                    classification_results[info['name']] = {
                        'grade': class_pred,
                        'max_grade': info['classes'] - 1,
                        'confidence': round(confidence * 100, 1),
                        'description': info['desc']
                    }
                except Exception as e:
                    classification_results[info['name']] = {
                        'error': str(e)
                    }
            
            # Regression 모델 전체 실행
            for model_id, info in self.regression_features.items():
                try:
                    model = self._load_model('regression', model_id)
                    values = model(input_tensor).squeeze()
                    
                    # 출력이 여러 개인 경우 리스트로 변환
                    if values.dim() == 0:
                        values = [values.item()]
                    else:
                        values = values.tolist()
                    
                    regression_results[info['name']] = {
                        'values': [round(v, 4) for v in values],
                        'description': info['desc']
                    }
                except Exception as e:
                    regression_results[info['name']] = {
                        'error': str(e)
                    }
        
        return {
            'classification': classification_results,
            'regression': regression_results
        }


# ============================================================================
# FastAPI 통합 예시
# ============================================================================
"""
# app/api/analysis.py

from fastapi import FastAPI, UploadFile, File
from app.services.nia_service import NIASkinAnalyzer
import os

app = FastAPI()
nia_analyzer = NIASkinAnalyzer(checkpoint_dir='./NIA/checkpoints')

@app.post("/api/analyze/sensitivity")
async def analyze_sensitivity(file: UploadFile = File(...)):
    '''민감도 분석 API'''
    
    # 임시 파일 저장
    temp_path = f"/tmp/{file.filename}"
    with open(temp_path, "wb") as f:
        f.write(await file.read())
    
    try:
        # 분석 실행
        result = nia_analyzer.analyze_sensitivity(temp_path)
        
        return {
            "success": True,
            "data": result
        }
    
    finally:
        # 임시 파일 삭제
        if os.path.exists(temp_path):
            os.remove(temp_path)


@app.post("/api/analyze/full")
async def full_analysis(file: UploadFile = File(...)):
    '''전체 상세 분석 API (디버깅용)'''
    
    temp_path = f"/tmp/{file.filename}"
    with open(temp_path, "wb") as f:
        f.write(await file.read())
    
    try:
        result = nia_analyzer.get_full_analysis(temp_path)
        return {"success": True, "data": result}
    
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)
"""