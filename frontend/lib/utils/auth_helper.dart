// lib/utils/auth_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bf_app/services/supabase_service.dart';

class AuthHelper {
  /// 현재 로그인한 사용자 ID 가져오기 (Supabase 또는 개발자 모드)
  static Future<String?> getCurrentUserId() async {
    // 1. Supabase 사용자 확인
    final supabaseUser = SupabaseConfig.currentUser;
    if (supabaseUser != null) {
      return supabaseUser.id;
    }
    
    // 2. SharedPreferences에서 개발자 모드 사용자 확인
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_sub');
  }
  
  /// 현재 사용자 이름 가져오기
  static Future<String?> getCurrentUserName() async {
    final supabaseUser = SupabaseConfig.currentUser;
    if (supabaseUser != null) {
      return supabaseUser.userMetadata?['name'];
    }
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
  
  /// 현재 사용자 이메일 가져오기
  static Future<String?> getCurrentUserEmail() async {
    final supabaseUser = SupabaseConfig.currentUser;
    if (supabaseUser != null) {
      return supabaseUser.email;
    }
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
  
  /// 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null;
  }
}