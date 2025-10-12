// lib/models/analysis_result.dart
// 화면 16: AI 분석 결과 페이지 모델
// 데이터베이스 'analyses' 테이블과 매칭
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'image_id') required String imageId,

    // ❌ 제거: 퍼스널 컬러 진단
    // @JsonKey(name: 'personal_color') String? personalColor,
    // @JsonKey(name: 'personal_color_confidence') double? personalColorConfidence,
    // @JsonKey(name: 'personal_color_description') String? personalColorDescription,
    // @JsonKey(name: 'best_colors') List<String>? bestColors,
    // @JsonKey(name: 'worst_colors') List<String>? worstColors,

    // ❌ 제거: 피부 타입 분석
    // @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
    // @JsonKey(name: 'skin_type_description') String? skinTypeDescription,

    // ✅ 3. 민감성 위험도 (게이지) - 3단계로 변경
    @JsonKey(name: 'sensitivity_score') double? sensitivityScore, // 0-10
    @JsonKey(name: 'sensitivity_level') String? sensitivityLevel, // low/medium/high
    @JsonKey(name: 'risk_factors') List<String>? riskFactors,

    // ✅ 4. 피부 상세 분석 (4가지)
    @JsonKey(name: 'dryness_score') int? drynessScore,
    @JsonKey(name: 'dryness_description') String? drynessDescription,
    
    @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
    @JsonKey(name: 'pigmentation_description') String? pigmentationDescription,
    
    @JsonKey(name: 'pore_score') int? poreScore,
    @JsonKey(name: 'pore_description') String? poreDescription,
    
    @JsonKey(name: 'elasticity_score') int? elasticityScore,
    @JsonKey(name: 'elasticity_description') String? elasticityDescription,

    // ❌ 제거된 상세 분석
    // @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
    // @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
    // @JsonKey(name: 'acne_score') int? acneScore,
    // @JsonKey(name: 'acne_description') String? acneDescription,
    // @JsonKey(name: 'redness_score') int? rednessScore,
    // @JsonKey(name: 'redness_description') String? rednessDescription,

    // ✅ 5. 핵심 솔루션: 스킨케어 루틴
    @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,

    // === 6. 얼굴 인식 품질 ===
    @JsonKey(name: 'face_detected') bool? faceDetected,
    @JsonKey(name: 'face_quality_score') double? faceQualityScore,

    // === 7. 원본 데이터 (백업) ===
    @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,

    // === 타임스탬프 ===
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

// 스킨케어 루틴 단계
@freezed
class SkincareStep with _$SkincareStep {
  const factory SkincareStep({
    required int step,
    required String type,
    required String description,
    String? productExample,
    String? iconAsset,
  }) = _SkincareStep;

  factory SkincareStep.fromJson(Map<String, dynamic> json) =>
      _$SkincareStepFromJson(json);
}

// ✅ 민감성 레벨 (3단계: low, medium, high)
class SensitivityLevel {
  static const String low = 'low';
  static const String medium = 'medium';
  static const String high = 'high';

  static String toKorean(String level) {
    switch (level) {
      case low:
        return '양호';
      case medium:
        return '보통';
      case high:
        return '주의';
      default:
        return '보통';
    }
  }

  // 게이지 이미지 경로
  static String getImagePath(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return 'assets/17/sensitivity_low.png';
      case 'medium':
        return 'assets/17/sensitivity_medium.png';
      case 'high':
        return 'assets/17/sensitivity_high.png';
      default:
        return 'assets/17/sensitivity_medium.png';
    }
  }
}

// ❌ 제거: PersonalColorType 클래스
// ❌ 제거: SkinType 클래스

// ✅ 피부 상세 분석 항목 (4가지)
class SkinAnalysisCategory {
  static const String dryness = 'dryness';
  static const String pigmentation = 'pigmentation';
  static const String pores = 'pores';
  static const String elasticity = 'elasticity';

  static String toKorean(String category) {
    switch (category) {
      case dryness:
        return '건조도';
      case pigmentation:
        return '색소침착';
      case pores:
        return '모공';
      case elasticity:
        return '탄력';
      default:
        return category;
    }
  }

  // Progress Bar 색상 (점수에 따라)
  static String getProgressColor(int score) {
    if (score >= 80) return '#4CAF50'; // 초록 (좋음)
    if (score >= 60) return '#8BC34A'; // 연두
    if (score >= 40) return '#FFC107'; // 노랑 (보통)
    if (score >= 20) return '#FF9800'; // 주황
    return '#F44336'; // 빨강 (나쁨)
  }

  // 점수별 평가
  static String getScoreLabel(int score) {
    if (score >= 80) return '매우 좋음';
    if (score >= 60) return '좋음';
    if (score >= 40) return '보통';
    if (score >= 20) return '개선 필요';
    return '주의 필요';
  }
}