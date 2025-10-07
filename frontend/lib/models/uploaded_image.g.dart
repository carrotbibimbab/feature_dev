// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UploadedImageImpl _$$UploadedImageImplFromJson(Map<String, dynamic> json) =>
    _$UploadedImageImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storagePath: json['storage_path'] as String,
      imageUrl: json['image_url'] as String,
      fileSize: (json['file_size'] as num?)?.toInt(),
      analysisStatus: json['analysis_status'] as String?,
      uploadedAt: json['uploaded_at'] == null
          ? null
          : DateTime.parse(json['uploaded_at'] as String),
      analyzedAt: json['analyzed_at'] == null
          ? null
          : DateTime.parse(json['analyzed_at'] as String),
    );

Map<String, dynamic> _$$UploadedImageImplToJson(_$UploadedImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'storage_path': instance.storagePath,
      'image_url': instance.imageUrl,
      'file_size': instance.fileSize,
      'analysis_status': instance.analysisStatus,
      'uploaded_at': instance.uploadedAt?.toIso8601String(),
      'analyzed_at': instance.analyzedAt?.toIso8601String(),
    };
