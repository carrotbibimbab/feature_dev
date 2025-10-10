// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bf_app/services/supabase_service.dart';

class AuthService {
  final _supabase = SupabaseConfig.client;

  // 백엔드에서 받은 토큰으로 Supabase 인증
  Future<User?> signInWithToken({
    required String idToken,
    required String accessToken,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response.user;
    } catch (error) {
      print('Token 인증 에러: $error');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 현재 사용자
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // 로그인 상태 확인
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // 인증 상태 스트림
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}
