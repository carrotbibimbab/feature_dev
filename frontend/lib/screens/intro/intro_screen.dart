// lib/screens/intro/intro_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 55),

              // Back 버튼
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Image.asset(
                      'assets/10/Back.png',
                      width: 59,
                      height: 40,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // What is BF?
              const Text(
                'What is BF?',
                style: TextStyle(
                  fontFamily: 'Crimson Text',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 18),

              // 두더지 일러스트
              Image.asset(
                'assets/10/doduge5.png',
                width: 265,
                height: 265,
              ),

              const SizedBox(height: 41),

              // 애니메이션 텍스트
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  '당신의 가장 똑똑한 AI 뷰티 친구',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFC6091D),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 설명 텍스트
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 71),
                child: Text(
                  '복잡한 뷰티 세계, 더 이상 혼자 고민하지 마세요.\n뷰파는 다음과 같은 의미를 담아 당신과 함께합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontSize: 12,
                    height: 20 / 12,
                    color: Color(0xFF000000),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 뷰파 의미 박스
              Image.asset(
                'assets/10/bfintro.png',
                width: 370,
                height: 98,
              ),

              const SizedBox(height: 45),

              // 하단 설명 텍스트
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontSize: 12,
                      height: 20 / 12,
                    ),
                    children: [
                      TextSpan(
                        text: '이제 나에게 맞지 않는 제품으로 피부 고민을 더하는 대신,\n뷰파와 함께 과학적이고 ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextSpan(
                        text: '✨체계적인 뷰티 라이프✨',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextSpan(
                        text: '를 시작해보세요.\n초보자와 민감성 피부도 안심하고 따라 할 수 있는\n',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextSpan(
                        text: '개인 맞춤형 뷰티 가이드',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE8B7D4),
                        ),
                      ),
                      TextSpan(
                        text: '를 제공합니다.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
