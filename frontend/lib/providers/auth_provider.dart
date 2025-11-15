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

  void _init() {
    _currentUser = _authService.getCurrentUser();
    
    _authService.authStateChanges.listen((AuthState authState) {
      _currentUser = authState.session?.user;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signInWithGoogle();

      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      _errorMessage = '로그인 실패: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      print('❌ AuthProvider 로그인 에러: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '로그아웃 실패: ${e.toString()}';
      print('❌ AuthProvider 로그아웃 에러: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshUser() {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }

  String? getAccessToken() {
    // ⭐ SupabaseConfig.client 사용
    final session = SupabaseConfig.client.auth.currentSession;
    return session?.accessToken;
  }

  Session? getCurrentSession() {
    return _authService.getCurrentSession();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}