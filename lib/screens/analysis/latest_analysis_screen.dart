import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LatestAnalysisScreen extends StatefulWidget {
  const LatestAnalysisScreen({super.key});

  @override
  State<LatestAnalysisScreen> createState() => _LatestAnalysisScreenState();
}

class _LatestAnalysisScreenState extends State<LatestAnalysisScreen> {
  // TODO: 실제로는 Supabase에서 최근 분석 결과를 가져와야 함
  Map<String, dynamic>? _latestAnalysis;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLatestAnalysis();
  }

  Future<void> _loadLatestAnalysis() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Supabase에서 최근 분석 결과 가져오기
      // final result = await SupabaseDataService().getLatestAnalysis();
      
      await Future.delayed(const Duration(milliseconds: 500)); // 시뮬레이션
      
      setState(() {
        // _latestAnalysis = result;
        _latestAnalysis = null; // 임시로 null (데이터 없음)
        _isLoading = false;
      });
    } catch (e) {
      print('최근 분석 결과 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // ✅ Back 버튼
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
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
                ),
                
                const SizedBox(height: 20),
                
                // ✅ 제목
                const Padding(
                  padding: EdgeInsets.only(left: 29),
                  child: Text(
                    '최근 분석 결과 🔍',
                    style: TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 콘텐츠 영역
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState()
                      : _latestAnalysis == null
                          ? _buildEmptyState()
                          : _buildAnalysisResult(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 로딩 중
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xFFE8B7D4), // 핑크
        ),
      ),
    );
  }

  // ✅ 분석 기록 없음
  Widget _buildEmptyState() {
    return Column(
      children: [
        // 중앙 콘텐츠
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘
                Icon(
                  Icons.analytics_outlined,
                  size: 100,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 32),
                
                // 메인 메시지
                Text(
                  '분석 기록이 없습니다.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[700],
                    fontFamily: 'NanumSquareNeo',
                  ),
                ),
                const SizedBox(height: 16),
                
                // 서브 메시지
                Text(
                  'AI 분석을 시작해 보세요!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontFamily: 'NanumSquareNeo',
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // ✅ 하단 버튼
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // 분석 시작 화면으로 이동
                context.go('/analysis-start');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8B7D4), // 핑크
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                '분석 시작하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800, 
                  fontFamily: 'NanumSquareNeo',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 분석 결과 표시
  Widget _buildAnalysisResult() {
    return Column(
      children: [
        // 스크롤 가능한 콘텐츠
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 분석 날짜
                Text(
                  '분석 날짜: ${_latestAnalysis!['date']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'NanumSquareNeo',
                  ),
                ),
                const SizedBox(height: 20),
                
                // 퍼스널 컬러 카드
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _latestAnalysis!['colorChip'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _latestAnalysis!['personalColor'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // 상세 정보
                const Text(
                  '상세 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NanumSquareNeo',
                  ),
                ),
                const SizedBox(height: 12),
                
                Text(
                  '여기에 분석 결과 상세 정보가 표시됩니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'NanumSquareNeo',
                  ),
                ),
                const SizedBox(height: 80), // 하단 버튼 공간 확보
              ],
            ),
          ),
        ),
        
        // ✅ 하단 전체 결과 보기 버튼
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                // TODO: 전체 분석 결과 화면으로 이동
                // context.push('/analysis-result', extra: _latestAnalysis);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFFE8B7D4),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '전체 결과 보기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700, // ✅ Bold
                  color: Color(0xFFE8B7D4),
                  fontFamily: 'NanumSquareNeo',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}