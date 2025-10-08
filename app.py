"""
Hugging Face Spaces 진입점 (Gradio SDK)
FastAPI + Gradio 하이브리드
"""

import gradio as gr
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from pathlib import Path
import sys
import spaces
# 프로젝트 루트를 Python path에 추가
sys.path.insert(0, str(Path(__file__).parent))

# FastAPI 앱 import
from app.main import app as fastapi_app

# ============================================================================
# 🔥 Startup 감지용 더미 함수 (필수!)
# ============================================================================
@spaces.GPU(duration=5)
def _startup_gpu_check():
    """HF Spaces startup 시 GPU 감지를 위한 더미 함수"""
    import torch
    return torch.cuda.is_available()

# Startup 시 한 번 호출
print(f"🔍 GPU Check: {_startup_gpu_check()}")

# ============================================================================
# Gradio 인터페이스 (데모/테스트용)
# ============================================================================

def analyze_image(image, concerns):
    """
    Gradio 인터페이스를 통한 이미지 분석
    
    Args:
        image: PIL Image 또는 numpy array
        concerns: 사용자 고민 텍스트
    
    Returns:
        분석 결과 텍스트
    """
    import tempfile
    import os
    from PIL import Image
    import requests
    import json
    
    # 이미지를 임시 파일로 저장
    with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
        if isinstance(image, Image.Image):
            image.save(tmp.name)
        else:
            Image.fromarray(image).save(tmp.name)
        tmp_path = tmp.name
    
    try:
        # FastAPI 엔드포인트 호출 (내부 호출)
        with open(tmp_path, 'rb') as f:
            files = {'file': ('image.jpg', f, 'image/jpeg')}
            data = {'concerns': concerns} if concerns else {}
            
            # localhost로 내부 API 호출
            response = requests.post(
                'http://localhost:7860/api/v1/analysis/comprehensive',
                files=files,
                data=data,
                timeout=60
            )
        
        if response.status_code == 200:
            result = response.json()
            
            # 🔥 디버깅: 원본 응답 출력
            print("\n=== API 응답 ===")
            print(json.dumps(result, indent=2, ensure_ascii=False))
            print("================\n")
            
            # 결과 포맷팅
            output = "## 📊 피부 분석 결과\n\n"
            
            # 민감도 - 안전한 파싱
            if 'sensitivity' in result:
                sens = result['sensitivity']
                output += "### 🧴 피부 민감도\n\n"
                
                # 🔥 overall_sensitivity 안전하게 파싱
                if 'overall_sensitivity' in sens:
                    overall = sens['overall_sensitivity']
                    if isinstance(overall, dict):
                        output += f"- **종합 점수**: {overall.get('score', 'N/A')}\n"
                        output += f"- **레벨**: {overall.get('level', 'N/A')}\n\n"
                    else:
                        output += f"- **종합 점수**: {overall}\n\n"
                
                # 🔥 개별 항목 안전하게 파싱
                items = [
                    ('dryness', '건조도'),
                    ('pigmentation', '색소침착'),
                    ('pore', '모공'),
                    ('elasticity', '탄력')
                ]
                
                for key, label in items:
                    if key in sens:
                        value = sens[key]
                        if isinstance(value, dict):
                            # dict 형태: {"score": 0.5, "level": "medium"}
                            score = value.get('score', 'N/A')
                            level = value.get('level', '')
                            output += f"- **{label}**: {score}"
                            if level:
                                output += f" ({level})"
                            output += "\n"
                        elif isinstance(value, (int, float)):
                            # 단순 숫자 형태
                            output += f"- **{label}**: {value:.2f}\n"
                        else:
                            # 기타
                            output += f"- **{label}**: {value}\n"
                
                output += "\n"
            
            # AI 분석 - 안전하게 파싱
            if 'ai_analysis' in result:
                ai = result['ai_analysis']
                output += "### 🤖 AI 뷰티 가이드\n\n"
                
                if 'summary' in ai and ai['summary']:
                    output += f"**요약**:\n{ai['summary']}\n\n"
                
                if 'skin_condition_analysis' in ai and ai['skin_condition_analysis']:
                    output += f"**피부 상태 분석**:\n{ai['skin_condition_analysis']}\n\n"
                
                if 'recommendations' in ai and ai['recommendations']:
                    recs = ai['recommendations']
                    if isinstance(recs, list) and recs:
                        output += "**추천사항**:\n"
                        for i, rec in enumerate(recs, 1):
                            output += f"{i}. {rec}\n"
                    elif isinstance(recs, str):
                        output += f"**추천사항**:\n{recs}\n"
            
            return output
        else:
            return f"❌ 에러 발생: {response.status_code}\n\n{response.text}"
    
    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        return f"❌ 분석 실패: {str(e)}\n\n상세 에러:\n```\n{error_details}\n```"
    
    finally:
        # 임시 파일 삭제
        if os.path.exists(tmp_path):
            os.remove(tmp_path)

# ============================================================================
# Gradio UI 구성
# ============================================================================

with gr.Blocks(title="얼굴 분석 API") as demo:
    gr.Markdown("""
    # 🎨 얼굴 분석 & 피부 진단 API
    
    NIA 모델 기반 피부 민감도 분석 + GPT 뷰티 가이드
    
    ## 사용 방법
    1. **이미지 업로드**: 얼굴 정면 사진
    2. **고민 입력** (선택): 피부 고민 작성
    3. **분석 시작** 클릭
    
    ## API 문서
    - Swagger UI: [/docs](/docs)
    - ReDoc: [/redoc](/redoc)
    """)
    
    with gr.Row():
        with gr.Column():
            image_input = gr.Image(
                label="얼굴 이미지 업로드",
                type="pil",
                sources=["upload", "webcam"]
            )
            concerns_input = gr.Textbox(
                label="피부 고민 (선택사항)",
                placeholder="예: 건조하고 모공이 걱정됩니다",
                lines=2
            )
            analyze_btn = gr.Button("🔍 분석 시작", variant="primary")
        
        with gr.Column():
            output = gr.Markdown(label="분석 결과")
    
    # 이벤트 연결
    analyze_btn.click(
        fn=analyze_image,
        inputs=[image_input, concerns_input],
        outputs=output
    )
    
    # 예시
    gr.Examples(
        examples=[
            ["app/tests/test_images/test_face_1.jpg", "건조하고 모공이 걱정됩니다"],
        ],
        inputs=[image_input, concerns_input],
        label="예시 이미지"
    )


# ============================================================================
# FastAPI를 Gradio에 마운트
# ============================================================================

# Gradio app에 FastAPI 마운트
app = gr.mount_gradio_app(fastapi_app, demo, path="/")

# ============================================================================
# 서버 실행 (로컬 테스트용)
# ============================================================================

if __name__ == "__main__":
    print("🚀 Starting Gradio + FastAPI server...")
    print("📍 Gradio UI: http://localhost:7860")
    print("📍 API Docs: http://localhost:7860/docs")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=7860,
        log_level="info"
    )