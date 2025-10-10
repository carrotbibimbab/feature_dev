// lib/screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // 텍스트 애니메이션
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // Confetti 컨트롤러
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _textController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti 애니메이션 (화면 전체)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Color(0xFFE8B7D4), // 핑크
                Color(0xFFC6091D), // 빨강
                Color(0xFF6DD5ED), // 파랑
                Color(0xFFFFD700), // 노랑
              ],
            ),
          ),

          // 메인 콘텐츠
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 140),

                // "Successful!" 텍스트
                FadeTransition(
                  opacity: _textOpacity,
                  child: const Text(
                    'Successful!',
                    style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 두더지 일러스트
                Image.asset(
                  'assets/6/doduge4.png',
                  width: 442,
                  height: 442,
                ),

                const Spacer(),

                // 뷰파 시작하기 버튼
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: GestureDetector(
                    onTap: _navigateToHome,
                    child: Image.asset(
                      'assets/6/start_bf.png',
                      width: 318,
                      height: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
