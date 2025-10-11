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
        child: Padding(
          // 전체적인 좌우 여백을 줍니다.
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            // 자식 위젯들이 가로로 꽉 차도록 설정합니다.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 뒤로가기 버튼 제거 후, 상단 여백으로 위치 조절
              const SizedBox(height: 80),

              // 제목
              const Text(
                '얼굴을 인식할 수 없습니다 🥲',
                textAlign: TextAlign.center, // 1. 텍스트 가운데 정렬
                style: TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: 0.11,
                  color: Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 20),

              // 두더지 일러스트
              Center( // 1. 이미지를 명시적으로 가운데 정렬
                child: Image.asset(
                  'assets/16/doduge5.png',
                  width: 280,
                  height: 280,
                ),
              ),

              const SizedBox(height: 16),

              // 설명 텍스트
              const Text(
                '다음과 같은 상황에서는\n인식이 되지 않을 수 있어요!',
                textAlign: TextAlign.center, // 1. 텍스트 가운데 정렬
                style: TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontSize: 16,
                  letterSpacing: 0.11,
                  color: Color(0xFF828282),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // 가이드 이미지
              Center( // 1. 이미지를 명시적으로 가운데 정렬
                child: Image.asset(
                  'assets/16/guide_photo.png',
                  width: 318,
                  height: 146,
                ),
              ),

              // Spacer()를 사용하여 남은 공간을 모두 차지, 버튼을 맨 아래로 밀어냅니다.
              const Spacer(),

              // 돌아가기 버튼 (화면 하단에 배치)
              Center( // 1. 버튼을 명시적으로 가운데 정렬
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: () => context.go('/analysis-start'),
                    child: Image.asset(
                      'assets/16/button_returnto.png',
                      width: 318,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}