// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError; // auth.users.id와 연결
// 소셜 로그인 기본 정보
  String? get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError; // 화면 5: 이름 입력
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError; // 화면 8: 프로필 이미지
  String? get provider => throw _privateConstructorUsedError; // google, apple
// 화면 5: 프로필 설정에서 입력받는 정보
  @JsonKey(name: 'birth_year')
  int? get birthYear => throw _privateConstructorUsedError; // 생년월일 (년도만)
  @JsonKey(name: 'skin_type')
  String? get skinType =>
      throw _privateConstructorUsedError; // normal, oily, dry, combination, sensitive
// 프로필 완성 여부
  @JsonKey(name: 'profile_completed')
  bool? get profileCompleted => throw _privateConstructorUsedError; // 타임스탬프
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String? email,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? provider,
      @JsonKey(name: 'birth_year') int? birthYear,
      @JsonKey(name: 'skin_type') String? skinType,
      @JsonKey(name: 'profile_completed') bool? profileCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? provider = freezed,
    Object? birthYear = freezed,
    Object? skinType = freezed,
    Object? profileCompleted = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      birthYear: freezed == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int?,
      skinType: freezed == skinType
          ? _value.skinType
          : skinType // ignore: cast_nullable_to_non_nullable
              as String?,
      profileCompleted: freezed == profileCompleted
          ? _value.profileCompleted
          : profileCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? email,
      String name,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? provider,
      @JsonKey(name: 'birth_year') int? birthYear,
      @JsonKey(name: 'skin_type') String? skinType,
      @JsonKey(name: 'profile_completed') bool? profileCompleted,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? provider = freezed,
    Object? birthYear = freezed,
    Object? skinType = freezed,
    Object? profileCompleted = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      birthYear: freezed == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int?,
      skinType: freezed == skinType
          ? _value.skinType
          : skinType // ignore: cast_nullable_to_non_nullable
              as String?,
      profileCompleted: freezed == profileCompleted
          ? _value.profileCompleted
          : profileCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      this.email,
      required this.name,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.provider,
      @JsonKey(name: 'birth_year') this.birthYear,
      @JsonKey(name: 'skin_type') this.skinType,
      @JsonKey(name: 'profile_completed') this.profileCompleted,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
// auth.users.id와 연결
// 소셜 로그인 기본 정보
  @override
  final String? email;
  @override
  final String name;
// 화면 5: 이름 입력
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
// 화면 8: 프로필 이미지
  @override
  final String? provider;
// google, apple
// 화면 5: 프로필 설정에서 입력받는 정보
  @override
  @JsonKey(name: 'birth_year')
  final int? birthYear;
// 생년월일 (년도만)
  @override
  @JsonKey(name: 'skin_type')
  final String? skinType;
// normal, oily, dry, combination, sensitive
// 프로필 완성 여부
  @override
  @JsonKey(name: 'profile_completed')
  final bool? profileCompleted;
// 타임스탬프
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, provider: $provider, birthYear: $birthYear, skinType: $skinType, profileCompleted: $profileCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear) &&
            (identical(other.skinType, skinType) ||
                other.skinType == skinType) &&
            (identical(other.profileCompleted, profileCompleted) ||
                other.profileCompleted == profileCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, name, avatarUrl,
      provider, birthYear, skinType, profileCompleted, createdAt, updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
          {required final String id,
          final String? email,
          required final String name,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          final String? provider,
          @JsonKey(name: 'birth_year') final int? birthYear,
          @JsonKey(name: 'skin_type') final String? skinType,
          @JsonKey(name: 'profile_completed') final bool? profileCompleted,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id; // auth.users.id와 연결
// 소셜 로그인 기본 정보
  @override
  String? get email;
  @override
  String get name; // 화면 5: 이름 입력
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl; // 화면 8: 프로필 이미지
  @override
  String? get provider; // google, apple
// 화면 5: 프로필 설정에서 입력받는 정보
  @override
  @JsonKey(name: 'birth_year')
  int? get birthYear; // 생년월일 (년도만)
  @override
  @JsonKey(name: 'skin_type')
  String? get skinType; // normal, oily, dry, combination, sensitive
// 프로필 완성 여부
  @override
  @JsonKey(name: 'profile_completed')
  bool? get profileCompleted; // 타임스탬프
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
