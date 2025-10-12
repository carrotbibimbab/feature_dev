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
                'http://localhost:7860/api/analysis/comprehensive',
                files=files,
                data=data,
                timeout=60
            )
        
        if response.status_code == 200:
            result = response.json()
            print(f"DEBUG - Response keys: {result.keys()}")
            
            output = "# 🎨 피부 분석 결과\n\n"
            
            # 분석 ID 표시
            if 'analysis_id' in result:
                output += f"**분석 ID**: `{result['analysis_id']}`\n\n"
            
            # ========== 피부 민감도 분석 ==========
            if 'sensitivity' in result:
                sens = result['sensitivity']
                output += "## 📊 피부 민감도 분석\n\n"
                
                # 종합 민감도
                if 'sensitivity_score' in sens:
                    score = sens['sensitivity_score']
                    level = sens.get('level', 'MEDIUM').upper()
                    
                    level_emoji = {
                        'LOW': '🟢',
                        'MEDIUM': '🟡',
                        'HIGH': '🔴'
                    }.get(level, '⚪')
                    
                    output += f"### {level_emoji} 종합 민감도\n"
                    output += f"- **점수**: {score:.1f}/100\n"
                    output += f"- **레벨**: {level}\n\n"
                
                # 상세 지표
                output += "### 📈 상세 지표\n\n"
                items = [
                    ('dryness', '건조도', '💧'),
                    ('pigmentation', '색소침착', '🎨'),
                    ('pore', '모공', '🔍'),
                    ('elasticity', '탄력', '✨')
                ]
                
                for key, label, emoji in items:
                    if key in sens:
                        value = sens[key]
                        if isinstance(value, (int, float)):
                            output += f"{emoji} **{label}**: {value:.1f}/100\n"
                
                output += "\n"
                
                # 주의 성분
                if 'caution_ingredients' in sens and sens['caution_ingredients']:
                    output += "### 🚫 주의 성분\n\n"
                    caution = sens['caution_ingredients'][:5]
                    output += ", ".join(caution)
                    if len(sens['caution_ingredients']) > 5:
                        output += f" 외 {len(sens['caution_ingredients']) - 5}개"
                    output += "\n\n"
                
                # 안전 성분
                if 'safe_ingredients' in sens and sens['safe_ingredients']:
                    output += "### ✅ 안전 성분\n\n"
                    safe = sens['safe_ingredients'][:5]
                    output += ", ".join(safe)
                    if len(sens['safe_ingredients']) > 5:
                        output += f" 외 {len(sens['safe_ingredients']) - 5}개"
                    output += "\n\n"
            
            # ========== AI 뷰티 가이드 (DB 버전 - 상세) ==========
            if 'ai_analysis' in result:
                ai = result['ai_analysis']
                output += "---\n\n"
                output += "## 🤖 AI 뷰티 가이드\n\n"
                
                # 가이드 제목
                if 'title' in ai:
                    output += f"### {ai['title']}\n\n"
                
                # 종합 평가
                if 'summary' in ai and ai['summary']:
                    output += "**💎 종합 평가**\n\n"
                    output += f"{ai['summary']}\n\n"
                
                # Sections 파싱 (DB 버전은 sections 딕셔너리 구조)
                if 'sections' in ai and ai['sections']:
                    sections = ai['sections']
                    
                    # 아침 루틴
                    if 'morning_routine' in sections and sections['morning_routine']:
                        output += "**🌅 아침 루틴**\n\n"
                        for i, step in enumerate(sections['morning_routine'], 1):
                            output += f"{i}. {step}\n"
                        output += "\n"
                    
                    # 저녁 루틴
                    if 'evening_routine' in sections and sections['evening_routine']:
                        output += "**🌙 저녁 루틴**\n\n"
                        for i, step in enumerate(sections['evening_routine'], 1):
                            output += f"{i}. {step}\n"
                        output += "\n"
                    
                    # 추천 성분
                    if 'ingredients' in sections and sections['ingredients']:
                        output += "**🧪 추천 성분**\n\n"
                        for ing in sections['ingredients'][:5]:
                            output += f"- {ing}\n"
                        output += "\n"
                    
                    # 생활습관
                    if 'lifestyle' in sections and sections['lifestyle']:
                        output += "**🌱 생활습관 조언**\n\n"
                        for tip in sections['lifestyle'][:3]:
                            output += f"- {tip}\n"
                        output += "\n"
                    
                    # 주의사항
                    if 'warnings' in sections and sections['warnings']:
                        output += "**⚠️ 주의사항**\n\n"
                        for warning in sections['warnings'][:3]:
                            output += f"- {warning}\n"
                        output += "\n"
                    
                    # 전문가 조언
                    if 'expert_tip' in sections and sections['expert_tip']:
                        output += "**💬 전문가 조언**\n\n"
                        output += f"> {sections['expert_tip']}\n\n"
                
                # 토큰 사용량
                if 'tokens_used' in ai:
                    output += f"\n_AI 분석에 {ai['tokens_used']} 토큰 사용_\n"
            
            # 타임스탬프
            if 'timestamp' in result:
                output += f"\n\n---\n_분석 시각: {result['timestamp']}_"
            
            return output
        
        else:
            return f"❌ 에러 발생 (HTTP {response.status_code})\n\n```\n{response.text}\n```"
    
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