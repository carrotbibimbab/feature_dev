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
  late Animation<double> _line1Opacity;
  late Animation<double> _line2Opacity;
  late Animation<double> _line3Opacity;
  
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
    // 텍스트 애니메이션 컨트롤러 (3초)
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // 첫 번째 줄: "Discover" (0~1초)
    _line1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeIn),
      ),
    );
    
    // 두 번째 줄: "your" (1~2초)
    _line2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.33, 0.66, curve: Curves.easeIn),
      ),
    );
    
    // 세 번째 줄: "true colors" (2~3초)
    _line3Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimationSequence() {
    Timer(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    Timer(const Duration(milliseconds: 5000), () {
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

  // 2-0: 'Discover your true colors' (순차적 fade in)
  Widget _buildIntroAnimation() {
    return Center(
      key: const ValueKey('intro'),
      child: AnimatedBuilder(
        animation: _textAnimationController,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 첫 번째 줄: "Discover"
              Opacity(
                opacity: _line1Opacity.value,
                child: const Text(
                  'Discover',
                  style: TextStyle(
                    fontFamily: 'CrimsonText',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 2.0,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // 두 번째 줄: "your"
              Opacity(
                opacity: _line2Opacity.value,
                child: const Text(
                  'your',
                  style: TextStyle(
                    fontFamily: 'CrimsonText',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 2.0,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // 세 번째 줄: "true colors"
              Opacity(
                opacity: _line3Opacity.value,
                child: const Text(
                  'true colors',
                  style: TextStyle(
                    fontFamily: 'CrimsonText',
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 2.0,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 2-1 ~ 2-3: 온보딩 페이지
  Widget _buildOnboardingPageView() {
    return Stack(
      key: const ValueKey('pageView'),
      children: [
        // ✅ PageView - physics 속성으로 스와이프 비활성화
        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // ✅ 스와이프 비활성화
          children: const [
            _OnboardingPage(
              imagePath: 'assets/2-1/doduge1.png',
              imageTop: 10, // ✅ 위로 올림 (53 → 30)
              title: '5초 만에 진단하는 퍼스널 컬러', // ✅ 한 줄로 통합
              description: '단 한 장의 사진으로, 당신의 피부톤에 맞는\n최적의 컬러 팔레트를 제안합니다.',
            ),
            _OnboardingPage(
              imagePath: 'assets/2-2/doduge2.png',
              imageTop: 77, // ✅ 위로 올림 (120 → 97)
              title: '피부 타입별 맞춤 성분 분석', // ✅ 한 줄로 통합
              description: '피부 트러블 유발 성분은 이제 그만!\nAI가 안전한 선택을 도와드립니다.',
            ),
            _OnboardingPage(
              imagePath: 'assets/2-3/doduge3.png',
              imageTop: 78, // ✅ 위로 올림 (121 → 98)
              title: '한 눈에 보는 나의 분석 로그', // ✅ 한 줄로 통합
              description: '분석 결과를 언제든지 다시 확인하고\n나의 뷰티 히스토리를 관리해보세요.',
            ),
          ],
        ),

        // Skip 버튼 (2-1, 2-2만)
        if (_currentPage < 2)
          Positioned(
            left: 310,
            top: 20, // ✅ 더 위로 올림 (40 → 30)
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
          top: 605, // ✅ 더 위로 올림 (635 → 615)
          child: Image.asset(
            'assets/2-${_currentPage + 1}/onboarding_indicator${_currentPage + 1}.png',
            width: 70,
            height: 8,
          ),
        ),

        // Next/Start 버튼
        Positioned(
          left: 45,
          top: 654, // ✅ 더 위로 올림 (694 → 674)
          child: GestureDetector(
            onTap: () {
              if (_currentPage == 2) {
                _navigateToPermissionScreen();
              } else {
                // ✅ 부드러운 애니메이션으로 다음 페이지
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
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
  final String description;

  const _OnboardingPage({
    required this.imagePath,
    required this.imageTop,
    required this.title,
    required this.description,
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

        // ✅ 제목 - 한 줄로 통합, 가운데 정렬
        Positioned(
          left: 0,
          right: 0,
          top: 468, // ✅ 위로 올림 (511 → 488)
          child: RichText(
            textAlign: TextAlign.center, // ✅ 가운데 정렬
            text: TextSpan(
              children: _buildTitleSpans(title),
            ),
          ),
        ),

        // ✅ 설명 - 오른쪽 정렬
        Positioned(
          left: 20,
          right: 20,
          top: 524, // ✅ 위로 올림 (567 → 544)
          child: Text(
            description,
            textAlign: TextAlign.center, // ✅ 가운데 정렬
            style: const TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontSize: 15,
              color: Color(0xFF828282),
              height: 20 / 15,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 제목을 검은색/빨간색으로 분리하는 함수
  List<TextSpan> _buildTitleSpans(String title) {
    // "5초 만에 진단하는 퍼스널 컬러" -> "5초 만에 진단하는" + "퍼스널 컬러"
    // "피부 타입별 맞춤 성분 분석" -> "피부 타입별" + "맞춤 성분 분석"
    // "한 눈에 보는 나의 분석 로그" -> "한 눈에 보는" + "나의 분석 로그"
    
    String blackPart = '';
    String redPart = '';
    
    if (title.contains('퍼스널 컬러')) {
      blackPart = '5초 만에 진단하는 ';
      redPart = '퍼스널 컬러';
    } else if (title.contains('맞춤 성분 분석')) {
      blackPart = '피부 타입별 ';
      redPart = '맞춤 성분 분석';
    } else if (title.contains('나의 분석 로그')) {
      blackPart = '한 눈에 보는 ';
      redPart = '나의 분석 로그';
    }
    
    return [
      TextSpan(
        text: blackPart,
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w900, // ✅ 더 굵게 (bold → w900)
          fontSize: 20,
          color: Color(0xFF000000),
        ),
      ),
      TextSpan(
        text: redPart,
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w900, // ✅ 더 굵게 (bold → w900)
          fontSize: 20,
          color: Color(0xFFC6091D),
        ),
      ),
    ];
  }
}