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
        child: Column(
          children: [
            // Top back button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 23, top: 20),
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

            // Expanded to fill remaining space
            Expanded(
              child: ListView( // Use ListView to prevent overflow on smaller screens
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 20),
                  // 'What is BF?'
                  const Text(
                    'What is BF?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color(0xFF000000),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Mole illustration
                  Image.asset(
                    'assets/10/doduge5.png',
                    width: 240, // 2. Increased size
                    height: 240,
                  ),

                  const SizedBox(height: 0),

                  // Animated text
                  FadeTransition(
                    opacity: _animation,
                    child: const Text(
                      '당신의 가장 똑똑한 AI 뷰티 친구',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFC6091D),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      '복잡한 뷰티 세계, 더 이상 혼자 고민하지 마세요.\n뷰파는 다음과 같은 의미를 담아 당신과 함께합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BF intro box
                  Image.asset(
                    'assets/10/bfintro.png',
                    width: 340,
                  ),

                  const SizedBox(height: 24), // 1. Replaced Spacer with SizedBox

                  // Bottom description text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 11.5,
                          height: 1.6,
                          color: Color(0xFF000000),
                        ),
                        children: [
                          TextSpan(
                            text: '이제 나에게 맞지 않는 제품으로 피부 고민을 더하는 대신,\n뷰파와 함께 과학적이고 ',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: '✨체계적인 뷰티 라이프✨',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: '를 시작해보세요.\n초보자와 민감성 피부도 안심하고 따라 할 수 있는\n',
                            style: TextStyle(fontWeight: FontWeight.normal),
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
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                   const SizedBox(height: 30), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}