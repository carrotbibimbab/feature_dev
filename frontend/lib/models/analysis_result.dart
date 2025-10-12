// lib/models/analysis_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

// ===== AI 분석 결과 =====
@freezed
class AiAnalysis with _$AiAnalysis {
  const factory AiAnalysis({
    required String summary,
    @Default(<String>[]) List<String> recommendations,
    @Default(<String>[]) List<String> cautions,
    @JsonKey(name: 'full_content') String? fullContent,
    @JsonKey(name: 'tokens_used') @Default(0) int tokensUsed,
  }) = _AiAnalysis;

  factory AiAnalysis.fromJson(Map<String, dynamic> json) =>
      _$AiAnalysisFromJson(json);
}

// ===== 스킨케어 루틴 단계 =====
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

// ===== 민감성 상세 정보 (⭐ 새로 추가!) =====
@freezed
class Sensitivity with _$Sensitivity {
  const factory Sensitivity({
    // 레벨 (safe, low, moderate, caution, high)
    String? level,
    
    // 민감성 점수 (0-100 또는 0-10)
    @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
    
    // 상세 지표 (0-100)
    int? pore,
    int? elasticity,
    int? pigmentation,
    int? dryness,
    int? wrinkle,
    int? acne,
    int? redness,
    
    // 위험 요인
    @JsonKey(name: 'risk_factors') @Default(<String>[]) List<String> riskFactors,
  }) = _Sensitivity;

  factory Sensitivity.fromJson(Map<String, dynamic> json) =>
      _$SensitivityFromJson(json);
}

// ===== 분석 결과 메인 모델 =====
@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'image_id') required String imageId,

    // === 퍼스널 컬러 ===
    @JsonKey(name: 'personal_color') String? personalColor,
    @JsonKey(name: 'personal_color_confidence') double? personalColorConfidence,
    @JsonKey(name: 'personal_color_description') String? personalColorDescription,
    @JsonKey(name: 'undertone') String? undertone,
    @JsonKey(name: 'undertone_confidence') double? undertoneConfidence,
    @JsonKey(name: 'skin_tone_rgb') List<int>? skinToneRgb,
    @JsonKey(name: 'skin_tone_lab') List<double>? skinToneLab,

    // 인생 컬러 팔레트
    @JsonKey(name: 'best_colors') List<String>? bestColors,
    @JsonKey(name: 'worst_colors') List<String>? worstColors,

    // === 피부 타입 ===
    @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
    @JsonKey(name: 'skin_type_description') String? skinTypeDescription,

    // === 민감성 (⭐ 타입 변경: String? → Sensitivity?) ===
    @JsonKey(name: 'sensitivity') Sensitivity? sensitivity,
    
    // 하위 호환성을 위해 남겨둠 (Deprecated)
    @Deprecated('Use sensitivity.sensitivityScore instead')
    @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
    
    @Deprecated('Use sensitivity.level instead')
    @JsonKey(name: 'sensitivity_level') String? sensitivityLevel,
    
    @Deprecated('Use sensitivity.riskFactors instead')
    @JsonKey(name: 'risk_factors') List<String>? riskFactors,

    // === 상세 지표 ===
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

    // === 루틴 ===
    @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,

    // === 얼굴 인식 ===
    @JsonKey(name: 'face_detected') bool? faceDetected,
    @JsonKey(name: 'face_quality_score') double? faceQualityScore,

    // === 원본 데이터 ===
    @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,

    // === GPT 결과 ===
    @JsonKey(name: 'ai_analysis') AiAnalysis? aiAnalysis,

    // === 타임스탬프 ===
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

// ===== 확장 메서드: API 응답 → AnalysisResult 변환 =====
extension AnalysisResultApi on AnalysisResult {
  static AnalysisResult fromApi(
    Map<String, dynamic> json, {
    required String tempId,
    required String tempUserId,
    required String tempImageId,
  }) {
    final sensMap = (json['sensitivity'] as Map<String, dynamic>?);
    final ai = (json['ai_analysis'] as Map<String, dynamic>?);

    // ⭐ Sensitivity 객체 생성
    final sensitivity = sensMap != null ? Sensitivity(
      level: sensMap['level'] as String?,
      sensitivityScore: (sensMap['sensitivity_score'] is num)
          ? (sensMap['sensitivity_score'] as num).toDouble()
          : null,
      pore: (sensMap['pore'] as num?)?.toInt(),
      elasticity: (sensMap['elasticity'] as num?)?.toInt(),
      pigmentation: (sensMap['pigmentation'] as num?)?.toInt(),
      dryness: (sensMap['dryness'] as num?)?.toInt(),
      wrinkle: (sensMap['wrinkle'] as num?)?.toInt(),
      acne: (sensMap['acne'] as num?)?.toInt(),
      redness: (sensMap['redness'] as num?)?.toInt(),
      riskFactors: (sensMap['risk_factors'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    ) : null;

    return AnalysisResult(
      id: tempId,
      userId: tempUserId,
      imageId: tempImageId,
      
      personalColor: json['personal_color'] as String?,
      personalColorConfidence:
          (json['personal_color_confidence'] as num?)?.toDouble(),
      personalColorDescription: null,
      undertone: json['undertone'] as String?,
      undertoneConfidence: (json['undertone_confidence'] as num?)?.toDouble(),
      skinToneRgb: (json['skin_tone_rgb'] as List?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      skinToneLab: (json['skin_tone_lab'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      
      bestColors: null,
      worstColors: null,
      
      detectedSkinType: null,
      skinTypeDescription: null,
      
      // ⭐ sensitivity 객체 추가
      sensitivity: sensitivity,
      
      // 하위 호환성
      sensitivityScore: sensitivity?.sensitivityScore,
      sensitivityLevel: sensitivity?.level,
      riskFactors: sensitivity?.riskFactors,
      
      poreScore: sensitivity?.pore,
      poreDescription: null,
      wrinkleScore: sensitivity?.wrinkle,
      wrinkleDescription: null,
      elasticityScore: sensitivity?.elasticity,
      elasticityDescription: null,
      acneScore: sensitivity?.acne,
      acneDescription: null,
      pigmentationScore: sensitivity?.pigmentation,
      pigmentationDescription: null,
      rednessScore: sensitivity?.redness,
      rednessDescription: null,
      
      skincareRoutine: null,
      
      faceDetected: true,
      faceQualityScore: null,
      
      rawAnalysisData: null,
      
      aiAnalysis: ai != null ? AiAnalysis.fromJson(ai) : null,
      
      createdAt: DateTime.now(),
    );
  }
}

// ===== 퍼스널 컬러 타입 상수 =====
class PersonalColorType {
  static const String springWarmLight = 'spring_warm_light';
  static const String springWarmBright = 'spring_warm_bright';
  static const String summerCoolLight = 'summer_cool_light';
  static const String summerCoolMuted = 'summer_cool_muted';
  static const String autumnWarmMuted = 'autumn_warm_muted';
  static const String autumnWarmDeep = 'autumn_warm_deep';
  static const String winterCoolBright = 'winter_cool_bright';
  static const String winterCoolDeep = 'winter_cool_deep';

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
        return 'assets/17/personalcolor/wc_deep.png';
    }
  }
}

// ===== 민감성 레벨 헬퍼 클래스 =====
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

  static String getColor(String level) {
    switch (level) {
      case safe:
        return '#4CAF50';
      case low:
        return '#8BC34A';
      case moderate:
        return '#FFC107';
      case caution:
        return '#FF9800';
      case high:
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }

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
        return 'assets/17/gage_caution.png';
      default:
        return 'assets/17/gage_moderate.png';
    }
  }
}

// ===== 피부 타입 =====
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

  static String toHashtag(String type) {
    return '#${toKorean(type)}';
  }

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
        return 'assets/17/skin/joongsung.png';
    }
  }
}

// ===== 피부 상세 분석 항목 =====
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

  static String getProgressColor(int score) {
    if (score >= 80) return '#4CAF50';
    if (score >= 60) return '#8BC34A';
    if (score >= 40) return '#FFC107';
    if (score >= 20) return '#FF9800';
    return '#F44336';
  }

  static String getScoreLabel(int score) {
    if (score >= 80) return '매우 좋음';
    if (score >= 60) return '좋음';
    if (score >= 40) return '보통';
    if (score >= 20) return '개선 필요';
    return '주의 필요';
  }
}