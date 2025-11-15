import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bf_app/services/supabase_service.dart'; 

class AuthService {
  // ⭐ 변경: SupabaseConfig.client 대신 Supabase.instance.client 사용
  SupabaseClient get _supabase => SupabaseConfig.client;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<User?> signInWithGoogle() async {
    try {
      print('🔐 Google 로그인 시작...');
      
      // 1. Google 로그인
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ Google 로그인 취소됨');
        return null;
      }

      print('✅ Google 계정 선택: ${googleUser.email}');

      // 2. Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('🔑 Access Token: ${accessToken?.substring(0, 20)}...');
      print('🔑 ID Token: ${idToken?.substring(0, 20)}...');

      if (accessToken == null || idToken == null) {
        print('❌ Google 토큰을 가져올 수 없음');
        throw Exception('Google 토큰을 가져올 수 없습니다.');
      }

      // ⭐ Supabase URL 확인 (supabaseUrl getter 제거)
      print('🔍 Supabase URL: ${SupabaseConfig.supabaseUrl}');

      // 3. Supabase에 Google 토큰으로 인증
      print('🔄 Supabase 인증 시작...');
      
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw Exception('Supabase 인증에 실패했습니다.');
      }

      print('✅ Supabase 인증 완료: ${response.user!.email}');
      return response.user;
    } catch (error) {
      print('❌ 로그인 에러: $error');
      rethrow;
    }
  }

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
    await _googleSignIn.signOut();
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
  
  Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }

  // 인증 상태 스트림
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}