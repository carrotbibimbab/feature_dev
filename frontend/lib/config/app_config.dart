// lib/config/app_config.dart

/// 앱 환경 설정
class AppConfig {
  // 개발 모드 활성화 (배포 시 false로 변경)
  static const bool isDevelopmentMode = false;
  
  // 개발 모드 테스트 사용자
  static const Map<String, String> testUser = {
    'sub': '00000000-0000-0000-0000-000000000001',
    'email': 'demo@vupa.ai',
    'name': '테스트 사용자',
    'picture': 'https://via.placeholder.com/150',
  };
  
  // Mock JWT 토큰 (개발용)
  static const String mockJwtToken = 'dev-mock-token-12345';
  
  // 백엔드 URL
  static const String backendUrl = 'https://beautyfinder-l2pt.onrender.com';
  
  // 개발 모드 표시 여부
  static bool get showDevBadge => isDevelopmentMode;
}

class ApiConfig {
  static const baseUrl = 'https://beautyfinder-l2pt.onrender.com';
  
  // 인증
  static const loginUrl = '$baseUrl/login';
  
  // 분석 API
  static const analysisUrl = '$baseUrl/api/v1/analysis/comprehensive';
  static const historyUrl = '$baseUrl/api/v1/analysis/history';
}