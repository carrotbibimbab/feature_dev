import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // 폰트 패밀리 정의
  static const String nanum = 'NanumSquareNeo';
  static const String crimson = 'CrimsonText';

  // Heading 스타일 (제목용)
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: nanum,
    color: AppColors.black,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.black,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.black,
    height: 1.3,
  );

  // Body 스타일 (본문용)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.black,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.black,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.grey,
    height: 1.4,
  );

  // 버튼 텍스트
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: nanum,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  // 캡션 및 라벨
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.grey,
    height: 1.3,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: nanum,
    color: AppColors.darkGrey,
    letterSpacing: 0.5,
  );

  // 특수 스타일 (로고, 스플래시 등)
  static const TextStyle logo = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontFamily: crimson,
    color: AppColors.logoRed,
    letterSpacing: 2,
  );

  static const TextStyle splashTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: crimson,
    color: AppColors.white,
    fontStyle: FontStyle.italic,
  );

  // 온보딩 스타일
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: nanum,
    color: AppColors.black,
  );

  static const TextStyle onboardingBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.darkGrey,
    height: 1.5,
  );

  // 분석 결과 스타일
  static const TextStyle analysisTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.primary,
  );

  static const TextStyle analysisResult = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: nanum,
    color: AppColors.black,
  );

  // 카드 스타일
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.black,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: nanum,
    color: AppColors.grey,
  );

  // 제품 정보 스타일
  static const TextStyle productBrand = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: nanum,
    color: AppColors.darkGrey,
  );

  static const TextStyle productName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: nanum,
    color: AppColors.black,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: nanum,
    color: AppColors.logoRed,
  );

  // 헬퍼 메소드 - 동적 스타일 생성용
  static TextStyle customStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.black,
    String fontFamily = nanum,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
    );
  }
}
