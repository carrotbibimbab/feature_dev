// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uploaded_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadedImage _$UploadedImageFromJson(Map<String, dynamic> json) {
  return _UploadedImage.fromJson(json);
}

/// @nodoc
mixin _$UploadedImage {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError; // 스토리지 정보
  @JsonKey(name: 'storage_path')
  String get storagePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int? get fileSize =>
      throw _privateConstructorUsedError; // 분석 상태 (화면 14: 분석 중 페이지)
  @JsonKey(name: 'analysis_status')
  String? get analysisStatus =>
      throw _privateConstructorUsedError; // pending → processing → completed / failed
// 타임스탬프
  @JsonKey(name: 'uploaded_at')
  DateTime? get uploadedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'analyzed_at')
  DateTime? get analyzedAt => throw _privateConstructorUsedError;

  /// Serializes this UploadedImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadedImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadedImageCopyWith<UploadedImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadedImageCopyWith<$Res> {
  factory $UploadedImageCopyWith(
          UploadedImage value, $Res Function(UploadedImage) then) =
      _$UploadedImageCopyWithImpl<$Res, UploadedImage>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'storage_path') String storagePath,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'analysis_status') String? analysisStatus,
      @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
      @JsonKey(name: 'analyzed_at') DateTime? analyzedAt});
}

/// @nodoc
class _$UploadedImageCopyWithImpl<$Res, $Val extends UploadedImage>
    implements $UploadedImageCopyWith<$Res> {
  _$UploadedImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadedImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? storagePath = null,
    Object? imageUrl = null,
    Object? fileSize = freezed,
    Object? analysisStatus = freezed,
    Object? uploadedAt = freezed,
    Object? analyzedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      analysisStatus: freezed == analysisStatus
          ? _value.analysisStatus
          : analysisStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadedImageImplCopyWith<$Res>
    implements $UploadedImageCopyWith<$Res> {
  factory _$$UploadedImageImplCopyWith(
          _$UploadedImageImpl value, $Res Function(_$UploadedImageImpl) then) =
      __$$UploadedImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'storage_path') String storagePath,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'analysis_status') String? analysisStatus,
      @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
      @JsonKey(name: 'analyzed_at') DateTime? analyzedAt});
}

/// @nodoc
class __$$UploadedImageImplCopyWithImpl<$Res>
    extends _$UploadedImageCopyWithImpl<$Res, _$UploadedImageImpl>
    implements _$$UploadedImageImplCopyWith<$Res> {
  __$$UploadedImageImplCopyWithImpl(
      _$UploadedImageImpl _value, $Res Function(_$UploadedImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadedImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? storagePath = null,
    Object? imageUrl = null,
    Object? fileSize = freezed,
    Object? analysisStatus = freezed,
    Object? uploadedAt = freezed,
    Object? analyzedAt = freezed,
  }) {
    return _then(_$UploadedImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      analysisStatus: freezed == analysisStatus
          ? _value.analysisStatus
          : analysisStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadedImageImpl implements _UploadedImage {
  const _$UploadedImageImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'storage_path') required this.storagePath,
      @JsonKey(name: 'image_url') required this.imageUrl,
      @JsonKey(name: 'file_size') this.fileSize,
      @JsonKey(name: 'analysis_status') this.analysisStatus,
      @JsonKey(name: 'uploaded_at') this.uploadedAt,
      @JsonKey(name: 'analyzed_at') this.analyzedAt});

  factory _$UploadedImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadedImageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
// 스토리지 정보
  @override
  @JsonKey(name: 'storage_path')
  final String storagePath;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'file_size')
  final int? fileSize;
// 분석 상태 (화면 14: 분석 중 페이지)
  @override
  @JsonKey(name: 'analysis_status')
  final String? analysisStatus;
// pending → processing → completed / failed
// 타임스탬프
  @override
  @JsonKey(name: 'uploaded_at')
  final DateTime? uploadedAt;
  @override
  @JsonKey(name: 'analyzed_at')
  final DateTime? analyzedAt;

  @override
  String toString() {
    return 'UploadedImage(id: $id, userId: $userId, storagePath: $storagePath, imageUrl: $imageUrl, fileSize: $fileSize, analysisStatus: $analysisStatus, uploadedAt: $uploadedAt, analyzedAt: $analyzedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadedImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.analysisStatus, analysisStatus) ||
                other.analysisStatus == analysisStatus) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, storagePath,
      imageUrl, fileSize, analysisStatus, uploadedAt, analyzedAt);

  /// Create a copy of UploadedImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadedImageImplCopyWith<_$UploadedImageImpl> get copyWith =>
      __$$UploadedImageImplCopyWithImpl<_$UploadedImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadedImageImplToJson(
      this,
    );
  }
}

abstract class _UploadedImage implements UploadedImage {
  const factory _UploadedImage(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'storage_path') required final String storagePath,
          @JsonKey(name: 'image_url') required final String imageUrl,
          @JsonKey(name: 'file_size') final int? fileSize,
          @JsonKey(name: 'analysis_status') final String? analysisStatus,
          @JsonKey(name: 'uploaded_at') final DateTime? uploadedAt,
          @JsonKey(name: 'analyzed_at') final DateTime? analyzedAt}) =
      _$UploadedImageImpl;

  factory _UploadedImage.fromJson(Map<String, dynamic> json) =
      _$UploadedImageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId; // 스토리지 정보
  @override
  @JsonKey(name: 'storage_path')
  String get storagePath;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'file_size')
  int? get fileSize; // 분석 상태 (화면 14: 분석 중 페이지)
  @override
  @JsonKey(name: 'analysis_status')
  String? get analysisStatus; // pending → processing → completed / failed
// 타임스탬프
  @override
  @JsonKey(name: 'uploaded_at')
  DateTime? get uploadedAt;
  @override
  @JsonKey(name: 'analyzed_at')
  DateTime? get analyzedAt;

  /// Create a copy of UploadedImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadedImageImplCopyWith<_$UploadedImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
