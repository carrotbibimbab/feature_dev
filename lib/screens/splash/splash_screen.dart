import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _redLogoOpacity;
  late Animation<double> _whiteLogoOpacity;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // 전체 애니메이션 컨트롤러 (2.5초)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // 배경색 페이드 애니메이션: 흰색 → 핑크
    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: const Color(0xFFE8B7D4),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );

    // 빨간 로고: 배경 전환과 함께 사라짐
    _redLogoOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // 흰색 로고: 배경 전환과 함께 나타남
    _whiteLogoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimationSequence() async {
    // 500ms 대기 후 애니메이션 시작 (빨간 로고를 충분히 보여줌)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    await _controller.forward();

    // ✅ 애니메이션 완료 후 1.5초 대기 (흰색 로고를 충분히 보여줌)
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: _backgroundColorAnimation.value,
            child: Center(
              child: SizedBox(
                width: 391.25,
                height: 153,
                child: Stack(
                  children: [
                    // 빨간 로고 (배경 전환과 함께 사라짐)
                    Opacity(
                      opacity: _redLogoOpacity.value,
                      child: Image.asset(
                        'assets/1-1/logo_red.png',
                        width: 391.25,
                        height: 153,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    // 흰색 로고 (배경 전환과 함께 나타남)
                    Opacity(
                      opacity: _whiteLogoOpacity.value,
                      child: Image.asset(
                        'assets/1-3/logo_white.png',
                        width: 391.25,
                        height: 153,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}