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
  late Animation<Color?> _colorAnimation;
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

    // 배경색 애니메이션: 흰색 → E8B7D4 (핑크)
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: const Color(0xFFE8B7D4),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut), // 0.5초~2초
      ),
    );

    // 빨간 로고: 처음엔 보이다가 서서히 사라짐
    _redLogoOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut), // 0.75초~1.5초
      ),
    );

    // 흰색 로고: 빨간 로고가 사라질 때 나타남
    _whiteLogoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn), // 1초~1.75초
      ),
    );
  }

  void _startAnimationSequence() async {
    // 300ms 대기 후 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    await _controller.forward();

    // 애니메이션 완료 후 1초 대기
    await Future.delayed(const Duration(milliseconds: 1000));
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
            color: _colorAnimation.value,
            child: Center(
              child: SizedBox(
                width: 391.25,
                height: 153,
                child: Stack(
                  children: [
                    // 빨간 로고 (처음에 보임 → 사라짐)
                    Opacity(
                      opacity: _redLogoOpacity.value,
                      child: Image.asset(
                        'assets/1-1/logo_red.png',
                        width: 391.25,
                        height: 153,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // 흰색 로고 (나중에 나타남)
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
