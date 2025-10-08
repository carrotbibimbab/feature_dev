"""
 AI 피부 분석 서비스
OpenAI GPT를 활용한 개인화된 피부 분석 리포트 생성
"""

from openai import OpenAI
import os
from typing import Dict, Any


class GPTSkinAnalysisService:
    """GPT 기반 피부 분석 서비스"""
    
    def __init__(self):
        self.client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
        self.model = "gpt-4o-mini"
    
    
    def generate_comprehensive_analysis(
        self,
        #personal_color: Dict[str, Any],
        sensitivity: Dict[str, Any],
        user_concerns: str = None
    ) -> Dict[str, Any]:
        """
        종합 피부 분석 리포트 생성
        
        Args:
            personal_color: ColorInsight 분석 결과
            sensitivity: NIA 민감도 분석 결과
            user_concerns: 사용자가 입력한 피부 고민 (선택)
        
        Returns:
            {
                'summary': '요약',
                'personal_color_guide': '퍼스널 컬러 가이드',
                'skin_condition': '피부 상태 분석',
                'recommendations': [...],
                'warnings': [...]
            }
        """
        
        prompt = self._build_analysis_prompt(
            #personal_color, 
            sensitivity, 
            user_concerns
        )
        
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {
                    "role": "system",
                    "content": self._get_system_prompt()
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            temperature=0.7,
            max_tokens=1500
        )
        
        analysis_text = response.choices[0].message.content
        
        return self._parse_analysis(analysis_text)
    
    
    def _get_system_prompt(self) -> str:
        """시스템 프롬프트 (AI 역할 정의)"""
        return """당신은 BF(뷰티 퍼스널 어시스턴트)의 피부 분석 전문가입니다.

당신의 역할:
1. 피부 민감도 데이터를 분석하여 개인화된 뷰티 가이드 제공
2. 과학적이면서도 이해하기 쉬운 설명
3. 실용적이고 실천 가능한 조언

중요한 원칙:
- 의학적 진단이 아닌 일반적인 뷰티 가이드임을 명시
- 심각한 피부 문제는 피부과 전문의 상담 권장
- 과도한 제품 사용보다는 건강한 피부 관리 습관 강조
- 개인차가 있음을 항상 안내

응답 형식:
## 요약
(2-3줄로 핵심 요약)

## 피부 상태 분석
(민감도, 건조도, 색소침착, 모공, 탄력 상태 해석)

## 추천 사항
1. [구체적 조언]
2. [구체적 조언]
3. [구체적 조언]

## 주의 사항
- [주의할 점]
- [피해야 할 것]

응답은 친근하지만 전문적인 톤으로, 존댓말 사용."""
    
    
    def _build_analysis_prompt(
        self,
        #personal_color: Dict[str, Any],
        sensitivity: Dict[str, Any],
        user_concerns: str = None
    ) -> str:
        """분석 요청 프롬프트 생성"""
        
        # season = personal_color.get('season', 'unknown')
        # confidence = personal_color.get('confidence', 0)
        
        sensitivity_score = sensitivity.get('sensitivity_score', 0)
        level = sensitivity.get('level', 'medium')
        dryness = sensitivity.get('dryness', 0)
        pigmentation = sensitivity.get('pigmentation', 0)
        pore = sensitivity.get('pore', 0)
        elasticity = sensitivity.get('elasticity', 0)
        
        prompt = f"""다음 피부 분석 결과를 바탕으로 종합 리포트를 작성해주세요:

# 피부 민감도 분석
- 종합 민감도: {sensitivity_score:.1f}/100 ({level.upper()})
- 건조도: {dryness:.1f}/100
- 색소침착: {pigmentation:.1f}/100
- 모공: {pore:.1f}/100
- 탄력: {elasticity:.1f}/100
"""
        
        if user_concerns:
            prompt += f"\n# 사용자 피부 고민\n{user_concerns}\n"
        
        prompt += """
위 데이터를 종합하여 다음을 포함한 개인화된 뷰티 가이드를 작성하세요:
1. 피부 민감도에 따른 케어 방법
2. 실천 가능한 구체적 추천사항
3. 주의해야 할 사항

반드시 위에서 정의한 형식(## 제목)으로 응답하세요."""
        
        return prompt
    
    
    def _parse_analysis(self, analysis_text: str) -> Dict[str, Any]:
        """GPT 응답을 구조화된 데이터로 파싱"""
        
        sections = {
            'summary': '',
            #'personal_color_guide': '',
            'skin_condition': '',
            'recommendations': [],
            'warnings': []
        }
        
        lines = analysis_text.split('\n')
        current_section = None
        current_content = []
        
        for line in lines:
            line = line.strip()
            
            if line.startswith('## 요약'):
                current_section = 'summary'
                current_content = []
            elif line.startswith('## 컨디션'):
                if current_section == 'summary':
                    sections['summary'] = '\n'.join(current_content).strip()
                current_section = 'skin_condition'
                current_content = []
            elif line.startswith('## 추천'):
                if current_section == 'skin_condition':
                    sections['skin_condition'] = '\n'.join(current_content).strip()
                current_section = 'recommendations'
                current_content = []
            elif line.startswith('## 주의'):
                if current_section == 'recommendations':
                    recs = [l.strip('- ').strip('1234567890. ') 
                           for l in current_content if l.strip()]
                    sections['recommendations'] = [r for r in recs if r]
                current_section = 'warnings'
                current_content = []
            elif line:
                current_content.append(line)
        
        if current_section == 'warnings':
            warnings = [l.strip('- ').strip() 
                       for l in current_content if l.strip()]
            sections['warnings'] = [w for w in warnings if w]
        
        sections['full_text'] = analysis_text
        
        return sections
    
    
    def explain_sensitivity_score(self, score: float, level: str) -> str:
        """민감도 점수 해석"""
        
        prompt = f"""피부 민감도 점수 {score:.1f}/100 (등급: {level})의 의미를 2-3문장으로 쉽게 설명해주세요.
- 이 점수가 의미하는 것
- 일상 생활에서 주의할 점
- 긍정적인 측면도 포함"""
        
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": "피부 관리 전문가로서 쉽고 친근하게 설명하세요."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=200
        )
        
        return response.choices[0].message.content.strip()