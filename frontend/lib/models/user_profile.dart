// lib/models/user_profile.dart
// 데이터베이스 'profiles' 테이블 모델
// 화면 5: 프로필 설정, 화면 8: 마이페이지, 화면 11: 개인정보 수정
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id, // auth.users.id와 연결

    // 소셜 로그인 기본 정보
    String? email,
    required String name, // 화면 5: 이름 입력
    @JsonKey(name: 'avatar_url') String? avatarUrl, // 화면 8: 프로필 이미지
    String? provider, // google, apple

    // 화면 5: 프로필 설정에서 입력받는 정보
    @JsonKey(name: 'birth_year') int? birthYear, // 생년월일 (년도만)
    @JsonKey(name: 'skin_type')
    
    String? skinType, // normal, oily, dry, combination, sensitive

    // 프로필 완성 여부
    @JsonKey(name: 'profile_completed') bool? profileCompleted,

    // 타임스탬프
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<String>? allergies,           
    @JsonKey(name: 'skin_concerns') 
    List<String>? skinConcerns,
    }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

// 피부 타입 상수 및 유틸리티
class SkinTypeConstants {
  static const String normal = 'normal';
  static const String oily = 'oily';
  static const String dry = 'dry';
  static const String combination = 'combination';
  static const String sensitive = 'sensitive';

  // 한글명
  static String toKorean(String type) {
    switch (type) {
      case normal:
        return '중성';
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

  // 버튼 이미지 경로 (화면 5, 11: 프로필 설정/수정)
  // isSelected: true면 청록색, false면 회색
  static String getButtonImage(String type, {required bool isSelected}) {
    final prefix = isSelected ? 'selected' : 'gray';
    switch (type) {
      case normal:
        return 'assets/5and11/${prefix}_joongs.png';
      case oily:
        return 'assets/5and11/${prefix}_jis.png';
      case dry:
        return 'assets/5and11/${prefix}_guns.png';
      case combination:
        return 'assets/5and11/${prefix}_bok.png';
      case sensitive:
        return 'assets/5and11/${prefix}_min.png';
      default:
        return 'assets/5and11/${prefix}_joongs.png';
    }
  }

  // 모든 피부 타입 리스트
  static List<String> get allTypes => [
        dry, // 건성
        normal, // 중성
        oily, // 지성
        combination, // 복합성
        sensitive, // 민감성
      ];
}

// 프로필 유효성 검증
extension UserProfileValidation on UserProfile {
  // 프로필이 완성되었는지 확인
  bool get isProfileComplete {
    return name.isNotEmpty && birthYear != null && skinType != null;
  }

  // 나이 계산 (현재 년도 - 생년)
  int? get age {
    if (birthYear == null) return null;
    return DateTime.now().year - birthYear!;
  }

  // 화면 8: 마이페이지 표시용 이름
  String get displayName {
    return name.isEmpty ? '사용자' : name;
  }
}
