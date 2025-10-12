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
      body: SafeArea(
        child: Stack(
          children: [
            // 메인 콘텐츠
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64.59),

                  // 상단 로고
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Image.asset(
                      'assets/7/mini_logo.png',
                      width: 35,
                      height: 40,
                    ),
                  ),

                  const SizedBox(height: 11.41),

                  // 환영 메시지
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 20,
                          height: 35 / 20,
                        ),
                        children: [
                          TextSpan(
                            text: '$_userName님,\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const TextSpan(
                            text: '오늘의 피부 컨디션',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC6091D),
                            ),
                          ),
                          const TextSpan(
                            text: '을\n확인해볼까요? 👀',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // AI 분석 버튼
                  Padding(
                    padding: const EdgeInsets.only(left: 27),
                    child: GestureDetector(
                      onTap: () => context.go('/analysis-start'),
                      child: Image.asset(
                        'assets/7/button_analyzation.png',
                        width: 340.16,
                        height: 166,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 솔루션 안내 문구
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'NanumSquareNeo',
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: '내 피부를 더 건강하게, ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000),
                            ),
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

                  const SizedBox(height: 16),

                  // 가로 스크롤 카드
                  SizedBox(
                    height: 267,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 28),
                      children: [
                        _buildScrollCard(
                          imagePath: 'assets/7/button_latelyanalysis.png',
                          onTap: () => context.go('/latest-analysis'),
                        ),
                        const SizedBox(width: 26),
                        _buildScrollCard(
                          imagePath: 'assets/7/button_analysislog.png',
                          onTap: () => context.go('/analysis-log'),
                        ),
                        const SizedBox(width: 26),
                        _buildScrollCard(
                          imagePath: 'assets/7/button_introbf.png',
                          onTap: () => context.go('/intro'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // 네비게이션 바 공간
                ],
              ),
            ),

            // 하단 네비게이션 바
            Positioned(
              left: -13,
              bottom: 0,
              child: Stack(
                children: [
                  // 배경
                  Image.asset(
                    'assets/7/rectangle.png',
                    width: 419,
                    height: 90,
                  ),

                  // 버튼들
                  Positioned(
                    left: 29,
                    top: 13,
                    child: Row(
                      children: [
                        // 홈
                        GestureDetector(
                          onTap: () {}, // 현재 페이지
                          child: Image.asset(
                            'assets/7/main_home.png',
                            width: 82.5,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 11),
                        // 커뮤니티
                        GestureDetector(
                          onTap: () => _launchURL(
                              'https://cafe.naver.com/urbeautyfinder'),
                          child: Image.asset(
                            'assets/7/main_community.png',
                            width: 82.5,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 11),
                        // 챗봇
                        GestureDetector(
                          onTap: () =>
                              _launchURL('http://pf.kakao.com/_izDxcn'),
                          child: Image.asset(
                            'assets/7/main_chatbot.png',
                            width: 82.5,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 11),
                        // 마이페이지
                        GestureDetector(
                          onTap: () => context.go('/mypage'),
                          child: Image.asset(
                            'assets/7/main_mypage.png',
                            width: 82.5,
                            height: 64,
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
      ),
    );
  }

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
}
