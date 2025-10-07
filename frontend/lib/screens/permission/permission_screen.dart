//lib\screens\permission\permission_screen.dart

import 'package:bf_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  // 권한을 요청하고 다음 화면으로 이동하는 함수
  Future<void> _requestPermissionsAndNavigate(BuildContext context) async {
    // 필수 권한인 카메라와 사진 권한을 요청합니다.
    await [
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();

    // 권한 요청 후에는 위젯이 마운트된 상태인지 확인하고 화면을 이동합니다.
    if (context.mounted) {
      // '시작하기' 페이지(로그인)로 이동합니다.
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI의 반응형 크기를 위해 화면 너비를 가져옵니다.
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // 배경을 흰색으로 변경
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth > 394 ? 364 : screenWidth - 30, // 화면 너비에 따라 조절
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0), // 디자인에 맞게 모서리 반경 조정
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '편리한 서비스 이용을 위한\n접근 권한 허용이 필요합니다.',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 30 / 24, // 행간 30px
                  ),
                ),
                const SizedBox(height: 34),
                _buildPermissionItem(
                  emoji: '📷',
                  title: '카메라 (필수)',
                  description: '피부 촬영을 위해 사용돼요.',
                ),
                const SizedBox(height: 20),
                _buildPermissionItem(
                  emoji: '🖼️',
                  title: '사진 (필수)',
                  description: '앨범에 있는 사진을 불러오기 위해 사용돼요.',
                ),
                const SizedBox(height: 20),
                _buildPermissionItem(
                  emoji: '🔔',
                  title: '알림 (선택)',
                  description:
                      '맞춤형 피부 관리 정보나 이벤트 소식을 빠르게 받아볼 수 있어요. 원하지 않으시면 설정에서 언제든지 변경할 수 있습니다.',
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _requestPermissionsAndNavigate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 모서리 반경 10
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 각 권한 항목을 만드는 위젯
  Widget _buildPermissionItem({
    required String emoji,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  height: 22 / 16, // 행간 22px
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
