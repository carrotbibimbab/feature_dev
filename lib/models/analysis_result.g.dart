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
      sensitivityScore: (json['sensitivity_score'] as num?)?.toDouble(),
      sensitivityLevel: json['sensitivity_level'] as String?,
      riskFactors: (json['risk_factors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      drynessScore: (json['dryness_score'] as num?)?.toInt(),
      drynessDescription: json['dryness_description'] as String?,
      pigmentationScore: (json['pigmentation_score'] as num?)?.toInt(),
      pigmentationDescription: json['pigmentation_description'] as String?,
      poreScore: (json['pore_score'] as num?)?.toInt(),
      poreDescription: json['pore_description'] as String?,
      elasticityScore: (json['elasticity_score'] as num?)?.toInt(),
      elasticityDescription: json['elasticity_description'] as String?,
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
      'sensitivity_score': instance.sensitivityScore,
      'sensitivity_level': instance.sensitivityLevel,
      'risk_factors': instance.riskFactors,
      'dryness_score': instance.drynessScore,
      'dryness_description': instance.drynessDescription,
      'pigmentation_score': instance.pigmentationScore,
      'pigmentation_description': instance.pigmentationDescription,
      'pore_score': instance.poreScore,
      'pore_description': instance.poreDescription,
      'elasticity_score': instance.elasticityScore,
      'elasticity_description': instance.elasticityDescription,
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
