# """
# ColorInsight 모델 통합 서비스
# """

# import sys
# import os
# import tempfile
# import shutil
# from pathlib import Path
# from app.config import Settings

# settings = Settings()

# # ColorInsight 경로 추가
# COLORINSIGHT_PATH = Path(settings.colorinsight_path).resolve()
# sys.path.insert(0, str(COLORINSIGHT_PATH))

# # 모델 파일 절대 경로
# MODEL_PATH = Path(settings.colorinsight_model_path).resolve()
# CP_PATH = Path(settings.colorinsight_cp_path).resolve()

# # import
# import functions as colorinsight_fn
# import skin_model as colorinsight_model


# class ColorInsightService:
#     """ColorInsight 퍼스널 컬러 분석"""
    
#     def __init__(self):
#         self.season_map = {
#             0: 'spring',
#             1: 'summer',
#             2: 'autumn',
#             3: 'winter'
#         }
        
#         # 모델 파일 경로 확인
#         if not MODEL_PATH.exists():
#             raise FileNotFoundError(f"모델 파일을 찾을 수 없습니다: {MODEL_PATH}")
#         if not CP_PATH.exists():
#             raise FileNotFoundError(f"CP 파일을 찾을 수 없습니다: {CP_PATH}")
        
#         print(f"✅ ColorInsight 모델 로드 준비:")
#         print(f"   - 메인 모델: {MODEL_PATH}")
#         print(f"   - CP 모델: {CP_PATH}")
    
#     def analyze_personal_color(self, image_path: str) -> dict:
#         """
#         퍼스널 컬러 분석
        
#         Args:
#             image_path: 이미지 경로
            
#         Returns:
#             {
#                 "season": str,
#                 "confidence": float,
#                 "method": str
#             }
#         """
#         original_cwd = os.getcwd()
#         temp_jpg_path = COLORINSIGHT_PATH / 'temp.jpg'
        
#         try:
#             # 작업 디렉토리를 Colorinsight-main으로 변경
#             os.chdir(COLORINSIGHT_PATH)
            
#             print(f"\n🔍 디버깅 정보:")
#             print(f"   - 원본 이미지: {image_path}")
#             print(f"   - 원본 이미지 존재: {Path(image_path).exists()}")
#             print(f"   - 현재 작업 디렉토리: {os.getcwd()}")
#             print(f"   - temp.jpg 예상 위치: {temp_jpg_path}")
            
#             # 모델 파일 복사
#             local_model = Path('best_model_resnet_ALL.pth')
#             if not local_model.exists():
#                 print(f"   - 모델 파일 복사 중...")
#                 shutil.copy(MODEL_PATH, local_model)
            
#             # 🔥 save_skin_mask 호출 시 에러 캐치
#             print(f"   - save_skin_mask 실행 중...")
#             try:
#                 colorinsight_fn.save_skin_mask(image_path)
#                 print(f"   ✅ save_skin_mask 완료")
#             except Exception as skin_error:
#                 print(f"   ❌ save_skin_mask 에러:")
#                 print(f"      {type(skin_error).__name__}: {str(skin_error)}")
#                 import traceback
#                 traceback.print_exc()
                
#                 # 🔥 임시 해결: 원본 이미지를 temp.jpg로 복사
#                 print(f"   ⚠️  대안: 원본 이미지를 temp.jpg로 복사")
#                 shutil.copy(image_path, temp_jpg_path)
            
#             # temp.jpg 확인
#             if not temp_jpg_path.exists():
#                 raise FileNotFoundError(
#                     f"temp.jpg를 생성할 수 없습니다. "
#                     f"save_skin_mask 에러를 확인하세요."
#                 )
            
#             print(f"   ✅ temp.jpg 확인: {temp_jpg_path}")
            
#             # ResNet 분류
#             print(f"   - get_season 실행 중...")
#             season_idx = colorinsight_model.get_season('temp.jpg')
#             print(f"   ✅ Season Index: {season_idx}")
            
#             # 인덱스 매핑
#             if season_idx == 3:
#                 season_idx = 0
#             elif season_idx == 0:
#                 season_idx = 3
            
#             season = self.season_map.get(season_idx, 'unknown')
#             print(f"   ✅ 최종 Season: {season}")
            
#             return {
#                 "season": season,
#                 "confidence": 0.6,
#                 "method": "ColorInsight ResNet18"
#             }
            
#         except Exception as e:
#             print(f"   ❌ 전체 에러 발생: {str(e)}")
#             import traceback
#             traceback.print_exc()
#             raise Exception(f"ColorInsight 분석 실패: {str(e)}")
        
#         finally:
#             # 작업 디렉토리 복원
#             os.chdir(original_cwd)
            
#             # temp.jpg 삭제
#             if temp_jpg_path.exists():
#                 try:
#                     temp_jpg_path.unlink()
#                     print(f"   🗑️  삭제: {temp_jpg_path}")
#                 except:
#                     pass