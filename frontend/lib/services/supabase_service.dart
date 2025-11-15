//lib\services\supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  

class SupabaseConfig {
  // Supabase 프로젝트 설정
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_KEY'] ?? '';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    print('✅ Supabase 초기화 완료');
  }

  // ⭐ client getter만 남김
  static SupabaseClient get client => Supabase.instance.client;
  

  // 현재 사용자 가져오기
  static User? get currentUser => client.auth.currentUser;

  // 현재 세션 가져오기
  static Session? get currentSession => client.auth.currentSession;

  // 인증 상태 스트림
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  static Future<String?> getCurrentUserId() async {
    // 1. Supabase 사용자 확인
    final supabaseUser = client.auth.currentUser;
    if (supabaseUser != null) {
      return supabaseUser.id;
    }
  }
}

// Storage 버킷 이름 (간소화)
class StorageBuckets {
  // 사용자 프로필 이미지 (화면 8: 마이페이지)
  static const String profileImages = 'profile-images';

  // AI 분석용 업로드 이미지 (화면 12-16)
  static const String userUploads = 'user-uploads';
}

// 테이블 이름 (현재 앱 구조에 맞춤)
class Tables {
  // 사용자 프로필 (화면 5, 8, 11)
  static const String profiles = 'profiles';

  // 업로드된 이미지 (화면 13-14)
  static const String uploadedImages = 'uploaded_images';

  // AI 분석 결과 (화면 16)
  static const String analyses = 'analyses';

  // 사용자 활동 로그 (선택적 - 운영 분석용)
  static const String userActivities = 'user_activities';

  // ❌ 제거된 테이블들 (현재 앱에서 사용 안 함)
  // static const String beautyGuides = 'beauty_guides';
  // static const String products = 'products';
  // static const String wishlists = 'wishlists';
  // static const String dailyCheckins = 'daily_checkins';
  // static const String notifications = 'notifications';
}

// 활동 로그 타입 (선별적으로 기록할 이벤트)
class ActivityType {
  static const String login = 'login';
  static const String profileCompleted = 'profile_completed';
  static const String analysisStarted = 'analysis_started';
  static const String analysisCompleted = 'analysis_completed';
  static const String analysisFailed = 'analysis_failed';
  static const String resultViewed = 'result_viewed';
  static const String resultShared = 'result_shared';
  static const String communityVisited = 'community_visited';
  static const String chatbotUsed = 'chatbot_used';
}

// RPC 함수 이름 (화면 7, 9에서 사용)
class RpcFunctions {
  // 최근 분석 결과 가져오기 (화면 7: 나의 최근 피부 분석 결과)
  static const String getLatestAnalysis = 'get_latest_analysis';

  // 분석 로그 목록 가져오기 (화면 9: 나의 분석 로그)
  static const String getAnalysisLogs = 'get_analysis_logs';
}

// 뷰(View) 이름
class Views {
  // 사용자 대시보드 요약 (화면 7: 메인 대시보드)
  static const String userDashboardSummary = 'user_dashboard_summary';
}
