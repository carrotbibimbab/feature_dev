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

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('yyyy년 M월 d일 (E) HH:mm', 'ko_KR');
    return dateFormat.format(dateTime);
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 55),

                // Back 버튼
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: GestureDetector(
                    onTap: () => context.pop(),
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

                const SizedBox(height: 32),

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
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 100, // 네비게이션 바 공간
                              ),
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

            // 하단 네비게이션 바
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 이미지 (TODO: 실제 분석 이미지 URL 사용)
                Container(
                  width: 77,
                  height: 77,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 16),

                // 정보
                Column(
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
                        // 퍼스널 컬러 태그
                        if (log.personalColor != null)
                          _buildHashTag(
                            PersonalColorType.toHashtag(log.personalColor!),
                          ),
                        // 피부 타입 태그
                        if (log.detectedSkinType != null)
                          _buildHashTag(
                            SkinType.toHashtag(log.detectedSkinType!),
                          ),
                      ],
                    ),
                  ],
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

  Widget _buildBottomNavigationBar() {
    return Positioned(
      left: -13,
      bottom: 0,
      child: Stack(
        children: [
          Image.asset(
            'assets/7/rectangle.png',
            width: 419,
            height: 90,
          ),
          Positioned(
            left: 29,
            top: 13,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Image.asset(
                    'assets/7/main_home.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
                GestureDetector(
                  onTap: () =>
                      _launchURL('https://cafe.naver.com/urbeautyfinder'),
                  child: Image.asset(
                    'assets/7/main_community.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
                GestureDetector(
                  onTap: () => _launchURL('http://pf.kakao.com/_izDxcn'),
                  child: Image.asset(
                    'assets/7/main_chatbot.png',
                    width: 82.5,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 11),
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
    );
  }
}
