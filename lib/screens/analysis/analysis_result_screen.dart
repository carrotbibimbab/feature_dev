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

  // ✅ 고정 헤더
  Widget _buildFixedHeader() {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
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
          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),
          Positioned(
            top: 50,
            right: 24,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _handleDownload,
                  child: Image.asset(
                    'assets/17/button_download.png',
                    width: 20,
                    height: 20.11,
                  ),
                ),
                const SizedBox(width: 17),
                GestureDetector(
                  onTap: _handleShare,
                  child: Image.asset(
                    'assets/17/button_share.png',
                    width: 21.03,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 17),
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
          Positioned(
            left: 24,
            top: 90,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'NanumSquareNeo',
                  fontSize: 36,
                  height: 1.2,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
                children: [
                  TextSpan(
                    text: '$_userName님의\n',
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

  // ✅ 스크롤 가능한 콘텐츠
  Widget _buildScrollableContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          
          // ✅ 1. 사용 안내
          _buildUsageGuide(),
          const SizedBox(height: 40),
          
          // ✅ 2. 분석 결과 섹션 헤더
          _buildSectionHeader('📊', '분석 결과'),
          const SizedBox(height: 20),
          
          // ✅ 3. 종합 민감도
          _buildSensitivitySection(),
          const SizedBox(height: 40),
          
          // ✅ 4. 상세 지표 (4가지)
          _buildSectionHeader('📊', '상세 지표'),
          const SizedBox(height: 20),
          _buildDetailedAnalysisSection(),
          const SizedBox(height: 40),
          
          // ✅ 5. 맞춤 케어 루틴
          _buildSectionHeader('🧴', '맞춤 케어 루틴'),
          const SizedBox(height: 12),
          _buildSkincareRoutineSection(),
          const SizedBox(height: 40),
          
          // ✅ 6. AI 뷰티 가이드
          _buildSectionHeader('🤖', 'AI 뷰티 가이드'),
          const SizedBox(height: 12),
          _buildAIGuide(),
          const SizedBox(height: 40),
          
          // ✅ 7. 종합 평가
          _buildSectionHeader('💎', '종합 평가'),
          const SizedBox(height: 12),
          _buildComprehensiveEvaluation(),
          const SizedBox(height: 40),
          
          // ✅ 8. 피부 상태 상세 분석
          _buildSectionHeader('🔬', '피부 상태 상세 분석'),
          const SizedBox(height: 12),
          _buildDetailedSkinAnalysis(),
          const SizedBox(height: 40),
          
          // ✅ 9. 추천 성분
          _buildSectionHeader('✏️', '추천 성분'),
          const SizedBox(height: 12),
          _buildRecommendedIngredients(),
          const SizedBox(height: 40),
          
          // ✅ 10. 생활습관 조언
          _buildSectionHeader('🌱', '생활습관 조언'),
          const SizedBox(height: 12),
          _buildLifestyleAdvice(),
          const SizedBox(height: 40),
          
          // ✅ 11. 주의사항
          _buildSectionHeader('⚠️', '주의사항'),
          const SizedBox(height: 12),
          _buildPrecautions(),
          const SizedBox(height: 40),
          
          // ✅ 12. 전문가 조언
          _buildSectionHeader('💡', '전문가 조언'),
          const SizedBox(height: 12),
          _buildExpertAdvice(),
          const SizedBox(height: 50),
          
          // ✅ 13. 하단 버튼
          _buildBottomButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ✅ 섹션 헤더 빌더
  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        '$emoji $title',
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 0.11,
        ),
      ),
    );
  }

  // ✅ 1. 사용 안내
  Widget _buildUsageGuide() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFFC6091D)),
                const SizedBox(width: 8),
                const Text(
                  '사용 안내',
                  style: TextStyle(
                    fontFamily: 'NanumSquareNeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBulletPoint('정면 얼굴 사진을 업로드하세요'),
            _buildBulletPoint('분석에 약 30-60초 소요됩니다'),
            _buildBulletPoint('결과는 개인 맞춤 가이드로 제공됩니다'),
          ],
        ),
      ),
    );
  }

  // ✅ 2. 종합 민감도
  Widget _buildSensitivitySection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🟡 종합 민감도',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.11,
            ),
          ),
          const SizedBox(height: 16),
          
          // 점수 표시
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '점수:',
                      style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${(widget.result.sensitivityScore ?? 0) * 10}/100',
                      style: const TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xFFC6091D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '레벨:',
                      style: TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getSensitivityLevelKorean(),
                      style: const TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 게이지 이미지
          Center(
            child: Image.asset(
              SensitivityLevel.getImagePath(
                widget.result.sensitivityLevel ?? 'medium',
              ),
              width: 218,
              height: 141,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 설명
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              _getSensitivityDescription(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 3. 상세 지표 (기존 코드)
  Widget _buildDetailedAnalysisSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
            'assets/17/box_dryness.png',
            '건조도',
            widget.result.drynessScore ?? 0,
            widget.result.drynessDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/box_sexo.png',
            '색소침착',
            widget.result.pigmentationScore ?? 0,
            widget.result.pigmentationDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/box_mogong.png',
            '모공',
            widget.result.poreScore ?? 0,
            widget.result.poreDescription,
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            'assets/17/box_tan.png',
            '탄력',
            widget.result.elasticityScore ?? 0,
            widget.result.elasticityDescription,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      String imagePath, String label, int score, String? description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 337,
            height: 85,
            child: Stack(
              children: [
                Image.asset(imagePath, width: 337, height: 85),
                Positioned(
                  left: 100,
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
                Positioned(
                  left: 100 + (200 * score / 100) - 8,
                  top: 12,
                  child: Text(
                    '$score',
                    style: const TextStyle(
                      fontFamily: 'NanumSquareNeo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFFE8B7D4),
                    ),
                  ),
                ),
                const Positioned(
                  left: 100,
                  top: 54,
                  child: Text('0', style: TextStyle(fontSize: 11)),
                ),
                const Positioned(
                  left: 280,
                  top: 54,
                  child: Text('100', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            description ?? '상태가 양호합니다.',
            style: const TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 4. 스킨케어 루틴 (기존 코드 개선)
  Widget _buildSkincareRoutineSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아침 루틴
          const Text(
            '아침 루틴',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.result.skincareRoutine != null)
            ...widget.result.skincareRoutine!
                .where((step) => step.step <= 5)
                .map((step) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${step.step}. ',
                      style: const TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'NanumSquareNeo',
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '${step.type}: ',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: step.description,
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          
          const SizedBox(height: 24),
          
          // 저녁 루틴
          const Text(
            '저녁 루틴',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.result.skincareRoutine != null)
            ...widget.result.skincareRoutine!
                .where((step) => step.step > 5)
                .map((step) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${step.step - 5}. ',
                      style: const TextStyle(
                        fontFamily: 'NanumSquareNeo',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'NanumSquareNeo',
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '${step.type}: ',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: step.description,
                              style: const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ✅ 5. AI 뷰티 가이드
  Widget _buildAIGuide() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Text(
        _getAIGuideText(),
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  // ✅ 6. 종합 평가
  Widget _buildComprehensiveEvaluation() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Text(
        _getComprehensiveEvaluation(),
        style: const TextStyle(
          fontFamily: 'NanumSquareNeo',
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  // ✅ 7. 피부 상태 상세 분석
  Widget _buildDetailedSkinAnalysis() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalysisItem(
            '민감도 (${(widget.result.sensitivityScore ?? 0) * 10}/100)',
            _getSensitivityDetailAnalysis(),
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            '건조도 (${widget.result.drynessScore}/100)',
            widget.result.drynessDescription ?? '',
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            '색소침착 (${widget.result.pigmentationScore}/100)',
            widget.result.pigmentationDescription ?? '',
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            '모공 (${widget.result.poreScore}/100)',
            widget.result.poreDescription ?? '',
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            '탄력 (${widget.result.elasticityScore}/100)',
            widget.result.elasticityDescription ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '○ $title',
          style: const TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ✅ 8. 추천 성분
  Widget _buildRecommendedIngredients() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint('비타민 C: 색소 침착 개선과 피부 톤을 고르게 해줍니다.'),
          _buildBulletPoint('히알루론산: 피부에 수분을 공급하고 보습 장벽을 강화합니다.'),
          _buildBulletPoint('판테놀: 피부 진정과 회복을 도와줍니다.'),
          _buildBulletPoint('AHA/BHA: 각질 제거와 모공 관리에 도움을 줍니다.'),
        ],
      ),
    );
  }

  // ✅ 9. 생활습관 조언
  Widget _buildLifestyleAdvice() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint('수면: 충분한 수면(7-8시간)을 취하여 피부 회복을 도와주세요.'),
          _buildBulletPoint('식습관: 항산화 성분이 풍부한 과일과 채소를 섭취하여 피부 건강을 유지합니다.'),
          _buildBulletPoint('환경: 자외선이 강한 시간대에 외출 시에는 반드시 자외선 차단제를 사용하세요.'),
        ],
      ),
    );
  }

  // ✅ 10. 주의사항
  Widget _buildPrecautions() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint('자극이 강한 제품(예: 알코올, 향료 등)은 피하는 것이 좋습니다.'),
          _buildBulletPoint('급심한 피부 자극이나 트러블이 발생할 경우 즉시 피부과 전문의와 상담하세요.'),
        ],
      ),
    );
  }

  // ✅ 11. 전문가 조언
  Widget _buildExpertAdvice() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8B7D4), width: 2),
        ),
        child: Text(
          '민감한 피부는 자극을 최소화하는 것이 핵심입니다. 성분을 꼼꼼히 확인하고, 피부 반응에 따라 제품을 조정하는 것이 중요합니다. 필요시 전문가의 도움을 받는 것도 고려해보세요.',
          style: const TextStyle(
            fontFamily: 'NanumSquareNeo',
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ✅ 하단 버튼
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

  // ✅ 헬퍼 함수들
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '○ ',
            style: TextStyle(
              fontFamily: 'NanumSquareNeo',
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'NanumSquareNeo',
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSensitivityLevelKorean() {
    switch (widget.result.sensitivityLevel?.toLowerCase()) {
      case 'low':
        return 'LOW (양호)';
      case 'medium':
        return 'MEDIUM (보통)';
      case 'high':
        return 'HIGH (주의)';
      default:
        return 'MEDIUM';
    }
  }

  String _getSensitivityDescription() {
    switch (widget.result.sensitivityLevel?.toLowerCase()) {
      case 'high':
        return '피부가 매우 민감한 상태입니다. 순한 제품을 사용하고, 새로운 제품은 반드시 테스트 후 사용하세요.';
      case 'medium':
        return '보통 수준의 민감도입니다. 일반적인 제품 사용이 가능하나, 피부 상태를 주의 깊게 관찰하세요.';
      case 'low':
        return '민감도가 낮은 편입니다. 다양한 제품 사용이 가능하지만, 과도한 자극은 피하세요.';
      default:
        return '피부 상태가 안정적입니다. 현재 루틴을 유지하세요.';
    }
  }

  String _getSensitivityDetailAnalysis() {
    final score = (widget.result.sensitivityScore ?? 0) * 10;
    if (score >= 70) {
      return '현재 민감도가 중간에 해당하며, 외부 자극에 대한 반응이 있을 수 있습니다. 자극을 줄이기 위해 순한 성분의 제품을 사용하는 것이 좋습니다.';
    } else if (score >= 40) {
      return '현재 민감도가 보통 수준입니다. 일반적인 제품 사용이 가능하나 새로운 제품 사용 시 주의가 필요합니다.';
    } else {
      return '현재 민감도가 낮은 편입니다. 대부분의 제품을 안전하게 사용할 수 있습니다.';
    }
  }

  String _getAIGuideText() {
    final level = widget.result.sensitivityLevel?.toLowerCase() ?? 'medium';
    if (level == 'high') {
      return '현재 피부 상태는 민감도가 중간 수준으로 나타나며, 건조도는 낮은 반면 색소침착과 모공은 다소 높은 수치를 보입니다. 탄력은 좋은 편이지만, 민감한 피부 특성을 고려하여 세심한 스킨케어가 필요합니다.';
    } else if (level == 'medium') {
      return '현재 피부 상태는 전반적으로 양호한 편이나, 일부 개선이 필요한 부분이 있습니다. 꾸준한 관리로 더 건강한 피부를 유지할 수 있습니다.';
    } else {
      return '현재 피부 상태가 매우 양호합니다. 현재의 스킨케어 루틴을 유지하면서 예방 관리에 집중하세요.';
    }
  }

  String _getComprehensiveEvaluation() {
    return '현재 피부 상태는 민감도가 중간 수준으로 나타나며, 건조도는 낮은 반면 색소침착과 모공은 다소 높은 수치를 보입니다. 탄력은 좋은 편이지만, 민감성을 감안할 때 적절한 관리가 필요합니다. 항산화 성분을 포함한 제품이 도움이 될 것입니다.';
  }
}