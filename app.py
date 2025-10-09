"""
Hugging Face Spaces 진입점 (Gradio SDK)
FastAPI + Gradio 하이브리드
"""

import gradio as gr
from fastapi import FastAPI
import uvicorn
from pathlib import Path
import sys

# 🔥 조건부 spaces import
try:
    if sys.platform.startswith('linux'):
        import spaces
        HAS_SPACES = True
    else:
        class SpacesDummy:
            @staticmethod
            def GPU(duration=None):
                def decorator(func):
                    return func
                return decorator
        spaces = SpacesDummy()
        HAS_SPACES = False
except ImportError:
    class SpacesDummy:
        @staticmethod
        def GPU(duration=None):
            def decorator(func):
                return func
            return decorator
    spaces = SpacesDummy()
    HAS_SPACES = False

print(f"🔍 Platform: {sys.platform}")
print(f"🔍 ZeroGPU available: {HAS_SPACES}")

sys.path.insert(0, str(Path(__file__).parent))
from app.main import app as fastapi_app

# ============================================================================
# Startup GPU check (HF Spaces only)
# ============================================================================
@spaces.GPU(duration=5)
def _startup_gpu_check():
    """Startup GPU detection"""
    if HAS_SPACES:
        import torch
        return torch.cuda.is_available()
    return False

if HAS_SPACES:
    print(f"🔍 GPU Check: {_startup_gpu_check()}")

# ============================================================================
# Gradio Interface
# ============================================================================

def analyze_image(image, concerns):
    """Gradio interface - no GPU decorator"""
    import tempfile
    import os
    from PIL import Image
    import requests
    
    if image is None:
        return "❌ 이미지를 업로드해주세요"
    
    with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as tmp:
        if isinstance(image, Image.Image):
            image.save(tmp.name)
        else:
            Image.fromarray(image).save(tmp.name)
        tmp_path = tmp.name
    
    try:
        with open(tmp_path, 'rb') as f:
            files = {'file': ('image.jpg', f, 'image/jpeg')}
            data = {'concerns': concerns} if concerns else {}
            
            response = requests.post(
                'http://localhost:7860/api/v1/analysis/comprehensive',
                files=files,
                data=data,
                timeout=60
            )
        
        if response.status_code == 200:
            result = response.json()
            output = "## 📊 피부 분석 결과\n\n"
            
            if 'sensitivity' in result:
                sens = result['sensitivity']
                output += "### 🧴 피부 민감도\n\n"
                
                if 'overall_sensitivity' in sens:
                    overall = sens['overall_sensitivity']
                    if isinstance(overall, dict):
                        output += f"- **종합 점수**: {overall.get('score', 'N/A')}\n"
                        output += f"- **레벨**: {overall.get('level', 'N/A')}\n\n"
                
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
                            score = value.get('score', 'N/A')
                            level = value.get('level', '')
                            output += f"- **{label}**: {score}"
                            if level:
                                output += f" ({level})"
                            output += "\n"
                        elif isinstance(value, (int, float)):
                            output += f"- **{label}**: {value:.2f}\n"
                
                output += "\n"
            
            if 'ai_analysis' in result:
                ai = result['ai_analysis']
                output += "### 🤖 AI 뷰티 가이드\n\n"
                
                if 'summary' in ai and ai['summary']:
                    output += f"**요약**:\n{ai['summary']}\n\n"
                
                if 'recommendations' in ai and ai['recommendations']:
                    recs = ai['recommendations']
                    if isinstance(recs, list) and recs:
                        output += "**추천사항**:\n"
                        for i, rec in enumerate(recs, 1):
                            output += f"{i}. {rec}\n"
            
            return output
        else:
            return f"❌ 에러 발생: {response.status_code}\n\n{response.text}"
    
    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        return f"❌ 분석 실패: {str(e)}\n\n상세:\n```\n{error_details}\n```"
    
    finally:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)


# Gradio UI
with gr.Blocks(title="얼굴 분석 API") as demo:
    gr.Markdown("""
    # 🎨 얼굴 분석 & 피부 진단 API
    
    NIA 모델 기반 피부 민감도 분석 + GPT 뷰티 가이드
    """)
    
    with gr.Row():
        with gr.Column():
            image_input = gr.Image(label="얼굴 이미지", type="pil", sources=["upload", "webcam"])
            concerns_input = gr.Textbox(label="피부 고민 (선택)", lines=2)
            analyze_btn = gr.Button("🔍 분석 시작", variant="primary")
        
        with gr.Column():
            output = gr.Markdown(label="분석 결과")
    
    analyze_btn.click(fn=analyze_image, inputs=[image_input, concerns_input], outputs=output)

# Mount FastAPI
app = gr.mount_gradio_app(fastapi_app, demo, path="/")

if __name__ == "__main__":
    print("🚀 Starting Gradio + FastAPI server...")
    uvicorn.run(app, host="0.0.0.0", port=7860, log_level="info")