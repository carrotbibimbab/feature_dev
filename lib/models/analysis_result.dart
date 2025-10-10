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

    // === 1. 퍼스널 컬러 진단 (상단 카드) ===
    @JsonKey(name: 'personal_color') String? personalColor,
    @JsonKey(name: 'personal_color_confidence') double? personalColorConfidence,
    @JsonKey(name: 'personal_color_description')
    String? personalColorDescription,

    // 인생 컬러 팔레트 (BEST/WORST)
    @JsonKey(name: 'best_colors') List<String>? bestColors, // HEX 배열
    @JsonKey(name: 'worst_colors') List<String>? worstColors,

    // === 2. 피부 타입 분석 ===
    @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
    @JsonKey(name: 'skin_type_description') String? skinTypeDescription,

    // === 3. 민감성 위험도 (게이지) ===
    @JsonKey(name: 'sensitivity_score') double? sensitivityScore, // 0-10
    @JsonKey(name: 'sensitivity_level')
    String? sensitivityLevel, // low/medium/high
    @JsonKey(name: 'risk_factors') List<String>? riskFactors,

    // === 4. 피부 상세 분석 (Progress Bar 형식) ===
    // 각 항목: 점수(0-100) + 설명
    @JsonKey(name: 'pore_score') int? poreScore,
    @JsonKey(name: 'pore_description') String? poreDescription,
    @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
    @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
    @JsonKey(name: 'elasticity_score') int? elasticityScore,
    @JsonKey(name: 'elasticity_description') String? elasticityDescription,
    @JsonKey(name: 'acne_score') int? acneScore,
    @JsonKey(name: 'acne_description') String? acneDescription,
    @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
    @JsonKey(name: 'pigmentation_description') String? pigmentationDescription,
    @JsonKey(name: 'redness_score') int? rednessScore,
    @JsonKey(name: 'redness_description') String? rednessDescription,

    // === 5. 핵심 솔루션: 스킨케어 루틴 ===
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

// 스킨케어 루틴 단계 (하단 "나에게 맞는 관리법" 섹션)
@freezed
class SkincareStep with _$SkincareStep {
  const factory SkincareStep({
    required int step, // 1, 2, 3...
    required String
        type, // cleanser, toner, essence, serum, moisturizer, sunscreen
    required String description, // "저자극 클렌저로 순한 세안"
    String? productExample, // 제품 예시 (선택사항)
    String? iconAsset, // 아이콘 경로 (선택사항)
  }) = _SkincareStep;

  factory SkincareStep.fromJson(Map<String, dynamic> json) =>
      _$SkincareStepFromJson(json);
}

// === 퍼스널 컬러 타입 상수 ===
class PersonalColorType {
  // 데이터베이스 저장값
  static const String springWarmLight = 'spring_warm_light';
  static const String springWarmBright = 'spring_warm_bright';
  static const String summerCoolLight = 'summer_cool_light';
  static const String summerCoolMuted = 'summer_cool_muted';
  static const String autumnWarmMuted = 'autumn_warm_muted';
  static const String autumnWarmDeep = 'autumn_warm_deep';
  static const String winterCoolBright = 'winter_cool_bright';
  static const String winterCoolDeep = 'winter_cool_deep';

  // 한글명 변환 (화면 표시용)
  static String toKorean(String type) {
    switch (type) {
      case springWarmLight:
        return '봄 웜톤 라이트';
      case springWarmBright:
        return '봄 웜톤 브라이트';
      case summerCoolLight:
        return '여름 쿨톤 라이트';
      case summerCoolMuted:
        return '여름 쿨톤 뮤트';
      case autumnWarmMuted:
        return '가을 웜톤 뮤트';
      case autumnWarmDeep:
        return '가을 웜톤 딥';
      case winterCoolBright:
        return '겨울 쿨톤 브라이트';
      case winterCoolDeep:
        return '겨울 쿨톤 딥';
      default:
        return type;
    }
  }

  // 해시태그용 간단명 (화면 8: 마이페이지)
  static String toHashtag(String type) {
    if (type.contains('spring_warm_light')) return '#봄웜라이트';
    if (type.contains('spring_warm_bright')) return '#봄웜브라이트';
    if (type.contains('summer_cool_light')) return '#여름쿨라이트';
    if (type.contains('summer_cool_muted')) return '#여름쿨뮤트';
    if (type.contains('autumn_warm_muted')) return '#가을웜뮤트';
    if (type.contains('autumn_warm_deep')) return '#가을웜딥';
    if (type.contains('winter_cool_bright')) return '#겨울쿨브라이트';
    if (type.contains('winter_cool_deep')) return '#겨울쿨딥';
    return '#$type';
  }

  // 이미지 경로 반환
  static String getImagePath(String type) {
    switch (type) {
      case springWarmLight:
        return 'assets/17/personalcolor/sw_light.png';
      case springWarmBright:
        return 'assets/17/personalcolor/sw_bright.png';
      case summerCoolLight:
        return 'assets/17/personalcolor/sc_light.png';
      case summerCoolMuted:
        return 'assets/17/personalcolor/sc_mute.png';
      case autumnWarmMuted:
        return 'assets/17/personalcolor/fw_mute.png';
      case autumnWarmDeep:
        return 'assets/17/personalcolor/fw_deep.png';
      case winterCoolBright:
        return 'assets/17/personalcolor/wc_bright.png';
      case winterCoolDeep:
        return 'assets/17/personalcolor/wc_deep.png';
      default:
        return 'assets/17/personalcolor/wc_deep.png'; // 기본값
    }
  }
}

// === 민감성 레벨 ===
class SensitivityLevel {
  static const String safe = 'safe';
  static const String low = 'low';
  static const String moderate = 'moderate';
  static const String caution = 'caution';
  static const String high = 'high';

  static String toKorean(String level) {
    switch (level) {
      case safe:
        return 'Safe';
      case low:
        return 'Low';
      case moderate:
        return 'Moderate';
      case caution:
        return 'Caution';
      case high:
        return 'High Risk';
      default:
        return level;
    }
  }

  // 게이지 색상
  static String getColor(String level) {
    switch (level) {
      case safe:
        return '#4CAF50'; // 초록색
      case low:
        return '#8BC34A'; // 연두색
      case moderate:
        return '#FFC107'; // 노란색
      case caution:
        return '#FF9800'; // 주황색
      case high:
        return '#F44336'; // 빨간색
      default:
        return '#9E9E9E';
    }
  }

  // 게이지 이미지 경로
  static String getImagePath(String level) {
    switch (level) {
      case safe:
        return 'assets/17/gage_safe.png';
      case low:
        return 'assets/17/gage_low.png';
      case moderate:
        return 'assets/17/gage_moderate.png';
      case caution:
        return 'assets/17/gage_caution.png';
      case high:
        return 'assets/17/gage_caution.png'; // High Risk와 Caution 동일
      default:
        return 'assets/17/gage_moderate.png'; // 기본값
    }
  }
}

// === 피부 타입 ===
class SkinType {
  static const String normal = 'normal';
  static const String oily = 'oily';
  static const String dry = 'dry';
  static const String combination = 'combination';
  static const String sensitive = 'sensitive';

  static String toKorean(String type) {
    switch (type) {
      case normal:
        return '정상';
      case oily:
        return '지성';
      case dry:
        return '건성';
      case combination:
        return '복합성';
      case sensitive:
        return '민감성';
      default:
        return type;
    }
  }

  // 해시태그용
  static String toHashtag(String type) {
    return '#${toKorean(type)}';
  }

  // 이미지 경로 반환
  static String getImagePath(String type) {
    switch (type) {
      case normal:
        return 'assets/17/skin/joongsung.png';
      case oily:
        return 'assets/17/skin/jisung.png';
      case dry:
        return 'assets/17/skin/gunsung.png';
      case combination:
        return 'assets/17/skin/bokhap.png';
      case sensitive:
        return 'assets/17/skin/mingam.png';
      default:
        return 'assets/17/skin/joongsung.png'; // 기본값
    }
  }
}

// === 피부 상세 분석 항목 ===
class SkinAnalysisCategory {
  static const String pores = 'pores';
  static const String wrinkles = 'wrinkles';
  static const String elasticity = 'elasticity';
  static const String acne = 'acne';
  static const String pigmentation = 'pigmentation';
  static const String redness = 'redness';

  static String toKorean(String category) {
    switch (category) {
      case pores:
        return '모공';
      case wrinkles:
        return '주름';
      case elasticity:
        return '탄력';
      case acne:
        return '여드름';
      case pigmentation:
        return '색소침착';
      case redness:
        return '홍조';
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
