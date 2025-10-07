// lib/screens/analysis/face_detection_failed_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaceDetectionFailedScreen extends StatelessWidget {
  const FaceDetectionFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 137),

            // 제목
            const Text(
              '얼굴을 인식할 수 없습니다 🥲',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w600,
                fontSize: 22,
                letterSpacing: 0.11,
                color: Color(0xFF000000),
              ),
            ),

            const SizedBox(height: 16),

            // 두더지 일러스트
            Image.asset(
              'assets/16/doduge5.png',
              width: 300,
              height: 300,
            ),

            const SizedBox(height: 9),

            // 설명 텍스트
            const Text(
              '다음과 같은 상황에서는\n인식이 되지 않을 수 있어요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                letterSpacing: 0.11,
                color: Color(0xFF828282),
                height: 24 / 16,
              ),
            ),

            const SizedBox(height: 38),

            // 가이드 이미지
            Image.asset(
              'assets/16/guide_photo.png',
              width: 318,
              height: 146,
            ),

            const Spacer(),

            // 돌아가기 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: GestureDetector(
                onTap: () => context.go('/analysis-start'),
                child: Image.asset(
                  'assets/16/button_returnto.png',
                  width: 318,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
