// lib/config/app_config.dart

/// 앱 환경 설정
class AppConfig {
  // 백엔드 URL
  static const String backendUrl = 'https://beautyfinder-l2pt.onrender.com';
  

class ApiConfig {
  static const baseUrl = 'https://beautyfinder-l2pt.onrender.com';
  
  // 인증
  static const loginUrl = '$baseUrl/login';
  
  // 분석 API
  static const analysisUrl = '$baseUrl/api/v1/analysis/comprehensive';
  static const historyUrl = '$baseUrl/api/v1/analysis/history';
}