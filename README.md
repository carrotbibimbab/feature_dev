---
title: Face Analysis API
emoji: 🎨
colorFrom: blue
colorTo: purple
sdk: gradio
sdk_version: 4.44.0
app_file: app.py
pinned: false
---

# 🎨 Face Analysis API

얼굴 분석 기반 피부 민감도 진단 및 뷰티 가이드 제공

## 🚀 Features

- **Gradio UI**: 브라우저에서 바로 테스트
- **FastAPI**: RESTful API 엔드포인트
- **NIA Model**: 피부 민감도 분석 (ZeroGPU 가속)
- **GPT-4**: 개인화 뷰티 가이드

## 📡 API Endpoints

### Swagger UI
https://backend-6xc5.onrender.com

### 종합 분석
```
POST /api/v1/analysis/comprehensive
```

### 민감도 분석
```
POST /api/v1/analysis/sensitivity
```