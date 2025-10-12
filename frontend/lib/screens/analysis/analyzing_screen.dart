// lib/screens/analysis/analyzing_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // ✨ 추가
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/providers/analysis_provider.dart';  // ✨ 추가
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
    // ✨ Provider를 통해 분석 시작
    final analysisProvider = context.read<AnalysisProvider>();

    try {
      // ✨ Provider의 analyzeImage 메서드 호출
      // (이미 내부에서 진행 상태를 업데이트하고 있음)
      final analysisResult = await analysisProvider.analyzeImage(
        imageFile: File(widget.imagePath),
      );

      if (analysisResult == null) {
        // 분석 실패
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                analysisProvider.error ?? '분석에 실패했습니다. 다시 시도해주세요.',
              ),
            ),
          );
          context.go('/analysis-start');
        }
        return;
      }

      // 얼굴 인식 체크
      if (analysisResult.faceDetected == false) {
        if (mounted) {
          context.go('/face-detection-failed');
        }
        return;
      }

      // 분석 완료 후 결과 화면으로 이동 (최소 8초 보여주기)
      if (mounted) {
        // 애니메이션과 분석이 모두 완료될 때까지 대기
        await Future.delayed(const Duration(milliseconds: 8000));
        context.go('/analysis-result', extra: analysisResult);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('분석 실패: $e')),
        );
        context.go('/analysis-start');
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'NanumSquareNeo',
                            fontSize: 20,
                            height: 35 / 20,
                            letterSpacing: 2,
                          ),
                          children: [
                            const TextSpan(
                              text: 'AI가 ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
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
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ✨ Provider의 진행 상태 실시간 표시
                      Consumer<AnalysisProvider>(
                        builder: (context, analysisProvider, child) {
                          if (analysisProvider.analysisStage.isNotEmpty) {
                            return Column(
                              children: [
                                Text(
                                  analysisProvider.analysisStage,
                                  style: const TextStyle(
                                    fontFamily: 'NanumSquareNeo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF666666),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                // 진행률 표시
                                if (analysisProvider.analysisProgress > 0)
                                  Text(
                                    '${(analysisProvider.analysisProgress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontFamily: 'NanumSquareNeo',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE8B7D4),
                                    ),
                                  ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 로딩 인디케이터
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE8B7D4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ✨ 진행률 바 추가 (선택사항)
                      Consumer<AnalysisProvider>(
                        builder: (context, analysisProvider, child) {
                          if (analysisProvider.analysisProgress > 0) {
                            return Container(
                              width: 200,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: analysisProvider.analysisProgress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8B7D4),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
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