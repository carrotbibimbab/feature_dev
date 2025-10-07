import 'package:flutter/material.dart';
import 'package:bf_app/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _stage1Controller;
  late AnimationController _stage2Controller;
  late AnimationController _stage3Controller;

  late Animation<Offset> _miniWaveAnimation;
  late Animation<Offset> _bigWaveAnimation;
  late Animation<double> _logoFadeAnimation;

  int _currentStage = 1;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Stage 1: 작은 물결이 올라옴
    _stage1Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _miniWaveAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // 아래에서 시작
      end: const Offset(0, 0), // 원래 위치로
    ).animate(CurvedAnimation(
      parent: _stage1Controller,
      curve: Curves.easeInOut,
    ));

    // Stage 2: 큰 물결이 화면 덮음
    _stage2Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bigWaveAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _stage2Controller,
      curve: Curves.easeInOut,
    ));

    // Stage 3: 로고 페이드인
    _stage3Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stage3Controller,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Stage 1: 200ms 대기 후 작은 물결 애니메이션
    await Future.delayed(const Duration(milliseconds: 200));
    await _stage1Controller.forward();

    // Stage 2: 200ms 대기 후 큰 물결 애니메이션
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _currentStage = 2);
    await _stage2Controller.forward();

    // Stage 3: 200ms 대기 후 흰색 로고 페이드인
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _currentStage = 3);
    await _stage3Controller.forward();

    // 1초 대기 후 다음 화면으로
    await Future.delayed(const Duration(milliseconds: 1000));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _stage1Controller.dispose();
    _stage2Controller.dispose();
    _stage3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1-1: 흰색 배경
          Container(color: Colors.white),

          // 1-1: 작은 물결 (숨겨져 있다가 올라옴)
          if (_currentStage >= 1)
            SlideTransition(
              position: _miniWaveAnimation,
              child: Positioned(
                left: -18.54,
                top: 862,
                child: Image.asset(
                  'assets/1-1/ss1_miniwave.png',
                  width: 431,
                  height: 571,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // 1-2 & 1-3: 큰 물결 (화면 전체 덮음)
          if (_currentStage >= 2)
            SlideTransition(
              position: _bigWaveAnimation,
              child: Positioned(
                left: -683,
                top: -665,
                child: Image.asset(
                  'assets/1-2/ss1_bigwave.png',
                  width: 1176,
                  height: 1559,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // 로고 (중앙)
          Positioned(
            left: 1,
            top: 349,
            child: SizedBox(
              width: 391.25,
              height: 153,
              child: _currentStage < 3
                  // 1-1, 1-2: 빨간 로고
                  ? Image.asset(
                      'assets/1-1/logo_red.png',
                      width: 391.25,
                      height: 153,
                      fit: BoxFit.contain,
                    )
                  // 1-3: 흰색 로고 (페이드인)
                  : FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: Image.asset(
                        'assets/1-3/logo_white.png',
                        width: 391.25,
                        height: 153,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
