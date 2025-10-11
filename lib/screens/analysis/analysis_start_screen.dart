// lib/screens/analysis/analysis_start_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AnalysisStartScreen extends StatelessWidget {
  const AnalysisStartScreen({super.key});

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Camera option
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 1920,
                  maxHeight: 1920,
                  imageQuality: 85,
                );

                if (image != null && context.mounted) {
                  context.push('/analyzing', extra: image.path);
                }
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/13/camera.png',
                    width: 145,
                    height: 145,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Take a photo',
                    style: TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 55),

            // Gallery option
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1920,
                  maxHeight: 1920,
                  imageQuality: 85,
                );

                if (image != null && context.mounted) {
                  context.push('/analyzing', extra: image.path);
                }
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/13/gallery.png',
                    width: 145,
                    height: 145,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/12/background2.jpg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            // ⭐ 하단 여백을 없애기 위해 bottom: false 추가
            bottom: false,
            child: Stack(
              children: [
                // Top UI (Back button, Title)
                Positioned(
                  top: 10,
                  left: 23,
                  right: 29,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Image.asset(
                          'assets/12/white_Back.png',
                          width: 59,
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'AI 퍼스널 컬러\n및 피부 분석',
                        style: TextStyle(
                          fontFamily: 'NanumSquareNeo',
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          height: 50 / 48,
                          letterSpacing: 0.11,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom UI (Guide image, Start button)
                Positioned(
                  bottom: 0, // 화면 하단에 고정
                  left: 0,
                  right: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. 가이드 이미지 (배경 역할)
                      Image.asset(
                        'assets/12/guide.png',
                        width: 444,
                      ),

                      // 2. 시작하기 버튼 (가이드 이미지 위에 겹쳐짐)
                      Positioned(
                        bottom: 50, // 가이드 이미지 하단으로부터 40px 위
                        child: GestureDetector(
                          onTap: () => _showImageSourceDialog(context),
                          child: Image.asset(
                            'assets/12/button_startifurready.png',
                            width: 306,
                            height: 48,
                          ),
                        ),
                      ),
                    ],
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