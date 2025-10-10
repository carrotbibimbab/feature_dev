import 'package:flutter/material.dart';

class AppColors {
  // 메인 컬러
  static const Color primary = Color(0xFFE8B7D4); // 메인 핑크
  static const Color logoRed = Color(0xFFC6091D); // BF 로고 색상

  // 기본 색상
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  // 추가 색상 (필요시 사용)
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;

  // 피부 타입 색상 (선택적)
  static const Color drySkin = Color(0xFFFFE5CC);
  static const Color oilySkin = Color(0xFFD4E8FF);
  static const Color combinationSkin = Color(0xFFE8FFD4);
  static const Color sensitiveSkin = Color(0xFFFFD4D4);

  // 그라데이션 (스플래시 화면용)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8B7D4),
      Color(0xFFF0D0E0),
    ],
  );
}
