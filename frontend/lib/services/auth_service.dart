// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _supabase = SupabaseConfig.client;

  // ⭐ 추가: Google Sign-In 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // iOS 클라이언트 ID는 Info.plist에서 읽음
  );

  // ⭐ 추가: Google 로그인 (Supabase 통합)
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Google 로그인으로 토큰 받기
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ Google 로그인 취소됨');
        return null;
      }

      // 2. Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        print('❌ Google 토큰을 가져올 수 없음');
        return null;
      }

      print('✅ Google 로그인 성공');
      print('📧 Email: ${googleUser.email}');

      // 3. Supabase에 Google 토큰으로 인증
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      print('✅ Supabase 인증 완료');
      return response.user;
    } catch (error) {
      print('❌ 로그인 에러: $error');
      rethrow;
    }
  }

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
