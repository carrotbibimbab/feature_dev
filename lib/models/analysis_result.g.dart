// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageId: json['image_id'] as String,
      personalColor: json['personal_color'] as String?,
      personalColorConfidence:
          (json['personal_color_confidence'] as num?)?.toDouble(),
      personalColorDescription: json['personal_color_description'] as String?,
      bestColors: (json['best_colors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      worstColors: (json['worst_colors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      detectedSkinType: json['detected_skin_type'] as String?,
      skinTypeDescription: json['skin_type_description'] as String?,
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
      'best_colors': instance.bestColors,
      'worst_colors': instance.worstColors,
      'detected_skin_type': instance.detectedSkinType,
      'skin_type_description': instance.skinTypeDescription,
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
      'created_at': instance.createdAt?.toIso8601String(),
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
