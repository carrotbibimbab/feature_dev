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
    // ✅ "Welcome to" 애니메이션 (빠르게)
    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 600), // ✅ 1200 → 600ms
      vsync: this,
    );

    _welcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeController,
        curve: Curves.easeIn,
      ),
    );

    // ✅ "BF" 애니메이션 (빠르게)
    _bfController = AnimationController(
      duration: const Duration(milliseconds: 600), // ✅ 1200 → 600ms
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
    await _welcomeController.forward();

    // ✅ Welcome to가 완전히 나타난 후 300ms 대기 (800 → 300ms)
    await Future.delayed(const Duration(milliseconds: 300));
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
      // ✅ 3. 배경색을 배경 이미지 색상과 맞춤
      backgroundColor: const Color.fromARGB(255, 243, 197, 217), // 배경 이미지의 주요 색상
      body: Stack(
        children: [
          // ✅ 1. 배경 이미지 - 오른쪽으로 이동
          Positioned(
            left: 100, // 왼쪽에서 50px 밀어냄 (오른쪽으로 이동)
            right: -100, // 오른쪽으로 더 확장
            top: 0,
            bottom: 0,
            child: Image.asset(
              'assets/4/background1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ✅ 2. 텍스트 애니메이션 - 위치와 간격 개선
          Positioned(
            left: 0,
            right: 0,
            top: 240, // ✅ 중앙보다 약간 위
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ "Welcome to" - 작고, Italic, 왼쪽 정렬
                FadeTransition(
                  opacity: _welcomeOpacity,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 80),
                    child: const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontFamily: 'CrimsonText',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: 0,
                        height: 1.0, // ✅ 줄 높이 최소화
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 0), // ✅ 간격 완전 제거 (-100 → 0)

                // ✅ "BF" - 훨씬 크게, 가운데 정렬
                FadeTransition(
                  opacity: _bfOpacity,
                  child: Transform.translate(
                    offset: const Offset(0, -20), // ✅ BF를 위로 20px 당김
                    child: const Text(
                      'BF',
                      style: TextStyle(
                        fontFamily: 'CrimsonText',
                        fontSize: 175,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: 2,
                        height: 1.0, // ✅ 줄 높이 최소화
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 구글 로그인 버튼
          Positioned(
            left: 47,
            top: 700,
            child: GestureDetector(
              onTap: _handleGoogleSignIn,
              child: Image.asset(
                'assets/4/startwithgoogle.png',
                width: 300,
                height: 50,
              ),
            ),
          ),

          // ✅ 최하단 약관 동의 문구 - 한 줄로 표시
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 11,
                  color: Color(0xFF000000),
                  height: 1.2,
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