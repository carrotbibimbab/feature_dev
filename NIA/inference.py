import torch
from model import ResNet_Custom # model.py의 클래스 이름에 따라 변경

# 1. 모델 아키텍처 정의 (예: 주름 등급 분류 모델)
# 주름 등급은 0~6까지 7개의 vector를 출력하므로 num_classes=7
model_wrinkle_forehead = ResNet_Custom(num_classes=7) 

# 2. 로컬에 추출된 체크포인트 파일 경로 지정
# 파일 이름은 'checkpoint/regression/moisture_cheek.pth'와 같이 명명되었을 것입니다.
checkpoint_path = './checkpoint/class/wrinkle_forehead.pth' 

# 3. 모델 가중치 로드
try:
    state_dict = torch.load(checkpoint_path)
    model_wrinkle_forehead.load_state_dict(state_dict)
    model_wrinkle_forehead.eval() # 추론 모드로 설정 (필수)
    print(f"{checkpoint_path} 모델 로드 성공.")
except Exception as e:
    print(f"모델 로드 오류: {e}")