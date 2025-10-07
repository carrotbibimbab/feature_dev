import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _textOpacityAnimation;
  final PageController _pageController = PageController();

  bool _showPageView = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _initializeAnimations() {
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimationSequence() {
    Timer(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        _showPageView = true;
      });
    });
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPermissionScreen() {
    context.go('/permission');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _showPageView
              ? _buildOnboardingPageView()
              : _buildIntroAnimation(),
        ),
      ),
    );
  }

  // 2-0: 'Discover your true colors'
  Widget _buildIntroAnimation() {
    return Center(
      key: const ValueKey('intro'),
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: const Text(
          'Discover\nyour\ntrue colors',
          style: TextStyle(
            fontFamily: 'CrimsonText',
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 60 / 38,
            letterSpacing: 5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // 2-1 ~ 2-3: 온보딩 페이지
  Widget _buildOnboardingPageView() {
    return Stack(
      key: const ValueKey('pageView'),
      children: [
        // PageView
        PageView(
          controller: _pageController,
          children: const [
            _OnboardingPage(
              imagePath: 'assets/2-1/doduge1.png',
              imageTop: 53,
              title: '5초 만에 진단하는',
              titleLeft: 72,
              subtitle: '퍼스널 컬러',
              subtitleLeft: 72,
              description: '단 한 장의 사진으로, 당신의 피부톤에 맞는\n최적의 컬러 팔레트를 제안합니다.',
              descriptionLeft: 66,
            ),
            _OnboardingPage(
              imagePath: 'assets/2-2/doduge2.png',
              imageTop: 120,
              title: '피부 타입별',
              titleLeft: 87,
              subtitle: '맞춤 성분 분석',
              subtitleLeft: 87,
              description: '피부 트러블 유발 성분은 이제 그만!\nAI가 안전한 선택을 도와드립니다.',
              descriptionLeft: 88,
            ),
            _OnboardingPage(
              imagePath: 'assets/2-3/doduge3.png',
              imageTop: 121,
              title: '한 눈에 보는',
              titleLeft: 76,
              subtitle: '나의 분석 로그',
              subtitleLeft: 76,
              description: '분석 결과를 언제든지 다시 확인하고\n나의 뷰티 히스토리를 관리해보세요.',
              descriptionLeft: 85,
            ),
          ],
        ),

        // Skip 버튼 (2-1, 2-2만)
        if (_currentPage < 2)
          Positioned(
            left: 323,
            top: 55,
            child: GestureDetector(
              onTap: _navigateToPermissionScreen,
              child: Image.asset(
                'assets/2-1/Skip.png',
                width: 53,
                height: 40,
              ),
            ),
          ),

        // 인디케이터
        Positioned(
          left: 162,
          top: 650,
          child: Image.asset(
            'assets/2-${_currentPage + 1}/onboarding_indicator${_currentPage + 1}.png',
            width: 70,
            height: 8,
          ),
        ),

        // Next/Start 버튼
        Positioned(
          left: 45,
          top: 709,
          child: GestureDetector(
            onTap: () {
              if (_currentPage == 2) {
                _navigateToPermissionScreen();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Image.asset(
              _currentPage == 2
                  ? 'assets/2-3/start.png'
                  : 'assets/2-1/next.png',
              width: 306,
              height: 48,
            ),
          ),
        ),
      ],
    );
  }
}

// 개별 온보딩 페이지
class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final double imageTop;
  final String title;
  final double titleLeft;
  final String subtitle;
  final double subtitleLeft;
  final String description;
  final double descriptionLeft;

  const _OnboardingPage({
    required this.imagePath,
    required this.imageTop,
    required this.title,
    required this.titleLeft,
    required this.subtitle,
    required this.subtitleLeft,
    required this.description,
    required this.descriptionLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 두더지 일러스트
        Positioned(
          left: -24,
          top: imageTop,
          child: Image.asset(
            imagePath,
            width: 442,
            height: 442,
          ),
        ),

        // 제목 (검은색)
        Positioned(
          left: titleLeft,
          top: 511,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF000000),
            ),
          ),
        ),

        // 부제목 (빨간색)
        Positioned(
          left: subtitleLeft,
          top: 535, // 제목 아래
          child: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFC6091D),
            ),
          ),
        ),

        // 설명
        Positioned(
          left: descriptionLeft,
          top: 567,
          child: Text(
            description,
            style: const TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 15,
              color: Color(0xFF828282),
              height: 20 / 15,
            ),
          ),
        ),
      ],
    );
  }
}
