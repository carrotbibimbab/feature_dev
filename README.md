# 뷰파 (BF): 초보자와 민감성 피부를 위한 AI 기반 스마트 뷰티 가이드 앱
## 💡 프로젝트 개요 (Project Overview)
**뷰파(BF, Beauty Finder)**는 2025년 뷰티 시장의 핵심 트렌드인 **'초개인화'**와 **'안전성'**에 초점을 맞춘 모바일 애플리케이션입니다. 뷰티 입문자와 민감성 피부 사용자가 겪는 제품 선택의 시행착오를 줄이고, 안전하게 자신에게 맞는 뷰티 루틴을 확립할 수 있도록 돕는 것이 목표입니다.

### 핵심 가치
안전성 우선: AI 기반의 **민감성 피부 '민감도 점수 시스템'**을 통해 부작용 위험을 최소화합니다.

초개인화 가이드: Vision AI 진단 결과와 GPT-4 기반 가이드를 결합하여 맞춤형 루틴을 제공합니다.

지속적 관리: 7일 트래킹 시스템을 통해 제품 사용 후의 피부 개선 효과를 모니터링합니다.

### ✨ 주요 기능 (Key Features)
**AI 진단 시스템**	
사용자 카메라를 통한 스킨톤, 퍼스널컬러 진단 및 피부 문제 분석
**민감도 점수**	
크롤링 데이터를 기반으로 개인 피부 타입에 맞는 제품 안전도 점수 및 대체 제품 추천
**단계별 가이드**	
뷰티 초보자를 위한 GPT 연동 맞춤형 뷰티 루틴 및 튜토리얼 제공
**루틴 트래킹**
7일간의 제품 사용 기록 및 피부 변화를 모니터링하는 개선 효과 추적 시스템
**소통 기능**
사용자 궁금증을 즉시 해결하는 AI 기반 응대 카카오톡 챗봇 연동
https://pf.kakao.com/_izDxcn

### 🏗️ 시스템 아키텍처 (System Architecture)
본 프로젝트는 클라이언트-서버-AI 모듈이 명확히 분리된 구조를 채택했습니다. 이는 기능의 확장성과 유지보수성을 높이기 위함입니다.

**Flutter App**: 사용자 사진/데이터를 수집하여 FastAPI 서버로 전송합니다.

**FastAPI Server**: 클라이언트 요청을 받아 AI Engine 및 DB를 조율합니다.

**AI Engine (ML + GPT)**: 사용자 데이터 분석, 민감도 점수 산출, 가이드 생성을 담당하는 핵심 모듈입니다.

**Supabase DB**: 뷰티 데이터, 사용자 정보, 트래킹 기록을 저장합니다.

### 🤝 기여 및 라이선스 (Contribution & License)
본 프로젝트는 팀 프로젝트로 진행되었으며, 프로젝트 멤버들의 주요 역할은 PM, Mobile App Developer, Backend Developer, AI Engineer, QA Engineer, 챗봇 개발로 구성되었습니다.

(라이선스 정보 : 
MIT License

Copyright (c) 2023 Jeongho Lee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.)