// lib/screens/analysis/analysis_result_screen.dart
import 'package:flutter/material.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

class AnalysisResultScreen extends StatefulWidget {
  final AnalysisResult result;

  const AnalysisResultScreen({super.key, required this.result});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final _dataService = SupabaseDataService();
  final _screenshotController = ScreenshotController();
  String _userName = '사용자';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _saveAnalysis();
  }

  Future<void> _loadUserName() async {
    final profile = await _dataService.getCurrentUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _userName = profile.name;
      });
    }
  }

  Future<void> _saveAnalysis() async {
    await _dataService.saveAnalysisResult(widget.result);
  }

  Future<void> _handleDownload() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('분석 결과가 저장되었습니다.')),
      );
    }
  }

  Future<void> _handleShare() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      await Share.shareXFiles(
        [XFile.fromData(image, mimeType: 'image/png')],
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Screenshot(
        controller: _screenshotController,
        child: Column(
          children: [
            _buildFixedHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildScrollableContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 1. 고정 헤더 - 적절한 높이
  Widget _buildFixedHeader() {
    return SizedBox(
      height: 210, // ✅ 180 → 210 (적당한 높이)
      child: Stack(
        children: [
          // 배경 이미지 (비율 유지하며 크롭)
          Positioned.fill(
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/17/background3.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 어두운 오버레이
          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),

          // 상단 버튼들
          Positioned(
            top: 50, // ✅ 63 → 50
            right: 24,
            child: Row(
              children: [
                // 저장
                GestureDetector(
                  onTap: _handleDownload,
                  child: Image.asset(
                    'assets/17/button_download.png',
                    width: 20,
                    height: 20.11,
                  ),
                ),
                const SizedBox(width: 17),
                // 공유
                GestureDetector(
                  onTap: _handleShare,
                  child: Image.asset(
                    'assets/17/button_share.png',
                    width: 21.03,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 17),
                // 닫기
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Image.asset(
                    'assets/17/button_close.png',
                    width: 21,
                    height: 21,
                  ),
                ),
              ],
            ),
          ),

          // ✅ 2. 제목 - 두 줄로 변경
          Positioned(
            left: 24,
            top: 90, // ✅ 106 → 90
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontSize: 36,
                  height: 1.2, // ✅ 줄 간격 조정
                  letterSpacing: 1.5,
                  shadows: [
                    // ✅ 그림자 효과 추가
                    Shadow(
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
                children: [
                  TextSpan(
                    text: '$_userName님의\n', // ✅ 줄바꿈 추가
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const TextSpan(
                    text: '분석 결과',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 스크롤 가능한 콘텐츠
  Widget _buildScrollableContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30), // ✅ 20 → 30
          _buildPersonalColorSection(),
          const SizedBox(height: 50), // ✅ 40 → 50
          _buildSkinTypeSection(),
          const SizedBox(height: 50), // ✅ 40 → 50
          _buildSensitivitySection(),
          const SizedBox(height: 50), // ✅ 40 → 50
          _buildDetailedAnalysisSection(),
          const SizedBox(height: 50), // ✅ 40 → 50
          _buildSkincareRoutineSection(),
          const SizedBox(height: 50), // ✅ 40 → 50
          _buildBottomButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ✅ 3. 퍼스널 컬러 섹션 - 왼쪽 여백 추가
  Widget _buildPersonalColorSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12), // ✅ 왼쪽 여백
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontSize: 20,
                letterSpacing: 0.11,
              ),
              children: [
                TextSpan(
                  text: '🎨 나의 ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                TextSpan(
                  text: '퍼스널 컬러',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC6091D),
                  ),
                ),
                TextSpan(
                  text: '는...',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Image.asset(
              PersonalColorType.getImagePath(widget.result.personalColor ?? ''),
              width: 250,
              height: 296,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '📝 특징',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.11,
            ),
          ),

          const SizedBox(height: 12),

          if (widget.result.personalColorDescription != null)
            _buildBulletPoints(widget.result.personalColorDescription!),

          const SizedBox(height: 30),

          const Text(
            '✨ 인생 컬러 팔레트',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.11,
            ),
          ),

          const SizedBox(height: 20),

          // BEST 팔레트
          Stack(
            children: [
              Image.asset(
                'assets/17/palette_best.png',
                width: 337,
                height: 122,
              ),
              Positioned(
                left: 30,
                top: 50,
                child: Row(
                  children: widget.result.bestColors?.take(4).map((color) {
                        return Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 12),
                          color: _parseColor(color),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // WORST 팔레트
          Stack(
            children: [
              Image.asset(
                'assets/17/palette_worst.png',
                width: 337,
                height: 122,
              ),
              Positioned(
                left: 30,
                top: 50,
                child: Row(
                  children: widget.result.worstColors?.take(4).map((color) {
                        return Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 12),
                          color: _parseColor(color),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ 피부 타입 섹션 - 왼쪽 여백 추가
  Widget _buildSkinTypeSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12), // ✅ 왼쪽 여백
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontSize: 20,
                letterSpacing: 0.11,
              ),
              children: [
                TextSpan(
                  text: '💆 나의 ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                TextSpan(
                  text: '피부 타입',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC6091D),
                  ),
                ),
                TextSpan(
                  text: '은...',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Image.asset(
              SkinType.getImagePath(widget.result.detectedSkinType ?? ''),
              width: 250,
              height: 296,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '📝 특징',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.11,
            ),
          ),

          const SizedBox(height: 12),

          if (widget.result.skinTypeDescription != null)
            _buildBulletPoints(widget.result.skinTypeDescription!),
        ],
      ),
    );
  }

  Widget _buildSensitivitySection() {
  return Padding(
    padding: const EdgeInsets.only(left: 12), // ✅ Padding 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ 왼쪽 정렬 추가
      children: [
        const Text(
          '🚨 민감성 위험도 게이지',
          style: TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.11,
          ),
        ),

        const SizedBox(height: 20),

        Center( // ✅ 이미지만 가운데
          child: Image.asset(
            SensitivityLevel.getImagePath(
                widget.result.sensitivityLevel ?? 'moderate'),
            width: 218,
            height: 141,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(right: 12), // ✅ 오른쪽 여백
          child: Text(
            _getSensitivityDescription(),
            textAlign: TextAlign.left, // ✅ 왼쪽 정렬
            style: const TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontSize: 15,
              height: 18 / 15,
            ),
          ),
        ),
      ],
    ),
  );
}

  // ✅ 4. 피부 상세 분석 섹션 - 왼쪽 여백, 가운데 정렬, 점수 위치 수정
  Widget _buildDetailedAnalysisSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12), // ✅ 왼쪽 여백
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👁️‍🗨️ 피부 상세 분석',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.11,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/pb_mogong.png',
            '모공',
            widget.result.poreScore ?? 0,
            widget.result.poreDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/pb_wrinkle.png',
            '주름',
            widget.result.wrinkleScore ?? 0,
            widget.result.wrinkleDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/pb_tan.png',
            '탄력',
            widget.result.elasticityScore ?? 0,
            widget.result.elasticityDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/pb_pimple.png',
            '여드름',
            widget.result.acneScore ?? 0,
            widget.result.acneDescription,
          ),
        ],
      ),
    );
  }

  // ✅ 상세 분석 아이템 - 게이지 오른쪽, 0/100 아래, 점수 작게, 설명 왼쪽 정렬
  Widget _buildDetailItem(
      String imagePath, String label, int score, String? description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ 왼쪽 정렬
      children: [
        // ✅ 네모 박스 가운데 정렬
        Center(
          child: SizedBox(
            width: 337,
            height: 85,
            child: Stack(
              children: [
                Image.asset(imagePath, width: 337, height: 85),

                // ✅ Progress bar - 오른쪽으로 이동
                Positioned(
                  left: 100, // ✅ 68.5 → 80 (오른쪽으로)
                  top: 32,
                  child: Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: score / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8B7D4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ 점수 텍스트 - 크기 줄임
                Positioned(
                  left: 80 + (200 * score / 100) - 8,
                  top: 12, // ✅ 게이지 위
                  child: Text(
                    '$score',
                    style: const TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // ✅ 16 → 14 (작게)
                      color: Color(0xFFE8B7D4),
                    ),
                  ),
                ),

                // ✅ 0, 100 표시 - 게이지 아래로
                const Positioned(
                  left: 100,
                  top: 54, // 
                  child: Text('0', style: TextStyle(fontSize: 11)),
                ),
                const Positioned(
                  left: 280, // ✅ 80 + 200 - 10
                  top: 54, // ✅ 아래쪽
                  child: Text('100', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // ✅ 설명 부분 - 왼쪽 정렬
        Padding(
          padding: const EdgeInsets.only(left: 16), // ✅ 왼쪽 여백만
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontSize: 12,
                height: 20 / 12,
              ),
              children: [
                TextSpan(
                  text: '점수: $score/100\n',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: description ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 스킨케어 루틴 섹션 - 왼쪽 여백
  Widget _buildSkincareRoutineSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12), // ✅ 왼쪽 여백
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💧 핵심 솔루션: 스킨케어 루틴',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 0.11,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.result.skincareRoutine != null)
            ...widget.result.skincareRoutine!.map((step) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontSize: 15,
                      height: 18 / 15,
                    ),
                    children: [
                      TextSpan(
                        text: '• ${step.type}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: step.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => context.go('/analysis-start'),
          child: Image.asset(
            'assets/17/button_reanalyze.png',
            width: 145,
            height: 145,
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/analysis-log'),
          child: Image.asset(
            'assets/17/button_log.png',
            width: 145,
            height: 145,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoints(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'NanumSquareNeo',
        fontSize: 15,
        height: 18 / 15,
      ),
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  String _getSensitivityDescription() {
    switch (widget.result.sensitivityLevel) {
      case 'high':
        return '피부가 매우 민감한 상태입니다. 순한 제품을 사용하고, 새로운 제품은 반드시 테스트 후 사용하세요.';
      case 'caution':
        return '피부가 다소 민감합니다. 자극적인 성분은 피하고, 진정 효과가 있는 제품을 사용하세요.';
      case 'moderate':
        return '보통 수준의 민감도입니다. 일반적인 제품 사용이 가능하나, 피부 상태를 주의 깊게 관찰하세요.';
      case 'low':
        return '민감도가 낮은 편입니다. 다양한 제품 사용이 가능하지만, 과도한 자극은 피하세요.';
      default:
        return '피부 상태가 안정적입니다. 현재 루틴을 유지하세요.';
    }
  }
}