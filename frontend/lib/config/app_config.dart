// lib/config/app_config.dart

/// 앱 환경 설정
class AppConfig {
  // 개발 모드 활성화 (배포 시 false로 변경)
  static const bool isDevelopmentMode = true;
  
  // 개발 모드 테스트 사용자
  static const Map<String, String> testUser = {
    'sub': 'test-user-001',
    'email': 'test@example.com',
    'name': '테스트 사용자',
    'picture': 'https://via.placeholder.com/150',
  };
  
  // Mock JWT 토큰 (개발용)
  static const String mockJwtToken = 'dev-mock-token-12345';
  
  // 백엔드 URL
  static const String backendUrl = 'https://backend-6xc5.onrender.com';
  
  // 개발 모드 표시 여부
  static bool get showDevBadge => isDevelopmentMode;
}