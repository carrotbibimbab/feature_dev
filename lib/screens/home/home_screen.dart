// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dataService = SupabaseDataService();
  String _userName = '사용자';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final profile = await _dataService.getCurrentUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _userName = profile.name;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('링크를 열 수 없습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메인 콘텐츠
          SafeArea(
            bottom: false,
            child: ListView( // 화면이 작을 경우를 대비해 스크롤이 가능한 ListView 사용
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 20),

                // 상단 로고
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/7/mini_logo.png',
                    width: 35,
                    height: 40,
                  ),
                ),

                const SizedBox(height: 15),

                // 환영 메시지
                Padding(
                  padding: const EdgeInsets.only(left: 11.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 22,
                        height: 1.4,
                        color: Color(0xFF000000),
                      ),
                      children: [
                        // 2. 환영 메시지 두 줄 및 스타일 적용
                        TextSpan(
                          text: '$_userName님,\n',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '오늘의 피부 컨디션', // 강조할 부분
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // 굵은 글씨
                            color: Color(0xFFC6091D),     // 요청하신 색상
                          ),
                        ),
                        const TextSpan(
                          text: '을 확인해볼까요? 👀', // 나머지 텍스트
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // AI 분석 버튼
                GestureDetector(
                  onTap: () => context.go('/analysis-start'),
                  child: Image.asset(
                    'assets/7/button_analyzation.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                const SizedBox(height: 16), // 3. 여백 축소

                // 솔루션 안내 문구
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                      children: [
                        TextSpan(
                          text: '내 피부를 더 건강하게, ',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: '뷰파가 제안하는 솔루션🌸',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE8B7D4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12), // 3. 여백 축소

                // 가로 스크롤 카드
                SizedBox(
                  height: 267,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 4.0),
                    children: [
                      _buildScrollCard(
                        imagePath: 'assets/7/button_latelyanalysis.png',
                        onTap: () => context.go('/latest-analysis'),
                      ),
                      const SizedBox(width: 8),
                      _buildScrollCard(
                        imagePath: 'assets/7/button_analysislog.png',
                        onTap: () => context.go('/analysis-log'),
                      ),
                      const SizedBox(width: 8),
                      _buildScrollCard(
                        imagePath: 'assets/7/button_introbf.png',
                        onTap: () => context.go('/intro'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // 하단 네비게이션 바와의 공간 확보
              ],
            ),
          ),

          // 1. 하단 네비게이션 바 (초기 PNG 형태로 원복)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 배경 이미지
                Image.asset(
                  'assets/7/rectangle.png',
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  fit: BoxFit.fill,
                ),
                // 버튼들
                Positioned(
                  top: 13,
                  child: Row(
                    children: [
                      _buildNavButton('assets/7/main_home.png', () {}),
                      const SizedBox(width: 11),
                      _buildNavButton('assets/7/main_community.png',
                          () => _launchURL('https://cafe.naver.com/urbeautyfinder')),
                      const SizedBox(width: 11),
                      _buildNavButton('assets/7/main_chatbot.png',
                          () => _launchURL('http://pf.kakao.com/_izDxcn')),
                      const SizedBox(width: 11),
                      _buildNavButton('assets/7/main_mypage.png', () => context.go('/mypage')),
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

  // 가로 스크롤 카드 빌더
  Widget _buildScrollCard({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: 269,
        height: 267,
      ),
    );
  }

  // 하단 네비게이션 버튼 빌더
  Widget _buildNavButton(String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: 82.5,
        height: 64,
      ),
    );
  }
}