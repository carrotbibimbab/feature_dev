// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bf_app/config/app_config.dart';
import 'package:bf_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late AnimationController _bfController;
  late Animation<double> _welcomeOpacity;
  late Animation<double> _bfOpacity;
  
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _shouldStartAnimation = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingLogin();
  }

  // ⭐ Supabase 세션 체크
  void _checkExistingLogin() async {
    // Supabase 세션이 있는지 확인
    final isLoggedIn = _authService.isLoggedIn();

    if (isLoggedIn) {
      final user = _authService.getCurrentUser();
      print('🔑 기존 로그인 발견: ${user?.email}');
      
      _shouldStartAnimation = false;

      if (mounted) {
        context.go('/profile-setup');
      }
    } else {
      print('🔍 로그인 필요');
      
      if (mounted) {
        _startAnimationSequence();
      }
    }
  }

  void _initializeAnimations() {
    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _welcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeController,
        curve: Curves.easeIn,
      ),
    );

    _bfController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bfOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bfController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _welcomeController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _bfController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _bfController.dispose();
    super.dispose();
  }

  // ⭐ Google 로그인 (Supabase + google_sign_in)
  void _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // AuthService의 signInWithGoogle 호출
      final user = await _authService.signInWithGoogle();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          print('✅ 로그인 성공: ${user.email}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('환영합니다, ${user.email}님!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // 프로필 설정으로 이동
          context.go('/profile-setup');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('로그인이 취소되었습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ 로그인 에러: $e');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // "Welcome to" 텍스트
                  FadeTransition(
                    opacity: _welcomeOpacity,
                    child: const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF6C757D),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // "BF" 로고
                  FadeTransition(
                    opacity: _bfOpacity,
                    child: const Text(
                      'BF',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212529),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 부제
                  FadeTransition(
                    opacity: _bfOpacity,
                    child: const Text(
                      'Beauty Finder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6C757D),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // Google 로그인 버튼
                  FadeTransition(
                    opacity: _bfOpacity,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF212529),
                          elevation: 2,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFFDEE2E6),
                              width: 1,
                            ),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF212529),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.g_mobiledata, size: 28),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Google 계정으로 로그인',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 개인정보 처리방침 등
                  FadeTransition(
                    opacity: _bfOpacity,
                    child: Text(
                      '로그인하면 서비스 약관 및\n개인정보 처리방침에 동의하게 됩니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
