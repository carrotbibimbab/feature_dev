// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_id')
  String get imageId => throw _privateConstructorUsedError; // ❌ 제거: 퍼스널 컬러 진단
// @JsonKey(name: 'personal_color') String? personalColor,
// @JsonKey(name: 'personal_color_confidence') double? personalColorConfidence,
// @JsonKey(name: 'personal_color_description') String? personalColorDescription,
// @JsonKey(name: 'best_colors') List<String>? bestColors,
// @JsonKey(name: 'worst_colors') List<String>? worstColors,
// ❌ 제거: 피부 타입 분석
// @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
// @JsonKey(name: 'skin_type_description') String? skinTypeDescription,
// ✅ 3. 민감성 위험도 (게이지) - 3단계로 변경
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore => throw _privateConstructorUsedError; // 0-10
  @JsonKey(name: 'sensitivity_level')
  String? get sensitivityLevel =>
      throw _privateConstructorUsedError; // low/medium/high
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors =>
      throw _privateConstructorUsedError; // ✅ 4. 피부 상세 분석 (4가지)
  @JsonKey(name: 'dryness_score')
  int? get drynessScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'dryness_description')
  String? get drynessDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'pigmentation_score')
  int? get pigmentationScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pigmentation_description')
  String? get pigmentationDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'pore_score')
  int? get poreScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pore_description')
  String? get poreDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'elasticity_score')
  int? get elasticityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'elasticity_description')
  String? get elasticityDescription =>
      throw _privateConstructorUsedError; // ❌ 제거된 상세 분석
// @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
// @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
// @JsonKey(name: 'acne_score') int? acneScore,
// @JsonKey(name: 'acne_description') String? acneDescription,
// @JsonKey(name: 'redness_score') int? rednessScore,
// @JsonKey(name: 'redness_description') String? rednessDescription,
// ✅ 5. 핵심 솔루션: 스킨케어 루틴
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine =>
      throw _privateConstructorUsedError; // === 6. 얼굴 인식 품질 ===
  @JsonKey(name: 'face_detected')
  bool? get faceDetected => throw _privateConstructorUsedError;
  @JsonKey(name: 'face_quality_score')
  double? get faceQualityScore =>
      throw _privateConstructorUsedError; // === 7. 원본 데이터 (백업) ===
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData =>
      throw _privateConstructorUsedError; // === 타임스탬프 ===
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResultCopyWith<AnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultCopyWith<$Res> {
  factory $AnalysisResultCopyWith(
          AnalysisResult value, $Res Function(AnalysisResult) then) =
      _$AnalysisResultCopyWithImpl<$Res, AnalysisResult>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'image_id') String imageId,
      @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
      @JsonKey(name: 'sensitivity_level') String? sensitivityLevel,
      @JsonKey(name: 'risk_factors') List<String>? riskFactors,
      @JsonKey(name: 'dryness_score') int? drynessScore,
      @JsonKey(name: 'dryness_description') String? drynessDescription,
      @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      String? pigmentationDescription,
      @JsonKey(name: 'pore_score') int? poreScore,
      @JsonKey(name: 'pore_description') String? poreDescription,
      @JsonKey(name: 'elasticity_score') int? elasticityScore,
      @JsonKey(name: 'elasticity_description') String? elasticityDescription,
      @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') bool? faceDetected,
      @JsonKey(name: 'face_quality_score') double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res, $Val extends AnalysisResult>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? imageId = null,
    Object? sensitivityScore = freezed,
    Object? sensitivityLevel = freezed,
    Object? riskFactors = freezed,
    Object? drynessScore = freezed,
    Object? drynessDescription = freezed,
    Object? pigmentationScore = freezed,
    Object? pigmentationDescription = freezed,
    Object? poreScore = freezed,
    Object? poreDescription = freezed,
    Object? elasticityScore = freezed,
    Object? elasticityDescription = freezed,
    Object? skincareRoutine = freezed,
    Object? faceDetected = freezed,
    Object? faceQualityScore = freezed,
    Object? rawAnalysisData = freezed,
    Object? createdAt = freezed,
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
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      sensitivityScore: freezed == sensitivityScore
          ? _value.sensitivityScore
          : sensitivityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sensitivityLevel: freezed == sensitivityLevel
          ? _value.sensitivityLevel
          : sensitivityLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      riskFactors: freezed == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      drynessScore: freezed == drynessScore
          ? _value.drynessScore
          : drynessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      drynessDescription: freezed == drynessDescription
          ? _value.drynessDescription
          : drynessDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      pigmentationScore: freezed == pigmentationScore
          ? _value.pigmentationScore
          : pigmentationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentationDescription: freezed == pigmentationDescription
          ? _value.pigmentationDescription
          : pigmentationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      poreScore: freezed == poreScore
          ? _value.poreScore
          : poreScore // ignore: cast_nullable_to_non_nullable
              as int?,
      poreDescription: freezed == poreDescription
          ? _value.poreDescription
          : poreDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      elasticityScore: freezed == elasticityScore
          ? _value.elasticityScore
          : elasticityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticityDescription: freezed == elasticityDescription
          ? _value.elasticityDescription
          : elasticityDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      skincareRoutine: freezed == skincareRoutine
          ? _value.skincareRoutine
          : skincareRoutine // ignore: cast_nullable_to_non_nullable
              as List<SkincareStep>?,
      faceDetected: freezed == faceDetected
          ? _value.faceDetected
          : faceDetected // ignore: cast_nullable_to_non_nullable
              as bool?,
      faceQualityScore: freezed == faceQualityScore
          ? _value.faceQualityScore
          : faceQualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      rawAnalysisData: freezed == rawAnalysisData
          ? _value.rawAnalysisData
          : rawAnalysisData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalysisResultImplCopyWith<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  factory _$$AnalysisResultImplCopyWith(_$AnalysisResultImpl value,
          $Res Function(_$AnalysisResultImpl) then) =
      __$$AnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'image_id') String imageId,
      @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
      @JsonKey(name: 'sensitivity_level') String? sensitivityLevel,
      @JsonKey(name: 'risk_factors') List<String>? riskFactors,
      @JsonKey(name: 'dryness_score') int? drynessScore,
      @JsonKey(name: 'dryness_description') String? drynessDescription,
      @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      String? pigmentationDescription,
      @JsonKey(name: 'pore_score') int? poreScore,
      @JsonKey(name: 'pore_description') String? poreDescription,
      @JsonKey(name: 'elasticity_score') int? elasticityScore,
      @JsonKey(name: 'elasticity_description') String? elasticityDescription,
      @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') bool? faceDetected,
      @JsonKey(name: 'face_quality_score') double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$AnalysisResultImplCopyWithImpl<$Res>
    extends _$AnalysisResultCopyWithImpl<$Res, _$AnalysisResultImpl>
    implements _$$AnalysisResultImplCopyWith<$Res> {
  __$$AnalysisResultImplCopyWithImpl(
      _$AnalysisResultImpl _value, $Res Function(_$AnalysisResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? imageId = null,
    Object? sensitivityScore = freezed,
    Object? sensitivityLevel = freezed,
    Object? riskFactors = freezed,
    Object? drynessScore = freezed,
    Object? drynessDescription = freezed,
    Object? pigmentationScore = freezed,
    Object? pigmentationDescription = freezed,
    Object? poreScore = freezed,
    Object? poreDescription = freezed,
    Object? elasticityScore = freezed,
    Object? elasticityDescription = freezed,
    Object? skincareRoutine = freezed,
    Object? faceDetected = freezed,
    Object? faceQualityScore = freezed,
    Object? rawAnalysisData = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AnalysisResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as String,
      sensitivityScore: freezed == sensitivityScore
          ? _value.sensitivityScore
          : sensitivityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sensitivityLevel: freezed == sensitivityLevel
          ? _value.sensitivityLevel
          : sensitivityLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      riskFactors: freezed == riskFactors
          ? _value._riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      drynessScore: freezed == drynessScore
          ? _value.drynessScore
          : drynessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      drynessDescription: freezed == drynessDescription
          ? _value.drynessDescription
          : drynessDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      pigmentationScore: freezed == pigmentationScore
          ? _value.pigmentationScore
          : pigmentationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentationDescription: freezed == pigmentationDescription
          ? _value.pigmentationDescription
          : pigmentationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      poreScore: freezed == poreScore
          ? _value.poreScore
          : poreScore // ignore: cast_nullable_to_non_nullable
              as int?,
      poreDescription: freezed == poreDescription
          ? _value.poreDescription
          : poreDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      elasticityScore: freezed == elasticityScore
          ? _value.elasticityScore
          : elasticityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticityDescription: freezed == elasticityDescription
          ? _value.elasticityDescription
          : elasticityDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      skincareRoutine: freezed == skincareRoutine
          ? _value._skincareRoutine
          : skincareRoutine // ignore: cast_nullable_to_non_nullable
              as List<SkincareStep>?,
      faceDetected: freezed == faceDetected
          ? _value.faceDetected
          : faceDetected // ignore: cast_nullable_to_non_nullable
              as bool?,
      faceQualityScore: freezed == faceQualityScore
          ? _value.faceQualityScore
          : faceQualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      rawAnalysisData: freezed == rawAnalysisData
          ? _value._rawAnalysisData
          : rawAnalysisData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultImpl implements _AnalysisResult {
  const _$AnalysisResultImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'image_id') required this.imageId,
      @JsonKey(name: 'sensitivity_score') this.sensitivityScore,
      @JsonKey(name: 'sensitivity_level') this.sensitivityLevel,
      @JsonKey(name: 'risk_factors') final List<String>? riskFactors,
      @JsonKey(name: 'dryness_score') this.drynessScore,
      @JsonKey(name: 'dryness_description') this.drynessDescription,
      @JsonKey(name: 'pigmentation_score') this.pigmentationScore,
      @JsonKey(name: 'pigmentation_description') this.pigmentationDescription,
      @JsonKey(name: 'pore_score') this.poreScore,
      @JsonKey(name: 'pore_description') this.poreDescription,
      @JsonKey(name: 'elasticity_score') this.elasticityScore,
      @JsonKey(name: 'elasticity_description') this.elasticityDescription,
      @JsonKey(name: 'skincare_routine')
      final List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') this.faceDetected,
      @JsonKey(name: 'face_quality_score') this.faceQualityScore,
      @JsonKey(name: 'raw_analysis_data')
      final Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'created_at') this.createdAt})
      : _riskFactors = riskFactors,
        _skincareRoutine = skincareRoutine,
        _rawAnalysisData = rawAnalysisData;

  factory _$AnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'image_id')
  final String imageId;
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
  @override
  @JsonKey(name: 'sensitivity_score')
  final double? sensitivityScore;
// 0-10
  @override
  @JsonKey(name: 'sensitivity_level')
  final String? sensitivityLevel;
// low/medium/high
  final List<String>? _riskFactors;
// low/medium/high
  @override
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors {
    final value = _riskFactors;
    if (value == null) return null;
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// ✅ 4. 피부 상세 분석 (4가지)
  @override
  @JsonKey(name: 'dryness_score')
  final int? drynessScore;
  @override
  @JsonKey(name: 'dryness_description')
  final String? drynessDescription;
  @override
  @JsonKey(name: 'pigmentation_score')
  final int? pigmentationScore;
  @override
  @JsonKey(name: 'pigmentation_description')
  final String? pigmentationDescription;
  @override
  @JsonKey(name: 'pore_score')
  final int? poreScore;
  @override
  @JsonKey(name: 'pore_description')
  final String? poreDescription;
  @override
  @JsonKey(name: 'elasticity_score')
  final int? elasticityScore;
  @override
  @JsonKey(name: 'elasticity_description')
  final String? elasticityDescription;
// ❌ 제거된 상세 분석
// @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
// @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
// @JsonKey(name: 'acne_score') int? acneScore,
// @JsonKey(name: 'acne_description') String? acneDescription,
// @JsonKey(name: 'redness_score') int? rednessScore,
// @JsonKey(name: 'redness_description') String? rednessDescription,
// ✅ 5. 핵심 솔루션: 스킨케어 루틴
  final List<SkincareStep>? _skincareRoutine;
// ❌ 제거된 상세 분석
// @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
// @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
// @JsonKey(name: 'acne_score') int? acneScore,
// @JsonKey(name: 'acne_description') String? acneDescription,
// @JsonKey(name: 'redness_score') int? rednessScore,
// @JsonKey(name: 'redness_description') String? rednessDescription,
// ✅ 5. 핵심 솔루션: 스킨케어 루틴
  @override
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine {
    final value = _skincareRoutine;
    if (value == null) return null;
    if (_skincareRoutine is EqualUnmodifiableListView) return _skincareRoutine;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// === 6. 얼굴 인식 품질 ===
  @override
  @JsonKey(name: 'face_detected')
  final bool? faceDetected;
  @override
  @JsonKey(name: 'face_quality_score')
  final double? faceQualityScore;
// === 7. 원본 데이터 (백업) ===
  final Map<String, dynamic>? _rawAnalysisData;
// === 7. 원본 데이터 (백업) ===
  @override
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData {
    final value = _rawAnalysisData;
    if (value == null) return null;
    if (_rawAnalysisData is EqualUnmodifiableMapView) return _rawAnalysisData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// === 타임스탬프 ===
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AnalysisResult(id: $id, userId: $userId, imageId: $imageId, sensitivityScore: $sensitivityScore, sensitivityLevel: $sensitivityLevel, riskFactors: $riskFactors, drynessScore: $drynessScore, drynessDescription: $drynessDescription, pigmentationScore: $pigmentationScore, pigmentationDescription: $pigmentationDescription, poreScore: $poreScore, poreDescription: $poreDescription, elasticityScore: $elasticityScore, elasticityDescription: $elasticityDescription, skincareRoutine: $skincareRoutine, faceDetected: $faceDetected, faceQualityScore: $faceQualityScore, rawAnalysisData: $rawAnalysisData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.sensitivityScore, sensitivityScore) ||
                other.sensitivityScore == sensitivityScore) &&
            (identical(other.sensitivityLevel, sensitivityLevel) ||
                other.sensitivityLevel == sensitivityLevel) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors) &&
            (identical(other.drynessScore, drynessScore) ||
                other.drynessScore == drynessScore) &&
            (identical(other.drynessDescription, drynessDescription) ||
                other.drynessDescription == drynessDescription) &&
            (identical(other.pigmentationScore, pigmentationScore) ||
                other.pigmentationScore == pigmentationScore) &&
            (identical(
                    other.pigmentationDescription, pigmentationDescription) ||
                other.pigmentationDescription == pigmentationDescription) &&
            (identical(other.poreScore, poreScore) ||
                other.poreScore == poreScore) &&
            (identical(other.poreDescription, poreDescription) ||
                other.poreDescription == poreDescription) &&
            (identical(other.elasticityScore, elasticityScore) ||
                other.elasticityScore == elasticityScore) &&
            (identical(other.elasticityDescription, elasticityDescription) ||
                other.elasticityDescription == elasticityDescription) &&
            const DeepCollectionEquality()
                .equals(other._skincareRoutine, _skincareRoutine) &&
            (identical(other.faceDetected, faceDetected) ||
                other.faceDetected == faceDetected) &&
            (identical(other.faceQualityScore, faceQualityScore) ||
                other.faceQualityScore == faceQualityScore) &&
            const DeepCollectionEquality()
                .equals(other._rawAnalysisData, _rawAnalysisData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        imageId,
        sensitivityScore,
        sensitivityLevel,
        const DeepCollectionEquality().hash(_riskFactors),
        drynessScore,
        drynessDescription,
        pigmentationScore,
        pigmentationDescription,
        poreScore,
        poreDescription,
        elasticityScore,
        elasticityDescription,
        const DeepCollectionEquality().hash(_skincareRoutine),
        faceDetected,
        faceQualityScore,
        const DeepCollectionEquality().hash(_rawAnalysisData),
        createdAt
      ]);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      __$$AnalysisResultImplCopyWithImpl<_$AnalysisResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultImplToJson(
      this,
    );
  }
}

abstract class _AnalysisResult implements AnalysisResult {
  const factory _AnalysisResult(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'image_id') required final String imageId,
      @JsonKey(name: 'sensitivity_score') final double? sensitivityScore,
      @JsonKey(name: 'sensitivity_level') final String? sensitivityLevel,
      @JsonKey(name: 'risk_factors') final List<String>? riskFactors,
      @JsonKey(name: 'dryness_score') final int? drynessScore,
      @JsonKey(name: 'dryness_description') final String? drynessDescription,
      @JsonKey(name: 'pigmentation_score') final int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      final String? pigmentationDescription,
      @JsonKey(name: 'pore_score') final int? poreScore,
      @JsonKey(name: 'pore_description') final String? poreDescription,
      @JsonKey(name: 'elasticity_score') final int? elasticityScore,
      @JsonKey(name: 'elasticity_description')
      final String? elasticityDescription,
      @JsonKey(name: 'skincare_routine')
      final List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') final bool? faceDetected,
      @JsonKey(name: 'face_quality_score') final double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data')
      final Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$AnalysisResultImpl;

  factory _AnalysisResult.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'image_id')
  String get imageId; // ❌ 제거: 퍼스널 컬러 진단
// @JsonKey(name: 'personal_color') String? personalColor,
// @JsonKey(name: 'personal_color_confidence') double? personalColorConfidence,
// @JsonKey(name: 'personal_color_description') String? personalColorDescription,
// @JsonKey(name: 'best_colors') List<String>? bestColors,
// @JsonKey(name: 'worst_colors') List<String>? worstColors,
// ❌ 제거: 피부 타입 분석
// @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
// @JsonKey(name: 'skin_type_description') String? skinTypeDescription,
// ✅ 3. 민감성 위험도 (게이지) - 3단계로 변경
  @override
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore; // 0-10
  @override
  @JsonKey(name: 'sensitivity_level')
  String? get sensitivityLevel; // low/medium/high
  @override
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors; // ✅ 4. 피부 상세 분석 (4가지)
  @override
  @JsonKey(name: 'dryness_score')
  int? get drynessScore;
  @override
  @JsonKey(name: 'dryness_description')
  String? get drynessDescription;
  @override
  @JsonKey(name: 'pigmentation_score')
  int? get pigmentationScore;
  @override
  @JsonKey(name: 'pigmentation_description')
  String? get pigmentationDescription;
  @override
  @JsonKey(name: 'pore_score')
  int? get poreScore;
  @override
  @JsonKey(name: 'pore_description')
  String? get poreDescription;
  @override
  @JsonKey(name: 'elasticity_score')
  int? get elasticityScore;
  @override
  @JsonKey(name: 'elasticity_description')
  String? get elasticityDescription; // ❌ 제거된 상세 분석
// @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
// @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
// @JsonKey(name: 'acne_score') int? acneScore,
// @JsonKey(name: 'acne_description') String? acneDescription,
// @JsonKey(name: 'redness_score') int? rednessScore,
// @JsonKey(name: 'redness_description') String? rednessDescription,
// ✅ 5. 핵심 솔루션: 스킨케어 루틴
  @override
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine; // === 6. 얼굴 인식 품질 ===
  @override
  @JsonKey(name: 'face_detected')
  bool? get faceDetected;
  @override
  @JsonKey(name: 'face_quality_score')
  double? get faceQualityScore; // === 7. 원본 데이터 (백업) ===
  @override
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData; // === 타임스탬프 ===
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkincareStep _$SkincareStepFromJson(Map<String, dynamic> json) {
  return _SkincareStep.fromJson(json);
}

/// @nodoc
mixin _$SkincareStep {
  int get step => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get productExample => throw _privateConstructorUsedError;
  String? get iconAsset => throw _privateConstructorUsedError;

  /// Serializes this SkincareStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkincareStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkincareStepCopyWith<SkincareStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkincareStepCopyWith<$Res> {
  factory $SkincareStepCopyWith(
          SkincareStep value, $Res Function(SkincareStep) then) =
      _$SkincareStepCopyWithImpl<$Res, SkincareStep>;
  @useResult
  $Res call(
      {int step,
      String type,
      String description,
      String? productExample,
      String? iconAsset});
}

/// @nodoc
class _$SkincareStepCopyWithImpl<$Res, $Val extends SkincareStep>
    implements $SkincareStepCopyWith<$Res> {
  _$SkincareStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkincareStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? type = null,
    Object? description = null,
    Object? productExample = freezed,
    Object? iconAsset = freezed,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      productExample: freezed == productExample
          ? _value.productExample
          : productExample // ignore: cast_nullable_to_non_nullable
              as String?,
      iconAsset: freezed == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkincareStepImplCopyWith<$Res>
    implements $SkincareStepCopyWith<$Res> {
  factory _$$SkincareStepImplCopyWith(
          _$SkincareStepImpl value, $Res Function(_$SkincareStepImpl) then) =
      __$$SkincareStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int step,
      String type,
      String description,
      String? productExample,
      String? iconAsset});
}

/// @nodoc
class __$$SkincareStepImplCopyWithImpl<$Res>
    extends _$SkincareStepCopyWithImpl<$Res, _$SkincareStepImpl>
    implements _$$SkincareStepImplCopyWith<$Res> {
  __$$SkincareStepImplCopyWithImpl(
      _$SkincareStepImpl _value, $Res Function(_$SkincareStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkincareStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? type = null,
    Object? description = null,
    Object? productExample = freezed,
    Object? iconAsset = freezed,
  }) {
    return _then(_$SkincareStepImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      productExample: freezed == productExample
          ? _value.productExample
          : productExample // ignore: cast_nullable_to_non_nullable
              as String?,
      iconAsset: freezed == iconAsset
          ? _value.iconAsset
          : iconAsset // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkincareStepImpl implements _SkincareStep {
  const _$SkincareStepImpl(
      {required this.step,
      required this.type,
      required this.description,
      this.productExample,
      this.iconAsset});

  factory _$SkincareStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkincareStepImplFromJson(json);

  @override
  final int step;
  @override
  final String type;
  @override
  final String description;
  @override
  final String? productExample;
  @override
  final String? iconAsset;

  @override
  String toString() {
    return 'SkincareStep(step: $step, type: $type, description: $description, productExample: $productExample, iconAsset: $iconAsset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkincareStepImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.productExample, productExample) ||
                other.productExample == productExample) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, step, type, description, productExample, iconAsset);

  /// Create a copy of SkincareStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkincareStepImplCopyWith<_$SkincareStepImpl> get copyWith =>
      __$$SkincareStepImplCopyWithImpl<_$SkincareStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkincareStepImplToJson(
      this,
    );
  }
}

abstract class _SkincareStep implements SkincareStep {
  const factory _SkincareStep(
      {required final int step,
      required final String type,
      required final String description,
      final String? productExample,
      final String? iconAsset}) = _$SkincareStepImpl;

  factory _SkincareStep.fromJson(Map<String, dynamic> json) =
      _$SkincareStepImpl.fromJson;

  @override
  int get step;
  @override
  String get type;
  @override
  String get description;
  @override
  String? get productExample;
  @override
  String? get iconAsset;

  /// Create a copy of SkincareStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkincareStepImplCopyWith<_$SkincareStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
