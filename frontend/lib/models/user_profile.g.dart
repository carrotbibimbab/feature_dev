// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      provider: json['provider'] as String?,
      birthYear: (json['birth_year'] as num?)?.toInt(),
      skinType: json['skin_type'] as String?,
      profileCompleted: json['profile_completed'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      skinConcerns: (json['skin_concerns'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'provider': instance.provider,
      'birth_year': instance.birthYear,
      'skin_type': instance.skinType,
      'profile_completed': instance.profileCompleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'allergies': instance.allergies,
      'skin_concerns': instance.skinConcerns,
    };
