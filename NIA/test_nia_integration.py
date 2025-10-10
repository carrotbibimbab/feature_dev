"""
NIA 피부 분석 모델 테스트 스크립트
BF 통합 전 동작 확인용
"""

import sys
sys.path.append('../app/services')

from nia_service import NIASkinAnalyzer
import os


def test_basic_functionality():
    """기본 동작 테스트"""
    print("=" * 60)
    print("NIA 모델 테스트 시작")
    print("=" * 60)
    
    # 1. 분석기 초기화
    print("\n[1단계] 분석기 초기화...")
    try:
        analyzer = NIASkinAnalyzer(checkpoint_dir='./checkpoints')
        print("✅ 초기화 성공")
    except Exception as e:
        print(f"❌ 초기화 실패: {e}")
        return
    
    # 2. 테스트 이미지 확인
    test_image = "image.jpg"  # 테스트용 얼굴 이미지 경로
    
    if not os.path.exists(test_image):
        print(f"\n테스트 이미지가 없습니다: {test_image}")
        print("실제 얼굴 이미지를 준비하고 경로를 수정하세요.")
        return
    
    # 3. 민감도 분석 테스트
    print(f"\n[2단계] 민감도 분석 실행...")
    print(f"이미지: {test_image}")
    
    try:
        result = analyzer.analyze_sensitivity(test_image)
        
        print("\n 분석 완료!")
        print("\n" + "=" * 60)
        print("민감도 분석 결과")
        print("=" * 60)
        print(f"종합 점수:    {result['sensitivity_score']:.1f}/100")
        print(f"등급:         {result['level'].upper()}")
        print(f"\n세부 점수:")
        print(f"  건조도:     {result['dryness']:.1f}/100")
        print(f"  색소침착:   {result['pigmentation']:.1f}/100")
        print(f"  모공:       {result['pore']:.1f}/100")
        print(f"  탄력:       {result['elasticity']:.1f}/100")
        
        print(f"\n상세 정보:")
        for key, value in result['details'].items():
            print(f"  {key}: {value}")
        
    except FileNotFoundError as e:
        print(f"\n 체크포인트 파일 없음")
        print(f"   {e}")
        print("\n확인사항:")
        print("  1. NIA/checkpoints/ 폴더가 있는지 확인")
        print("  2. state_dict.bin 파일들이 정상적으로 추출되었는지 확인")
        
    except Exception as e:
        print(f"\n 분석 실패: {e}")
        import traceback
        traceback.print_exc()


def test_full_analysis():
    """전체 상세 분석 테스트"""
    print("\n" + "=" * 60)
    print("전체 상세 분석 테스트")
    print("=" * 60)
    
    analyzer = NIASkinAnalyzer(checkpoint_dir='./checkpoints')
    test_image = "test_face.jpg"
    
    if not os.path.exists(test_image):
        print(f"  테스트 이미지가 없습니다: {test_image}")
        return
    
    try:
        result = analyzer.get_full_analysis(test_image)
        
        print("\n[Classification 결과]")
        for name, data in result['classification'].items():
            if 'error' in data:
                print(f"  {name}:  {data['error']}")
            else:
                print(f"  {name}:")
                print(f"    등급: {data['grade']}/{data['max_grade']}")
                print(f"    신뢰도: {data['confidence']:.1f}%")
        
        print("\n[Regression 결과]")
        for name, data in result['regression'].items():
            if 'error' in data:
                print(f"  {name}:  {data['error']}")
            else:
                print(f"  {name}:")
                print(f"    값: {data['values']}")
        
        print("\n 전체 분석 완료")
        
    except Exception as e:
        print(f" 전체 분석 실패: {e}")
        import traceback
        traceback.print_exc()


def check_checkpoints():
    """체크포인트 파일 존재 여부 확인"""
    print("\n" + "=" * 60)
    print("체크포인트 파일 확인")
    print("=" * 60)
    
    checkpoint_dir = './checkpoints'
    
    # Classification 체크
    print("\n[Classification 모델]")
    class_models = [1, 2, 3, 5, 7, 8]
    for model_id in class_models:
        path = f"{checkpoint_dir}/class/100%/1,2,3/{model_id}/state_dict.bin"
        status = "✅" if os.path.exists(path) else "❌"
        print(f"  모델 {model_id}: {status} {path}")
    
    # Regression 체크
    print("\n[Regression 모델]")
    reg_models = [0, 1, 3, 5, 8]
    for model_id in reg_models:
        path = f"{checkpoint_dir}/regression/100%/1,2,3/{model_id}/state_dict.bin"
        status = "✅" if os.path.exists(path) else "❌"
        print(f"  모델 {model_id}: {status} {path}")


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='NIA 모델 테스트')
    parser.add_argument(
        '--mode',
        type=str,
        default='check',
        choices=['check', 'basic', 'full', 'all'],
        help='테스트 모드 선택'
    )
    parser.add_argument(
        '--image',
        type=str,
        default='test_face.jpg',
        help='테스트 이미지 경로'
    )
    
    args = parser.parse_args()
    
    if args.mode == 'check' or args.mode == 'all':
        check_checkpoints()
    
    if args.mode == 'basic' or args.mode == 'all':
        # 이미지 경로 업데이트
        import sys
        sys.modules[__name__].__dict__['test_image'] = args.image
        test_basic_functionality()
    
    if args.mode == 'full':
        import sys
        sys.modules[__name__].__dict__['test_image'] = args.image
        test_full_analysis()
    
    print("\n" + "=" * 60)
    print("테스트 완료")
    print("=" * 60)