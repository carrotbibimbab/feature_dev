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
      barrierColor: Colors.black.withOpacity(0.7), // 어두운 배경
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 카메라
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
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 55),

            // 갤러리
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
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
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
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/12/background2.jpg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 55),

                // 뒤로가기 버튼
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(
                      'assets/12/white_Back.png',
                      width: 59,
                      height: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // 제목 텍스트
                Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: Text(
                    'AI 퍼스널 컬러\n및 피부 분석',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
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
                ),

                const Spacer(),

                // 가이드 이미지
                Image.asset(
                  'assets/12/guide.png',
                  width: 444,
                  height: 303,
                ),

                const SizedBox(height: 52),

                // 시작하기 버튼
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceDialog(context),
                    child: Image.asset(
                      'assets/12/button_startifurready.png',
                      width: 306,
                      height: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
