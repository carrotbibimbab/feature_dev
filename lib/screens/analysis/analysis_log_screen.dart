// lib/screens/analysis/analysis_log_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AnalysisLogScreen extends StatefulWidget {
  const AnalysisLogScreen({super.key});

  @override
  State<AnalysisLogScreen> createState() => _AnalysisLogScreenState();
}

class _AnalysisLogScreenState extends State<AnalysisLogScreen> {
  final _dataService = SupabaseDataService();
  List<AnalysisResult> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _dataService.getAnalysisLogs(limit: 50);
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
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

  String _getDayOfWeek(DateTime dateTime) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[dateTime.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, // 하단 네비게이션 바가 SafeArea를 무시하도록 설정
        child: Column( // ⭐ Stack 대신 Column으로 전체 구조 변경
          children: [
            Expanded( // ⭐ 스크롤 가능한 영역을 Expanded로 감싸서 남은 공간을 모두 차지하게 함
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // 1. 상단 여백 축소

                  // Back 버튼
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Image.asset(
                        'assets/8/Back.png',
                        width: 59,
                        height: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 제목
                  const Padding(
                    padding: EdgeInsets.only(left: 29),
                    child: Text(
                      '나의 분석 로그🌷',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // 1. 여백 축소

                  // 스크롤 가능한 로그 리스트
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _logs.isEmpty
                            ? const Center(
                                child: Text(
                                  '분석 기록이 없습니다.',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: _logs.length,
                                separatorBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 14),
                                      Image.asset(
                                        'assets/9/divider.png',
                                        width: 374.01,
                                        height: 1,
                                      ),
                                      const SizedBox(height: 14),
                                    ],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  final log = _logs[index];
                                  return _buildLogItem(log);
                                },
                              ),
                  ),
                ],
              ),
            ),
            
            // 2. 하단 네비게이션 바 (화면 맨 아래에 고정)
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(AnalysisResult log) {
    return GestureDetector(
      onTap: () => context.push('/analysis-result', extra: log),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 박스
          Image.asset(
            'assets/9/listbox.png',
            width: 373,
            height: 103,
          ),
          // 내용
          Positioned(
            left: 13,
            top: 13,
            right: 13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 이미지
                Container(
                  width: 77,
                  height: 77,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    image: log.imageId != null
                        ? DecorationImage(
                            // TODO: Supabase Storage에서 이미지 URL 가져오는 로직 필요
                            image: NetworkImage('YOUR_IMAGE_BASE_URL/${log.imageId}'),
                            fit: BoxFit.cover)
                        : null,
                  ),
                  child: log.imageId == null
                      ? const Icon(Icons.image, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 날짜 및 시간
                      Text(
                        log.createdAt != null
                            ? '${log.createdAt!.year}년 ${log.createdAt!.month}월 ${log.createdAt!.day}일 (${_getDayOfWeek(log.createdAt!)}) ${log.createdAt!.hour.toString().padLeft(2, '0')}:${log.createdAt!.minute.toString().padLeft(2, '0')}'
                            : '날짜 없음',
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 해시태그
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (log.personalColor != null)
                            _buildHashTag(
                              PersonalColorType.toHashtag(log.personalColor!),
                            ),
                          if (log.detectedSkinType != null)
                            _buildHashTag(
                              SkinType.toHashtag(log.detectedSkinType!),
                            ),
                        ],
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

  Widget _buildHashTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC6091D),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  // 하단 네비게이션 바 위젯 (홈 화면과 동일한 구조)
  Widget _buildBottomNavigationBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/7/rectangle.png',
          width: MediaQuery.of(context).size.width,
          height: 90,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: 13,
          child: Row(
            children: [
              _buildNavButton('assets/7/main_home.png', () => context.go('/home')),
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