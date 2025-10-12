// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiAnalysisImpl _$$AiAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$AiAnalysisImpl(
      summary: json['summary'] as String,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      cautions: (json['cautions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      fullContent: json['full_content'] as String?,
      tokensUsed: (json['tokens_used'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AiAnalysisImplToJson(_$AiAnalysisImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'recommendations': instance.recommendations,
      'cautions': instance.cautions,
      'full_content': instance.fullContent,
      'tokens_used': instance.tokensUsed,
    };

_$SkincareStepImpl _$$SkincareStepImplFromJson(Map<String, dynamic> json) =>
    _$SkincareStepImpl(
      step: (json['step'] as num).toInt(),
      type: json['type'] as String,
      description: json['description'] as String,
      productExample: json['productExample'] as String?,
      iconAsset: json['iconAsset'] as String?,
    );

Map<String, dynamic> _$$SkincareStepImplToJson(_$SkincareStepImpl instance) =>
    <String, dynamic>{
      'step': instance.step,
      'type': instance.type,
      'description': instance.description,
      'productExample': instance.productExample,
      'iconAsset': instance.iconAsset,
    };

_$SensitivityImpl _$$SensitivityImplFromJson(Map<String, dynamic> json) =>
    _$SensitivityImpl(
      level: json['level'] as String?,
      sensitivityScore: (json['sensitivity_score'] as num?)?.toDouble(),
      pore: (json['pore'] as num?)?.toInt(),
      elasticity: (json['elasticity'] as num?)?.toInt(),
      pigmentation: (json['pigmentation'] as num?)?.toInt(),
      dryness: (json['dryness'] as num?)?.toInt(),
      wrinkle: (json['wrinkle'] as num?)?.toInt(),
      acne: (json['acne'] as num?)?.toInt(),
      redness: (json['redness'] as num?)?.toInt(),
      riskFactors: (json['risk_factors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$SensitivityImplToJson(_$SensitivityImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'sensitivity_score': instance.sensitivityScore,
      'pore': instance.pore,
      'elasticity': instance.elasticity,
      'pigmentation': instance.pigmentation,
      'dryness': instance.dryness,
      'wrinkle': instance.wrinkle,
      'acne': instance.acne,
      'redness': instance.redness,
      'risk_factors': instance.riskFactors,
    };

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageId: json['image_id'] as String,
      personalColor: json['personal_color'] as String?,
      personalColorConfidence:
          (json['personal_color_confidence'] as num?)?.toDouble(),
      personalColorDescription: json['personal_color_description'] as String?,
      undertone: json['undertone'] as String?,
      undertoneConfidence: (json['undertone_confidence'] as num?)?.toDouble(),
      skinToneRgb: (json['skin_tone_rgb'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      skinToneLab: (json['skin_tone_lab'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      bestColors: (json['best_colors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      worstColors: (json['worst_colors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      detectedSkinType: json['detected_skin_type'] as String?,
      skinTypeDescription: json['skin_type_description'] as String?,
      sensitivity: json['sensitivity'] == null
          ? null
          : Sensitivity.fromJson(json['sensitivity'] as Map<String, dynamic>),
      sensitivityScore: (json['sensitivity_score'] as num?)?.toDouble(),
      sensitivityLevel: json['sensitivity_level'] as String?,
      riskFactors: (json['risk_factors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      poreScore: (json['pore_score'] as num?)?.toInt(),
      poreDescription: json['pore_description'] as String?,
      wrinkleScore: (json['wrinkle_score'] as num?)?.toInt(),
      wrinkleDescription: json['wrinkle_description'] as String?,
      elasticityScore: (json['elasticity_score'] as num?)?.toInt(),
      elasticityDescription: json['elasticity_description'] as String?,
      acneScore: (json['acne_score'] as num?)?.toInt(),
      acneDescription: json['acne_description'] as String?,
      pigmentationScore: (json['pigmentation_score'] as num?)?.toInt(),
      pigmentationDescription: json['pigmentation_description'] as String?,
      rednessScore: (json['redness_score'] as num?)?.toInt(),
      rednessDescription: json['redness_description'] as String?,
      skincareRoutine: (json['skincare_routine'] as List<dynamic>?)
          ?.map((e) => SkincareStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      faceDetected: json['face_detected'] as bool?,
      faceQualityScore: (json['face_quality_score'] as num?)?.toDouble(),
      rawAnalysisData: json['raw_analysis_data'] as Map<String, dynamic>?,
      aiAnalysis: json['ai_analysis'] == null
          ? null
          : AiAnalysis.fromJson(json['ai_analysis'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
        _$AnalysisResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'image_id': instance.imageId,
      'personal_color': instance.personalColor,
      'personal_color_confidence': instance.personalColorConfidence,
      'personal_color_description': instance.personalColorDescription,
      'undertone': instance.undertone,
      'undertone_confidence': instance.undertoneConfidence,
      'skin_tone_rgb': instance.skinToneRgb,
      'skin_tone_lab': instance.skinToneLab,
      'best_colors': instance.bestColors,
      'worst_colors': instance.worstColors,
      'detected_skin_type': instance.detectedSkinType,
      'skin_type_description': instance.skinTypeDescription,
      'sensitivity': instance.sensitivity,
      'sensitivity_score': instance.sensitivityScore,
      'sensitivity_level': instance.sensitivityLevel,
      'risk_factors': instance.riskFactors,
      'pore_score': instance.poreScore,
      'pore_description': instance.poreDescription,
      'wrinkle_score': instance.wrinkleScore,
      'wrinkle_description': instance.wrinkleDescription,
      'elasticity_score': instance.elasticityScore,
      'elasticity_description': instance.elasticityDescription,
      'acne_score': instance.acneScore,
      'acne_description': instance.acneDescription,
      'pigmentation_score': instance.pigmentationScore,
      'pigmentation_description': instance.pigmentationDescription,
      'redness_score': instance.rednessScore,
      'redness_description': instance.rednessDescription,
      'skincare_routine': instance.skincareRoutine,
      'face_detected': instance.faceDetected,
      'face_quality_score': instance.faceQualityScore,
      'raw_analysis_data': instance.rawAnalysisData,
      'ai_analysis': instance.aiAnalysis,
      'created_at': instance.createdAt?.toIso8601String(),
    };
