// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // "Welcome to" 애니메이션
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

    // "BF" 애니메이션
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
    // "Welcome to" 먼저 표시
    await Future.delayed(const Duration(milliseconds: 300));
    _welcomeController.forward();

    // 400ms 후 "BF" 표시
    await Future.delayed(const Duration(milliseconds: 400));
    _bfController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _bfController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    // TODO: 백엔드 연동 시 여기에 구글 로그인 로직 추가
    // 현재는 바로 프로필 설정 화면으로 이동
    context.go('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/4/background1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 중앙 텍스트 애니메이션
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "Welcome to" (먼저 나타남)
                FadeTransition(
                  opacity: _welcomeOpacity,
                  child: const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                // "BF" (시간차로 나타남)
                FadeTransition(
                  opacity: _bfOpacity,
                  child: const Text(
                    'BF',
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 구글 로그인 버튼
          Positioned(
            left: 47,
            top: 709,
            child: GestureDetector(
              onTap: _handleGoogleSignIn,
              child: Image.asset(
                'assets/4/startwithgoogle.png',
                width: 300,
                height: 50,
              ),
            ),
          ),

          // 최하단 약관 동의 문구
          Positioned(
            left: 70,
            top: 790,
            right: 70,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 11,
                  color: Color(0xFF000000),
                ),
                children: [
                  TextSpan(text: '첫 로그인 시 '),
                  TextSpan(
                    text: '개인정보처리방침',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  TextSpan(text: ' 및 '),
                  TextSpan(
                    text: '이용약관',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  TextSpan(text: ' 동의로 간주합니다.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
