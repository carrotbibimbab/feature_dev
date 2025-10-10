// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bf_app/services/auth_service.dart';
import 'package:bf_app/services/supabase_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _init();
  }

  /// 초기화: 현재 사용자 확인 및 Auth 상태 리스너 등록
  void _init() {
    _currentUser = _authService.getCurrentUser();
    
    // Auth 상태 변화 감지
    _authService.authStateChanges.listen((AuthState authState) {
      _currentUser = authState.session?.user;
      notifyListeners();
    });
  }

  /// Google 로그인 (Supabase Auth 사용)
  Future<bool> signInWithGoogle({
    required String idToken,
    required String accessToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithToken(
        idToken: idToken,
        accessToken: accessToken,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      _errorMessage = '로그인 실패: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '로그아웃 실패: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 현재 사용자 새로고침
  void refreshUser() {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }

  /// Access Token 가져오기 (API 호출 시 사용)
  String? getAccessToken() {
    final session = SupabaseConfig.client.auth.currentSession;
    return session?.accessToken;
  }

  /// 에러 메시지 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}