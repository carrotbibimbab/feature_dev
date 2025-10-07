// lib/screens/analysis/analyzing_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class AnalyzingScreen extends StatefulWidget {
  final String imagePath;

  const AnalyzingScreen({super.key, required this.imagePath});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  final _dataService = SupabaseDataService();
  final _apiService = ApiService();

  late AnimationController _controller;
  late Animation<double> _animation;

  String _userName = '사용자';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initializeAnimation();
    _startAnalysis();
  }

  Future<void> _loadUserName() async {
    final profile = await _dataService.getCurrentUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _userName = profile.name;
      });
    }
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 1ms 지연 후 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 1), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Future<void> _startAnalysis() async {
    try {
      // 실제 AI 분석 API 호출
      final analysisResult = await _apiService.analyzeImageComprehensive(
        File(widget.imagePath),
      );

      // 얼굴 인식 체크
      if (analysisResult.faceDetected == false) {
        if (mounted) {
          context.go('/face-detection-failed');
        }
        return;
      }

      // 분석 완료 후 결과 화면으로 이동 (최소 8초 보여주기)
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 8000));
        context.go('/analysis-result', extra: analysisResult);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('분석 실패: $e')),
        );
        context.pop();
      }
    }
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
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // 배경색 애니메이션
              Container(
                color: Color.lerp(
                  const Color(0xFFEBF7FF), // 분석중1 배경
                  const Color(0xFFFDF4FA), // 분석중2 배경
                  _animation.value,
                ),
              ),

              // 도형 1 (상단)
              Positioned(
                left: _animation.value == 0 ? 208 : 0,
                top: _animation.value == 0 ? 146 : 91,
                child: Opacity(
                  opacity: 1.0 - (_animation.value * 0.3),
                  child: Image.asset(
                    _animation.value < 0.5
                        ? 'assets/15-1,2/1union1.png'
                        : 'assets/15-1,2/2union1.png',
                    width: _animation.value < 0.5 ? 275.52 : 454.75,
                    height: _animation.value < 0.5 ? 257.95 : 315.65,
                  ),
                ),
              ),

              // 도형 2 (하단)
              Positioned(
                left: _animation.value == 0 ? -71 : -29,
                top: _animation.value == 0 ? 521.27 : 379,
                child: Opacity(
                  opacity: 1.0 - (_animation.value * 0.3),
                  child: Image.asset(
                    _animation.value < 0.5
                        ? 'assets/15-1,2/1union2.png'
                        : 'assets/15-1,2/2union2.png',
                    width: _animation.value < 0.5 ? 318 : 375.78,
                    height: _animation.value < 0.5 ? 210.73 : 351.82,
                  ),
                ),
              ),

              // 중앙 텍스트
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 86),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 20,
                        height: 35 / 20,
                        letterSpacing: 2,
                      ),
                      children: [
                        const TextSpan(
                          text: 'AI가 ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                        TextSpan(
                          text: _userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC6091D),
                          ),
                        ),
                        const TextSpan(
                          text: '님의\n얼굴을 분석 중이에요···',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 로딩 인디케이터
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFE8B7D4),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
