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

AiAnalysis _$AiAnalysisFromJson(Map<String, dynamic> json) {
  return _AiAnalysis.fromJson(json);
}

/// @nodoc
mixin _$AiAnalysis {
  String get summary => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  List<String> get cautions => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_content')
  String? get fullContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'tokens_used')
  int get tokensUsed => throw _privateConstructorUsedError;

  /// Serializes this AiAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiAnalysisCopyWith<AiAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiAnalysisCopyWith<$Res> {
  factory $AiAnalysisCopyWith(
          AiAnalysis value, $Res Function(AiAnalysis) then) =
      _$AiAnalysisCopyWithImpl<$Res, AiAnalysis>;
  @useResult
  $Res call(
      {String summary,
      List<String> recommendations,
      List<String> cautions,
      @JsonKey(name: 'full_content') String? fullContent,
      @JsonKey(name: 'tokens_used') int tokensUsed});
}

/// @nodoc
class _$AiAnalysisCopyWithImpl<$Res, $Val extends AiAnalysis>
    implements $AiAnalysisCopyWith<$Res> {
  _$AiAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? recommendations = null,
    Object? cautions = null,
    Object? fullContent = freezed,
    Object? tokensUsed = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cautions: null == cautions
          ? _value.cautions
          : cautions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fullContent: freezed == fullContent
          ? _value.fullContent
          : fullContent // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: null == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiAnalysisImplCopyWith<$Res>
    implements $AiAnalysisCopyWith<$Res> {
  factory _$$AiAnalysisImplCopyWith(
          _$AiAnalysisImpl value, $Res Function(_$AiAnalysisImpl) then) =
      __$$AiAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      List<String> recommendations,
      List<String> cautions,
      @JsonKey(name: 'full_content') String? fullContent,
      @JsonKey(name: 'tokens_used') int tokensUsed});
}

/// @nodoc
class __$$AiAnalysisImplCopyWithImpl<$Res>
    extends _$AiAnalysisCopyWithImpl<$Res, _$AiAnalysisImpl>
    implements _$$AiAnalysisImplCopyWith<$Res> {
  __$$AiAnalysisImplCopyWithImpl(
      _$AiAnalysisImpl _value, $Res Function(_$AiAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? recommendations = null,
    Object? cautions = null,
    Object? fullContent = freezed,
    Object? tokensUsed = null,
  }) {
    return _then(_$AiAnalysisImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cautions: null == cautions
          ? _value._cautions
          : cautions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fullContent: freezed == fullContent
          ? _value.fullContent
          : fullContent // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: null == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiAnalysisImpl implements _AiAnalysis {
  const _$AiAnalysisImpl(
      {required this.summary,
      final List<String> recommendations = const <String>[],
      final List<String> cautions = const <String>[],
      @JsonKey(name: 'full_content') this.fullContent,
      @JsonKey(name: 'tokens_used') this.tokensUsed = 0})
      : _recommendations = recommendations,
        _cautions = cautions;

  factory _$AiAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiAnalysisImplFromJson(json);

  @override
  final String summary;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final List<String> _cautions;
  @override
  @JsonKey()
  List<String> get cautions {
    if (_cautions is EqualUnmodifiableListView) return _cautions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cautions);
  }

  @override
  @JsonKey(name: 'full_content')
  final String? fullContent;
  @override
  @JsonKey(name: 'tokens_used')
  final int tokensUsed;

  @override
  String toString() {
    return 'AiAnalysis(summary: $summary, recommendations: $recommendations, cautions: $cautions, fullContent: $fullContent, tokensUsed: $tokensUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiAnalysisImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality().equals(other._cautions, _cautions) &&
            (identical(other.fullContent, fullContent) ||
                other.fullContent == fullContent) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      summary,
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_cautions),
      fullContent,
      tokensUsed);

  /// Create a copy of AiAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiAnalysisImplCopyWith<_$AiAnalysisImpl> get copyWith =>
      __$$AiAnalysisImplCopyWithImpl<_$AiAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiAnalysisImplToJson(
      this,
    );
  }
}

abstract class _AiAnalysis implements AiAnalysis {
  const factory _AiAnalysis(
      {required final String summary,
      final List<String> recommendations,
      final List<String> cautions,
      @JsonKey(name: 'full_content') final String? fullContent,
      @JsonKey(name: 'tokens_used') final int tokensUsed}) = _$AiAnalysisImpl;

  factory _AiAnalysis.fromJson(Map<String, dynamic> json) =
      _$AiAnalysisImpl.fromJson;

  @override
  String get summary;
  @override
  List<String> get recommendations;
  @override
  List<String> get cautions;
  @override
  @JsonKey(name: 'full_content')
  String? get fullContent;
  @override
  @JsonKey(name: 'tokens_used')
  int get tokensUsed;

  /// Create a copy of AiAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiAnalysisImplCopyWith<_$AiAnalysisImpl> get copyWith =>
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

Sensitivity _$SensitivityFromJson(Map<String, dynamic> json) {
  return _Sensitivity.fromJson(json);
}

/// @nodoc
mixin _$Sensitivity {
// 레벨 (safe, low, moderate, caution, high)
  String? get level =>
      throw _privateConstructorUsedError; // 민감성 점수 (0-100 또는 0-10)
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore =>
      throw _privateConstructorUsedError; // 상세 지표 (0-100)
  int? get pore => throw _privateConstructorUsedError;
  int? get elasticity => throw _privateConstructorUsedError;
  int? get pigmentation => throw _privateConstructorUsedError;
  int? get dryness => throw _privateConstructorUsedError;
  int? get wrinkle => throw _privateConstructorUsedError;
  int? get acne => throw _privateConstructorUsedError;
  int? get redness => throw _privateConstructorUsedError; // 위험 요인
  @JsonKey(name: 'risk_factors')
  List<String> get riskFactors => throw _privateConstructorUsedError;

  /// Serializes this Sensitivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sensitivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensitivityCopyWith<Sensitivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensitivityCopyWith<$Res> {
  factory $SensitivityCopyWith(
          Sensitivity value, $Res Function(Sensitivity) then) =
      _$SensitivityCopyWithImpl<$Res, Sensitivity>;
  @useResult
  $Res call(
      {String? level,
      @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
      int? pore,
      int? elasticity,
      int? pigmentation,
      int? dryness,
      int? wrinkle,
      int? acne,
      int? redness,
      @JsonKey(name: 'risk_factors') List<String> riskFactors});
}

/// @nodoc
class _$SensitivityCopyWithImpl<$Res, $Val extends Sensitivity>
    implements $SensitivityCopyWith<$Res> {
  _$SensitivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sensitivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? sensitivityScore = freezed,
    Object? pore = freezed,
    Object? elasticity = freezed,
    Object? pigmentation = freezed,
    Object? dryness = freezed,
    Object? wrinkle = freezed,
    Object? acne = freezed,
    Object? redness = freezed,
    Object? riskFactors = null,
  }) {
    return _then(_value.copyWith(
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      sensitivityScore: freezed == sensitivityScore
          ? _value.sensitivityScore
          : sensitivityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      pore: freezed == pore
          ? _value.pore
          : pore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticity: freezed == elasticity
          ? _value.elasticity
          : elasticity // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentation: freezed == pigmentation
          ? _value.pigmentation
          : pigmentation // ignore: cast_nullable_to_non_nullable
              as int?,
      dryness: freezed == dryness
          ? _value.dryness
          : dryness // ignore: cast_nullable_to_non_nullable
              as int?,
      wrinkle: freezed == wrinkle
          ? _value.wrinkle
          : wrinkle // ignore: cast_nullable_to_non_nullable
              as int?,
      acne: freezed == acne
          ? _value.acne
          : acne // ignore: cast_nullable_to_non_nullable
              as int?,
      redness: freezed == redness
          ? _value.redness
          : redness // ignore: cast_nullable_to_non_nullable
              as int?,
      riskFactors: null == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SensitivityImplCopyWith<$Res>
    implements $SensitivityCopyWith<$Res> {
  factory _$$SensitivityImplCopyWith(
          _$SensitivityImpl value, $Res Function(_$SensitivityImpl) then) =
      __$$SensitivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? level,
      @JsonKey(name: 'sensitivity_score') double? sensitivityScore,
      int? pore,
      int? elasticity,
      int? pigmentation,
      int? dryness,
      int? wrinkle,
      int? acne,
      int? redness,
      @JsonKey(name: 'risk_factors') List<String> riskFactors});
}

/// @nodoc
class __$$SensitivityImplCopyWithImpl<$Res>
    extends _$SensitivityCopyWithImpl<$Res, _$SensitivityImpl>
    implements _$$SensitivityImplCopyWith<$Res> {
  __$$SensitivityImplCopyWithImpl(
      _$SensitivityImpl _value, $Res Function(_$SensitivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sensitivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? sensitivityScore = freezed,
    Object? pore = freezed,
    Object? elasticity = freezed,
    Object? pigmentation = freezed,
    Object? dryness = freezed,
    Object? wrinkle = freezed,
    Object? acne = freezed,
    Object? redness = freezed,
    Object? riskFactors = null,
  }) {
    return _then(_$SensitivityImpl(
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      sensitivityScore: freezed == sensitivityScore
          ? _value.sensitivityScore
          : sensitivityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      pore: freezed == pore
          ? _value.pore
          : pore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticity: freezed == elasticity
          ? _value.elasticity
          : elasticity // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentation: freezed == pigmentation
          ? _value.pigmentation
          : pigmentation // ignore: cast_nullable_to_non_nullable
              as int?,
      dryness: freezed == dryness
          ? _value.dryness
          : dryness // ignore: cast_nullable_to_non_nullable
              as int?,
      wrinkle: freezed == wrinkle
          ? _value.wrinkle
          : wrinkle // ignore: cast_nullable_to_non_nullable
              as int?,
      acne: freezed == acne
          ? _value.acne
          : acne // ignore: cast_nullable_to_non_nullable
              as int?,
      redness: freezed == redness
          ? _value.redness
          : redness // ignore: cast_nullable_to_non_nullable
              as int?,
      riskFactors: null == riskFactors
          ? _value._riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SensitivityImpl implements _Sensitivity {
  const _$SensitivityImpl(
      {this.level,
      @JsonKey(name: 'sensitivity_score') this.sensitivityScore,
      this.pore,
      this.elasticity,
      this.pigmentation,
      this.dryness,
      this.wrinkle,
      this.acne,
      this.redness,
      @JsonKey(name: 'risk_factors')
      final List<String> riskFactors = const <String>[]})
      : _riskFactors = riskFactors;

  factory _$SensitivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensitivityImplFromJson(json);

// 레벨 (safe, low, moderate, caution, high)
  @override
  final String? level;
// 민감성 점수 (0-100 또는 0-10)
  @override
  @JsonKey(name: 'sensitivity_score')
  final double? sensitivityScore;
// 상세 지표 (0-100)
  @override
  final int? pore;
  @override
  final int? elasticity;
  @override
  final int? pigmentation;
  @override
  final int? dryness;
  @override
  final int? wrinkle;
  @override
  final int? acne;
  @override
  final int? redness;
// 위험 요인
  final List<String> _riskFactors;
// 위험 요인
  @override
  @JsonKey(name: 'risk_factors')
  List<String> get riskFactors {
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_riskFactors);
  }

  @override
  String toString() {
    return 'Sensitivity(level: $level, sensitivityScore: $sensitivityScore, pore: $pore, elasticity: $elasticity, pigmentation: $pigmentation, dryness: $dryness, wrinkle: $wrinkle, acne: $acne, redness: $redness, riskFactors: $riskFactors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensitivityImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.sensitivityScore, sensitivityScore) ||
                other.sensitivityScore == sensitivityScore) &&
            (identical(other.pore, pore) || other.pore == pore) &&
            (identical(other.elasticity, elasticity) ||
                other.elasticity == elasticity) &&
            (identical(other.pigmentation, pigmentation) ||
                other.pigmentation == pigmentation) &&
            (identical(other.dryness, dryness) || other.dryness == dryness) &&
            (identical(other.wrinkle, wrinkle) || other.wrinkle == wrinkle) &&
            (identical(other.acne, acne) || other.acne == acne) &&
            (identical(other.redness, redness) || other.redness == redness) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      level,
      sensitivityScore,
      pore,
      elasticity,
      pigmentation,
      dryness,
      wrinkle,
      acne,
      redness,
      const DeepCollectionEquality().hash(_riskFactors));

  /// Create a copy of Sensitivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensitivityImplCopyWith<_$SensitivityImpl> get copyWith =>
      __$$SensitivityImplCopyWithImpl<_$SensitivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensitivityImplToJson(
      this,
    );
  }
}

abstract class _Sensitivity implements Sensitivity {
  const factory _Sensitivity(
          {final String? level,
          @JsonKey(name: 'sensitivity_score') final double? sensitivityScore,
          final int? pore,
          final int? elasticity,
          final int? pigmentation,
          final int? dryness,
          final int? wrinkle,
          final int? acne,
          final int? redness,
          @JsonKey(name: 'risk_factors') final List<String> riskFactors}) =
      _$SensitivityImpl;

  factory _Sensitivity.fromJson(Map<String, dynamic> json) =
      _$SensitivityImpl.fromJson;

// 레벨 (safe, low, moderate, caution, high)
  @override
  String? get level; // 민감성 점수 (0-100 또는 0-10)
  @override
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore; // 상세 지표 (0-100)
  @override
  int? get pore;
  @override
  int? get elasticity;
  @override
  int? get pigmentation;
  @override
  int? get dryness;
  @override
  int? get wrinkle;
  @override
  int? get acne;
  @override
  int? get redness; // 위험 요인
  @override
  @JsonKey(name: 'risk_factors')
  List<String> get riskFactors;

  /// Create a copy of Sensitivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensitivityImplCopyWith<_$SensitivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_id')
  String get imageId => throw _privateConstructorUsedError; // === 퍼스널 컬러 ===
  @JsonKey(name: 'personal_color')
  String? get personalColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'personal_color_confidence')
  double? get personalColorConfidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'personal_color_description')
  String? get personalColorDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'undertone')
  String? get undertone => throw _privateConstructorUsedError;
  @JsonKey(name: 'undertone_confidence')
  double? get undertoneConfidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'skin_tone_rgb')
  List<int>? get skinToneRgb => throw _privateConstructorUsedError;
  @JsonKey(name: 'skin_tone_lab')
  List<double>? get skinToneLab =>
      throw _privateConstructorUsedError; // 인생 컬러 팔레트
  @JsonKey(name: 'best_colors')
  List<String>? get bestColors => throw _privateConstructorUsedError;
  @JsonKey(name: 'worst_colors')
  List<String>? get worstColors =>
      throw _privateConstructorUsedError; // === 피부 타입 ===
  @JsonKey(name: 'detected_skin_type')
  String? get detectedSkinType => throw _privateConstructorUsedError;
  @JsonKey(name: 'skin_type_description')
  String? get skinTypeDescription =>
      throw _privateConstructorUsedError; // === 민감성 (⭐ 타입 변경: String? → Sensitivity?) ===
  @JsonKey(name: 'sensitivity')
  Sensitivity? get sensitivity =>
      throw _privateConstructorUsedError; // 하위 호환성을 위해 남겨둠 (Deprecated)
  @Deprecated('Use sensitivity.sensitivityScore instead')
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore => throw _privateConstructorUsedError;
  @Deprecated('Use sensitivity.level instead')
  @JsonKey(name: 'sensitivity_level')
  String? get sensitivityLevel => throw _privateConstructorUsedError;
  @Deprecated('Use sensitivity.riskFactors instead')
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors =>
      throw _privateConstructorUsedError; // === 상세 지표 ===
  @JsonKey(name: 'pore_score')
  int? get poreScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pore_description')
  String? get poreDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'wrinkle_score')
  int? get wrinkleScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'wrinkle_description')
  String? get wrinkleDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'elasticity_score')
  int? get elasticityScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'elasticity_description')
  String? get elasticityDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'acne_score')
  int? get acneScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'acne_description')
  String? get acneDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'pigmentation_score')
  int? get pigmentationScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pigmentation_description')
  String? get pigmentationDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'redness_score')
  int? get rednessScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'redness_description')
  String? get rednessDescription =>
      throw _privateConstructorUsedError; // === 루틴 ===
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine =>
      throw _privateConstructorUsedError; // === 얼굴 인식 ===
  @JsonKey(name: 'face_detected')
  bool? get faceDetected => throw _privateConstructorUsedError;
  @JsonKey(name: 'face_quality_score')
  double? get faceQualityScore =>
      throw _privateConstructorUsedError; // === 원본 데이터 ===
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData =>
      throw _privateConstructorUsedError; // === GPT 결과 ===
  @JsonKey(name: 'ai_analysis')
  AiAnalysis? get aiAnalysis =>
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
      @JsonKey(name: 'personal_color') String? personalColor,
      @JsonKey(name: 'personal_color_confidence')
      double? personalColorConfidence,
      @JsonKey(name: 'personal_color_description')
      String? personalColorDescription,
      @JsonKey(name: 'undertone') String? undertone,
      @JsonKey(name: 'undertone_confidence') double? undertoneConfidence,
      @JsonKey(name: 'skin_tone_rgb') List<int>? skinToneRgb,
      @JsonKey(name: 'skin_tone_lab') List<double>? skinToneLab,
      @JsonKey(name: 'best_colors') List<String>? bestColors,
      @JsonKey(name: 'worst_colors') List<String>? worstColors,
      @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
      @JsonKey(name: 'skin_type_description') String? skinTypeDescription,
      @JsonKey(name: 'sensitivity') Sensitivity? sensitivity,
      @Deprecated('Use sensitivity.sensitivityScore instead')
      @JsonKey(name: 'sensitivity_score')
      double? sensitivityScore,
      @Deprecated('Use sensitivity.level instead')
      @JsonKey(name: 'sensitivity_level')
      String? sensitivityLevel,
      @Deprecated('Use sensitivity.riskFactors instead')
      @JsonKey(name: 'risk_factors')
      List<String>? riskFactors,
      @JsonKey(name: 'pore_score') int? poreScore,
      @JsonKey(name: 'pore_description') String? poreDescription,
      @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
      @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
      @JsonKey(name: 'elasticity_score') int? elasticityScore,
      @JsonKey(name: 'elasticity_description') String? elasticityDescription,
      @JsonKey(name: 'acne_score') int? acneScore,
      @JsonKey(name: 'acne_description') String? acneDescription,
      @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      String? pigmentationDescription,
      @JsonKey(name: 'redness_score') int? rednessScore,
      @JsonKey(name: 'redness_description') String? rednessDescription,
      @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') bool? faceDetected,
      @JsonKey(name: 'face_quality_score') double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'ai_analysis') AiAnalysis? aiAnalysis,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  $SensitivityCopyWith<$Res>? get sensitivity;
  $AiAnalysisCopyWith<$Res>? get aiAnalysis;
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
    Object? personalColor = freezed,
    Object? personalColorConfidence = freezed,
    Object? personalColorDescription = freezed,
    Object? undertone = freezed,
    Object? undertoneConfidence = freezed,
    Object? skinToneRgb = freezed,
    Object? skinToneLab = freezed,
    Object? bestColors = freezed,
    Object? worstColors = freezed,
    Object? detectedSkinType = freezed,
    Object? skinTypeDescription = freezed,
    Object? sensitivity = freezed,
    Object? sensitivityScore = freezed,
    Object? sensitivityLevel = freezed,
    Object? riskFactors = freezed,
    Object? poreScore = freezed,
    Object? poreDescription = freezed,
    Object? wrinkleScore = freezed,
    Object? wrinkleDescription = freezed,
    Object? elasticityScore = freezed,
    Object? elasticityDescription = freezed,
    Object? acneScore = freezed,
    Object? acneDescription = freezed,
    Object? pigmentationScore = freezed,
    Object? pigmentationDescription = freezed,
    Object? rednessScore = freezed,
    Object? rednessDescription = freezed,
    Object? skincareRoutine = freezed,
    Object? faceDetected = freezed,
    Object? faceQualityScore = freezed,
    Object? rawAnalysisData = freezed,
    Object? aiAnalysis = freezed,
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
      personalColor: freezed == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String?,
      personalColorConfidence: freezed == personalColorConfidence
          ? _value.personalColorConfidence
          : personalColorConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      personalColorDescription: freezed == personalColorDescription
          ? _value.personalColorDescription
          : personalColorDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      undertone: freezed == undertone
          ? _value.undertone
          : undertone // ignore: cast_nullable_to_non_nullable
              as String?,
      undertoneConfidence: freezed == undertoneConfidence
          ? _value.undertoneConfidence
          : undertoneConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      skinToneRgb: freezed == skinToneRgb
          ? _value.skinToneRgb
          : skinToneRgb // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      skinToneLab: freezed == skinToneLab
          ? _value.skinToneLab
          : skinToneLab // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      bestColors: freezed == bestColors
          ? _value.bestColors
          : bestColors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      worstColors: freezed == worstColors
          ? _value.worstColors
          : worstColors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      detectedSkinType: freezed == detectedSkinType
          ? _value.detectedSkinType
          : detectedSkinType // ignore: cast_nullable_to_non_nullable
              as String?,
      skinTypeDescription: freezed == skinTypeDescription
          ? _value.skinTypeDescription
          : skinTypeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      sensitivity: freezed == sensitivity
          ? _value.sensitivity
          : sensitivity // ignore: cast_nullable_to_non_nullable
              as Sensitivity?,
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
      poreScore: freezed == poreScore
          ? _value.poreScore
          : poreScore // ignore: cast_nullable_to_non_nullable
              as int?,
      poreDescription: freezed == poreDescription
          ? _value.poreDescription
          : poreDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      wrinkleScore: freezed == wrinkleScore
          ? _value.wrinkleScore
          : wrinkleScore // ignore: cast_nullable_to_non_nullable
              as int?,
      wrinkleDescription: freezed == wrinkleDescription
          ? _value.wrinkleDescription
          : wrinkleDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      elasticityScore: freezed == elasticityScore
          ? _value.elasticityScore
          : elasticityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticityDescription: freezed == elasticityDescription
          ? _value.elasticityDescription
          : elasticityDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      acneScore: freezed == acneScore
          ? _value.acneScore
          : acneScore // ignore: cast_nullable_to_non_nullable
              as int?,
      acneDescription: freezed == acneDescription
          ? _value.acneDescription
          : acneDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      pigmentationScore: freezed == pigmentationScore
          ? _value.pigmentationScore
          : pigmentationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentationDescription: freezed == pigmentationDescription
          ? _value.pigmentationDescription
          : pigmentationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      rednessScore: freezed == rednessScore
          ? _value.rednessScore
          : rednessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      rednessDescription: freezed == rednessDescription
          ? _value.rednessDescription
          : rednessDescription // ignore: cast_nullable_to_non_nullable
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
      aiAnalysis: freezed == aiAnalysis
          ? _value.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as AiAnalysis?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensitivityCopyWith<$Res>? get sensitivity {
    if (_value.sensitivity == null) {
      return null;
    }

    return $SensitivityCopyWith<$Res>(_value.sensitivity!, (value) {
      return _then(_value.copyWith(sensitivity: value) as $Val);
    });
  }

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiAnalysisCopyWith<$Res>? get aiAnalysis {
    if (_value.aiAnalysis == null) {
      return null;
    }

    return $AiAnalysisCopyWith<$Res>(_value.aiAnalysis!, (value) {
      return _then(_value.copyWith(aiAnalysis: value) as $Val);
    });
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
      @JsonKey(name: 'personal_color') String? personalColor,
      @JsonKey(name: 'personal_color_confidence')
      double? personalColorConfidence,
      @JsonKey(name: 'personal_color_description')
      String? personalColorDescription,
      @JsonKey(name: 'undertone') String? undertone,
      @JsonKey(name: 'undertone_confidence') double? undertoneConfidence,
      @JsonKey(name: 'skin_tone_rgb') List<int>? skinToneRgb,
      @JsonKey(name: 'skin_tone_lab') List<double>? skinToneLab,
      @JsonKey(name: 'best_colors') List<String>? bestColors,
      @JsonKey(name: 'worst_colors') List<String>? worstColors,
      @JsonKey(name: 'detected_skin_type') String? detectedSkinType,
      @JsonKey(name: 'skin_type_description') String? skinTypeDescription,
      @JsonKey(name: 'sensitivity') Sensitivity? sensitivity,
      @Deprecated('Use sensitivity.sensitivityScore instead')
      @JsonKey(name: 'sensitivity_score')
      double? sensitivityScore,
      @Deprecated('Use sensitivity.level instead')
      @JsonKey(name: 'sensitivity_level')
      String? sensitivityLevel,
      @Deprecated('Use sensitivity.riskFactors instead')
      @JsonKey(name: 'risk_factors')
      List<String>? riskFactors,
      @JsonKey(name: 'pore_score') int? poreScore,
      @JsonKey(name: 'pore_description') String? poreDescription,
      @JsonKey(name: 'wrinkle_score') int? wrinkleScore,
      @JsonKey(name: 'wrinkle_description') String? wrinkleDescription,
      @JsonKey(name: 'elasticity_score') int? elasticityScore,
      @JsonKey(name: 'elasticity_description') String? elasticityDescription,
      @JsonKey(name: 'acne_score') int? acneScore,
      @JsonKey(name: 'acne_description') String? acneDescription,
      @JsonKey(name: 'pigmentation_score') int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      String? pigmentationDescription,
      @JsonKey(name: 'redness_score') int? rednessScore,
      @JsonKey(name: 'redness_description') String? rednessDescription,
      @JsonKey(name: 'skincare_routine') List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') bool? faceDetected,
      @JsonKey(name: 'face_quality_score') double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data') Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'ai_analysis') AiAnalysis? aiAnalysis,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  @override
  $SensitivityCopyWith<$Res>? get sensitivity;
  @override
  $AiAnalysisCopyWith<$Res>? get aiAnalysis;
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
    Object? personalColor = freezed,
    Object? personalColorConfidence = freezed,
    Object? personalColorDescription = freezed,
    Object? undertone = freezed,
    Object? undertoneConfidence = freezed,
    Object? skinToneRgb = freezed,
    Object? skinToneLab = freezed,
    Object? bestColors = freezed,
    Object? worstColors = freezed,
    Object? detectedSkinType = freezed,
    Object? skinTypeDescription = freezed,
    Object? sensitivity = freezed,
    Object? sensitivityScore = freezed,
    Object? sensitivityLevel = freezed,
    Object? riskFactors = freezed,
    Object? poreScore = freezed,
    Object? poreDescription = freezed,
    Object? wrinkleScore = freezed,
    Object? wrinkleDescription = freezed,
    Object? elasticityScore = freezed,
    Object? elasticityDescription = freezed,
    Object? acneScore = freezed,
    Object? acneDescription = freezed,
    Object? pigmentationScore = freezed,
    Object? pigmentationDescription = freezed,
    Object? rednessScore = freezed,
    Object? rednessDescription = freezed,
    Object? skincareRoutine = freezed,
    Object? faceDetected = freezed,
    Object? faceQualityScore = freezed,
    Object? rawAnalysisData = freezed,
    Object? aiAnalysis = freezed,
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
      personalColor: freezed == personalColor
          ? _value.personalColor
          : personalColor // ignore: cast_nullable_to_non_nullable
              as String?,
      personalColorConfidence: freezed == personalColorConfidence
          ? _value.personalColorConfidence
          : personalColorConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      personalColorDescription: freezed == personalColorDescription
          ? _value.personalColorDescription
          : personalColorDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      undertone: freezed == undertone
          ? _value.undertone
          : undertone // ignore: cast_nullable_to_non_nullable
              as String?,
      undertoneConfidence: freezed == undertoneConfidence
          ? _value.undertoneConfidence
          : undertoneConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      skinToneRgb: freezed == skinToneRgb
          ? _value._skinToneRgb
          : skinToneRgb // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      skinToneLab: freezed == skinToneLab
          ? _value._skinToneLab
          : skinToneLab // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      bestColors: freezed == bestColors
          ? _value._bestColors
          : bestColors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      worstColors: freezed == worstColors
          ? _value._worstColors
          : worstColors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      detectedSkinType: freezed == detectedSkinType
          ? _value.detectedSkinType
          : detectedSkinType // ignore: cast_nullable_to_non_nullable
              as String?,
      skinTypeDescription: freezed == skinTypeDescription
          ? _value.skinTypeDescription
          : skinTypeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      sensitivity: freezed == sensitivity
          ? _value.sensitivity
          : sensitivity // ignore: cast_nullable_to_non_nullable
              as Sensitivity?,
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
      poreScore: freezed == poreScore
          ? _value.poreScore
          : poreScore // ignore: cast_nullable_to_non_nullable
              as int?,
      poreDescription: freezed == poreDescription
          ? _value.poreDescription
          : poreDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      wrinkleScore: freezed == wrinkleScore
          ? _value.wrinkleScore
          : wrinkleScore // ignore: cast_nullable_to_non_nullable
              as int?,
      wrinkleDescription: freezed == wrinkleDescription
          ? _value.wrinkleDescription
          : wrinkleDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      elasticityScore: freezed == elasticityScore
          ? _value.elasticityScore
          : elasticityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      elasticityDescription: freezed == elasticityDescription
          ? _value.elasticityDescription
          : elasticityDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      acneScore: freezed == acneScore
          ? _value.acneScore
          : acneScore // ignore: cast_nullable_to_non_nullable
              as int?,
      acneDescription: freezed == acneDescription
          ? _value.acneDescription
          : acneDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      pigmentationScore: freezed == pigmentationScore
          ? _value.pigmentationScore
          : pigmentationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      pigmentationDescription: freezed == pigmentationDescription
          ? _value.pigmentationDescription
          : pigmentationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      rednessScore: freezed == rednessScore
          ? _value.rednessScore
          : rednessScore // ignore: cast_nullable_to_non_nullable
              as int?,
      rednessDescription: freezed == rednessDescription
          ? _value.rednessDescription
          : rednessDescription // ignore: cast_nullable_to_non_nullable
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
      aiAnalysis: freezed == aiAnalysis
          ? _value.aiAnalysis
          : aiAnalysis // ignore: cast_nullable_to_non_nullable
              as AiAnalysis?,
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
      @JsonKey(name: 'personal_color') this.personalColor,
      @JsonKey(name: 'personal_color_confidence') this.personalColorConfidence,
      @JsonKey(name: 'personal_color_description')
      this.personalColorDescription,
      @JsonKey(name: 'undertone') this.undertone,
      @JsonKey(name: 'undertone_confidence') this.undertoneConfidence,
      @JsonKey(name: 'skin_tone_rgb') final List<int>? skinToneRgb,
      @JsonKey(name: 'skin_tone_lab') final List<double>? skinToneLab,
      @JsonKey(name: 'best_colors') final List<String>? bestColors,
      @JsonKey(name: 'worst_colors') final List<String>? worstColors,
      @JsonKey(name: 'detected_skin_type') this.detectedSkinType,
      @JsonKey(name: 'skin_type_description') this.skinTypeDescription,
      @JsonKey(name: 'sensitivity') this.sensitivity,
      @Deprecated('Use sensitivity.sensitivityScore instead')
      @JsonKey(name: 'sensitivity_score')
      this.sensitivityScore,
      @Deprecated('Use sensitivity.level instead')
      @JsonKey(name: 'sensitivity_level')
      this.sensitivityLevel,
      @Deprecated('Use sensitivity.riskFactors instead')
      @JsonKey(name: 'risk_factors')
      final List<String>? riskFactors,
      @JsonKey(name: 'pore_score') this.poreScore,
      @JsonKey(name: 'pore_description') this.poreDescription,
      @JsonKey(name: 'wrinkle_score') this.wrinkleScore,
      @JsonKey(name: 'wrinkle_description') this.wrinkleDescription,
      @JsonKey(name: 'elasticity_score') this.elasticityScore,
      @JsonKey(name: 'elasticity_description') this.elasticityDescription,
      @JsonKey(name: 'acne_score') this.acneScore,
      @JsonKey(name: 'acne_description') this.acneDescription,
      @JsonKey(name: 'pigmentation_score') this.pigmentationScore,
      @JsonKey(name: 'pigmentation_description') this.pigmentationDescription,
      @JsonKey(name: 'redness_score') this.rednessScore,
      @JsonKey(name: 'redness_description') this.rednessDescription,
      @JsonKey(name: 'skincare_routine')
      final List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') this.faceDetected,
      @JsonKey(name: 'face_quality_score') this.faceQualityScore,
      @JsonKey(name: 'raw_analysis_data')
      final Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'ai_analysis') this.aiAnalysis,
      @JsonKey(name: 'created_at') this.createdAt})
      : _skinToneRgb = skinToneRgb,
        _skinToneLab = skinToneLab,
        _bestColors = bestColors,
        _worstColors = worstColors,
        _riskFactors = riskFactors,
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
// === 퍼스널 컬러 ===
  @override
  @JsonKey(name: 'personal_color')
  final String? personalColor;
  @override
  @JsonKey(name: 'personal_color_confidence')
  final double? personalColorConfidence;
  @override
  @JsonKey(name: 'personal_color_description')
  final String? personalColorDescription;
  @override
  @JsonKey(name: 'undertone')
  final String? undertone;
  @override
  @JsonKey(name: 'undertone_confidence')
  final double? undertoneConfidence;
  final List<int>? _skinToneRgb;
  @override
  @JsonKey(name: 'skin_tone_rgb')
  List<int>? get skinToneRgb {
    final value = _skinToneRgb;
    if (value == null) return null;
    if (_skinToneRgb is EqualUnmodifiableListView) return _skinToneRgb;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<double>? _skinToneLab;
  @override
  @JsonKey(name: 'skin_tone_lab')
  List<double>? get skinToneLab {
    final value = _skinToneLab;
    if (value == null) return null;
    if (_skinToneLab is EqualUnmodifiableListView) return _skinToneLab;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 인생 컬러 팔레트
  final List<String>? _bestColors;
// 인생 컬러 팔레트
  @override
  @JsonKey(name: 'best_colors')
  List<String>? get bestColors {
    final value = _bestColors;
    if (value == null) return null;
    if (_bestColors is EqualUnmodifiableListView) return _bestColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _worstColors;
  @override
  @JsonKey(name: 'worst_colors')
  List<String>? get worstColors {
    final value = _worstColors;
    if (value == null) return null;
    if (_worstColors is EqualUnmodifiableListView) return _worstColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// === 피부 타입 ===
  @override
  @JsonKey(name: 'detected_skin_type')
  final String? detectedSkinType;
  @override
  @JsonKey(name: 'skin_type_description')
  final String? skinTypeDescription;
// === 민감성 (⭐ 타입 변경: String? → Sensitivity?) ===
  @override
  @JsonKey(name: 'sensitivity')
  final Sensitivity? sensitivity;
// 하위 호환성을 위해 남겨둠 (Deprecated)
  @override
  @Deprecated('Use sensitivity.sensitivityScore instead')
  @JsonKey(name: 'sensitivity_score')
  final double? sensitivityScore;
  @override
  @Deprecated('Use sensitivity.level instead')
  @JsonKey(name: 'sensitivity_level')
  final String? sensitivityLevel;
  final List<String>? _riskFactors;
  @override
  @Deprecated('Use sensitivity.riskFactors instead')
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors {
    final value = _riskFactors;
    if (value == null) return null;
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// === 상세 지표 ===
  @override
  @JsonKey(name: 'pore_score')
  final int? poreScore;
  @override
  @JsonKey(name: 'pore_description')
  final String? poreDescription;
  @override
  @JsonKey(name: 'wrinkle_score')
  final int? wrinkleScore;
  @override
  @JsonKey(name: 'wrinkle_description')
  final String? wrinkleDescription;
  @override
  @JsonKey(name: 'elasticity_score')
  final int? elasticityScore;
  @override
  @JsonKey(name: 'elasticity_description')
  final String? elasticityDescription;
  @override
  @JsonKey(name: 'acne_score')
  final int? acneScore;
  @override
  @JsonKey(name: 'acne_description')
  final String? acneDescription;
  @override
  @JsonKey(name: 'pigmentation_score')
  final int? pigmentationScore;
  @override
  @JsonKey(name: 'pigmentation_description')
  final String? pigmentationDescription;
  @override
  @JsonKey(name: 'redness_score')
  final int? rednessScore;
  @override
  @JsonKey(name: 'redness_description')
  final String? rednessDescription;
// === 루틴 ===
  final List<SkincareStep>? _skincareRoutine;
// === 루틴 ===
  @override
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine {
    final value = _skincareRoutine;
    if (value == null) return null;
    if (_skincareRoutine is EqualUnmodifiableListView) return _skincareRoutine;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// === 얼굴 인식 ===
  @override
  @JsonKey(name: 'face_detected')
  final bool? faceDetected;
  @override
  @JsonKey(name: 'face_quality_score')
  final double? faceQualityScore;
// === 원본 데이터 ===
  final Map<String, dynamic>? _rawAnalysisData;
// === 원본 데이터 ===
  @override
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData {
    final value = _rawAnalysisData;
    if (value == null) return null;
    if (_rawAnalysisData is EqualUnmodifiableMapView) return _rawAnalysisData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// === GPT 결과 ===
  @override
  @JsonKey(name: 'ai_analysis')
  final AiAnalysis? aiAnalysis;
// === 타임스탬프 ===
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AnalysisResult(id: $id, userId: $userId, imageId: $imageId, personalColor: $personalColor, personalColorConfidence: $personalColorConfidence, personalColorDescription: $personalColorDescription, undertone: $undertone, undertoneConfidence: $undertoneConfidence, skinToneRgb: $skinToneRgb, skinToneLab: $skinToneLab, bestColors: $bestColors, worstColors: $worstColors, detectedSkinType: $detectedSkinType, skinTypeDescription: $skinTypeDescription, sensitivity: $sensitivity, sensitivityScore: $sensitivityScore, sensitivityLevel: $sensitivityLevel, riskFactors: $riskFactors, poreScore: $poreScore, poreDescription: $poreDescription, wrinkleScore: $wrinkleScore, wrinkleDescription: $wrinkleDescription, elasticityScore: $elasticityScore, elasticityDescription: $elasticityDescription, acneScore: $acneScore, acneDescription: $acneDescription, pigmentationScore: $pigmentationScore, pigmentationDescription: $pigmentationDescription, rednessScore: $rednessScore, rednessDescription: $rednessDescription, skincareRoutine: $skincareRoutine, faceDetected: $faceDetected, faceQualityScore: $faceQualityScore, rawAnalysisData: $rawAnalysisData, aiAnalysis: $aiAnalysis, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.personalColor, personalColor) ||
                other.personalColor == personalColor) &&
            (identical(other.personalColorConfidence, personalColorConfidence) ||
                other.personalColorConfidence == personalColorConfidence) &&
            (identical(other.personalColorDescription, personalColorDescription) ||
                other.personalColorDescription == personalColorDescription) &&
            (identical(other.undertone, undertone) ||
                other.undertone == undertone) &&
            (identical(other.undertoneConfidence, undertoneConfidence) ||
                other.undertoneConfidence == undertoneConfidence) &&
            const DeepCollectionEquality()
                .equals(other._skinToneRgb, _skinToneRgb) &&
            const DeepCollectionEquality()
                .equals(other._skinToneLab, _skinToneLab) &&
            const DeepCollectionEquality()
                .equals(other._bestColors, _bestColors) &&
            const DeepCollectionEquality()
                .equals(other._worstColors, _worstColors) &&
            (identical(other.detectedSkinType, detectedSkinType) ||
                other.detectedSkinType == detectedSkinType) &&
            (identical(other.skinTypeDescription, skinTypeDescription) ||
                other.skinTypeDescription == skinTypeDescription) &&
            (identical(other.sensitivity, sensitivity) ||
                other.sensitivity == sensitivity) &&
            (identical(other.sensitivityScore, sensitivityScore) ||
                other.sensitivityScore == sensitivityScore) &&
            (identical(other.sensitivityLevel, sensitivityLevel) ||
                other.sensitivityLevel == sensitivityLevel) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors) &&
            (identical(other.poreScore, poreScore) ||
                other.poreScore == poreScore) &&
            (identical(other.poreDescription, poreDescription) ||
                other.poreDescription == poreDescription) &&
            (identical(other.wrinkleScore, wrinkleScore) ||
                other.wrinkleScore == wrinkleScore) &&
            (identical(other.wrinkleDescription, wrinkleDescription) ||
                other.wrinkleDescription == wrinkleDescription) &&
            (identical(other.elasticityScore, elasticityScore) ||
                other.elasticityScore == elasticityScore) &&
            (identical(other.elasticityDescription, elasticityDescription) ||
                other.elasticityDescription == elasticityDescription) &&
            (identical(other.acneScore, acneScore) ||
                other.acneScore == acneScore) &&
            (identical(other.acneDescription, acneDescription) ||
                other.acneDescription == acneDescription) &&
            (identical(other.pigmentationScore, pigmentationScore) ||
                other.pigmentationScore == pigmentationScore) &&
            (identical(other.pigmentationDescription, pigmentationDescription) ||
                other.pigmentationDescription == pigmentationDescription) &&
            (identical(other.rednessScore, rednessScore) || other.rednessScore == rednessScore) &&
            (identical(other.rednessDescription, rednessDescription) || other.rednessDescription == rednessDescription) &&
            const DeepCollectionEquality().equals(other._skincareRoutine, _skincareRoutine) &&
            (identical(other.faceDetected, faceDetected) || other.faceDetected == faceDetected) &&
            (identical(other.faceQualityScore, faceQualityScore) || other.faceQualityScore == faceQualityScore) &&
            const DeepCollectionEquality().equals(other._rawAnalysisData, _rawAnalysisData) &&
            (identical(other.aiAnalysis, aiAnalysis) || other.aiAnalysis == aiAnalysis) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        imageId,
        personalColor,
        personalColorConfidence,
        personalColorDescription,
        undertone,
        undertoneConfidence,
        const DeepCollectionEquality().hash(_skinToneRgb),
        const DeepCollectionEquality().hash(_skinToneLab),
        const DeepCollectionEquality().hash(_bestColors),
        const DeepCollectionEquality().hash(_worstColors),
        detectedSkinType,
        skinTypeDescription,
        sensitivity,
        sensitivityScore,
        sensitivityLevel,
        const DeepCollectionEquality().hash(_riskFactors),
        poreScore,
        poreDescription,
        wrinkleScore,
        wrinkleDescription,
        elasticityScore,
        elasticityDescription,
        acneScore,
        acneDescription,
        pigmentationScore,
        pigmentationDescription,
        rednessScore,
        rednessDescription,
        const DeepCollectionEquality().hash(_skincareRoutine),
        faceDetected,
        faceQualityScore,
        const DeepCollectionEquality().hash(_rawAnalysisData),
        aiAnalysis,
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
      @JsonKey(name: 'personal_color') final String? personalColor,
      @JsonKey(name: 'personal_color_confidence')
      final double? personalColorConfidence,
      @JsonKey(name: 'personal_color_description')
      final String? personalColorDescription,
      @JsonKey(name: 'undertone') final String? undertone,
      @JsonKey(name: 'undertone_confidence') final double? undertoneConfidence,
      @JsonKey(name: 'skin_tone_rgb') final List<int>? skinToneRgb,
      @JsonKey(name: 'skin_tone_lab') final List<double>? skinToneLab,
      @JsonKey(name: 'best_colors') final List<String>? bestColors,
      @JsonKey(name: 'worst_colors') final List<String>? worstColors,
      @JsonKey(name: 'detected_skin_type') final String? detectedSkinType,
      @JsonKey(name: 'skin_type_description') final String? skinTypeDescription,
      @JsonKey(name: 'sensitivity') final Sensitivity? sensitivity,
      @Deprecated('Use sensitivity.sensitivityScore instead')
      @JsonKey(name: 'sensitivity_score')
      final double? sensitivityScore,
      @Deprecated('Use sensitivity.level instead')
      @JsonKey(name: 'sensitivity_level')
      final String? sensitivityLevel,
      @Deprecated('Use sensitivity.riskFactors instead')
      @JsonKey(name: 'risk_factors')
      final List<String>? riskFactors,
      @JsonKey(name: 'pore_score') final int? poreScore,
      @JsonKey(name: 'pore_description') final String? poreDescription,
      @JsonKey(name: 'wrinkle_score') final int? wrinkleScore,
      @JsonKey(name: 'wrinkle_description') final String? wrinkleDescription,
      @JsonKey(name: 'elasticity_score') final int? elasticityScore,
      @JsonKey(name: 'elasticity_description')
      final String? elasticityDescription,
      @JsonKey(name: 'acne_score') final int? acneScore,
      @JsonKey(name: 'acne_description') final String? acneDescription,
      @JsonKey(name: 'pigmentation_score') final int? pigmentationScore,
      @JsonKey(name: 'pigmentation_description')
      final String? pigmentationDescription,
      @JsonKey(name: 'redness_score') final int? rednessScore,
      @JsonKey(name: 'redness_description') final String? rednessDescription,
      @JsonKey(name: 'skincare_routine')
      final List<SkincareStep>? skincareRoutine,
      @JsonKey(name: 'face_detected') final bool? faceDetected,
      @JsonKey(name: 'face_quality_score') final double? faceQualityScore,
      @JsonKey(name: 'raw_analysis_data')
      final Map<String, dynamic>? rawAnalysisData,
      @JsonKey(name: 'ai_analysis') final AiAnalysis? aiAnalysis,
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
  String get imageId; // === 퍼스널 컬러 ===
  @override
  @JsonKey(name: 'personal_color')
  String? get personalColor;
  @override
  @JsonKey(name: 'personal_color_confidence')
  double? get personalColorConfidence;
  @override
  @JsonKey(name: 'personal_color_description')
  String? get personalColorDescription;
  @override
  @JsonKey(name: 'undertone')
  String? get undertone;
  @override
  @JsonKey(name: 'undertone_confidence')
  double? get undertoneConfidence;
  @override
  @JsonKey(name: 'skin_tone_rgb')
  List<int>? get skinToneRgb;
  @override
  @JsonKey(name: 'skin_tone_lab')
  List<double>? get skinToneLab; // 인생 컬러 팔레트
  @override
  @JsonKey(name: 'best_colors')
  List<String>? get bestColors;
  @override
  @JsonKey(name: 'worst_colors')
  List<String>? get worstColors; // === 피부 타입 ===
  @override
  @JsonKey(name: 'detected_skin_type')
  String? get detectedSkinType;
  @override
  @JsonKey(name: 'skin_type_description')
  String?
      get skinTypeDescription; // === 민감성 (⭐ 타입 변경: String? → Sensitivity?) ===
  @override
  @JsonKey(name: 'sensitivity')
  Sensitivity? get sensitivity; // 하위 호환성을 위해 남겨둠 (Deprecated)
  @override
  @Deprecated('Use sensitivity.sensitivityScore instead')
  @JsonKey(name: 'sensitivity_score')
  double? get sensitivityScore;
  @override
  @Deprecated('Use sensitivity.level instead')
  @JsonKey(name: 'sensitivity_level')
  String? get sensitivityLevel;
  @override
  @Deprecated('Use sensitivity.riskFactors instead')
  @JsonKey(name: 'risk_factors')
  List<String>? get riskFactors; // === 상세 지표 ===
  @override
  @JsonKey(name: 'pore_score')
  int? get poreScore;
  @override
  @JsonKey(name: 'pore_description')
  String? get poreDescription;
  @override
  @JsonKey(name: 'wrinkle_score')
  int? get wrinkleScore;
  @override
  @JsonKey(name: 'wrinkle_description')
  String? get wrinkleDescription;
  @override
  @JsonKey(name: 'elasticity_score')
  int? get elasticityScore;
  @override
  @JsonKey(name: 'elasticity_description')
  String? get elasticityDescription;
  @override
  @JsonKey(name: 'acne_score')
  int? get acneScore;
  @override
  @JsonKey(name: 'acne_description')
  String? get acneDescription;
  @override
  @JsonKey(name: 'pigmentation_score')
  int? get pigmentationScore;
  @override
  @JsonKey(name: 'pigmentation_description')
  String? get pigmentationDescription;
  @override
  @JsonKey(name: 'redness_score')
  int? get rednessScore;
  @override
  @JsonKey(name: 'redness_description')
  String? get rednessDescription; // === 루틴 ===
  @override
  @JsonKey(name: 'skincare_routine')
  List<SkincareStep>? get skincareRoutine; // === 얼굴 인식 ===
  @override
  @JsonKey(name: 'face_detected')
  bool? get faceDetected;
  @override
  @JsonKey(name: 'face_quality_score')
  double? get faceQualityScore; // === 원본 데이터 ===
  @override
  @JsonKey(name: 'raw_analysis_data')
  Map<String, dynamic>? get rawAnalysisData; // === GPT 결과 ===
  @override
  @JsonKey(name: 'ai_analysis')
  AiAnalysis? get aiAnalysis; // === 타임스탬프 ===
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
