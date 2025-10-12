// lib/providers/analysis_provider.dart
import 'package:flutter/foundation.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/services/api_service.dart';
import 'package:bf_app/services/supabase_data_service.dart';
import 'dart:io';

class AnalysisProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SupabaseDataService _dataService = SupabaseDataService();

  // 상태
  bool _isAnalyzing = false;
  double _analysisProgress = 0.0;
  String _analysisStage = '';
  AnalysisResult? _latestResult;
  List<AnalysisResult> _analysisHistory = [];
  String? _error;

  // Getters
  bool get isAnalyzing => _isAnalyzing;
  double get analysisProgress => _analysisProgress;
  String get analysisStage => _analysisStage;
  AnalysisResult? get latestResult => _latestResult;
  List<AnalysisResult> get analysisHistory => _analysisHistory;
  String? get error => _error;

  /// 종합 분석 실행 (NIA + GPT 자동 생성)
  Future<AnalysisResult?> analyzeImage({
    required File imageFile,
    String? concerns,
  }) async {
    try {
      _isAnalyzing = true;
      _error = null;
      _analysisProgress = 0.0;
      notifyListeners();

      // 단계 1: 이미지 업로드 준비
      _updateProgress(0.1, '이미지 업로드 중...');

      // 단계 2: AI 분석 요청 (NIA + GPT 자동 생성)
      _updateProgress(0.2, 'AI 피부 분석 중...');
      
      final result = await _apiService.analyzeImageComprehensive(
        imageFile,
        concerns: concerns,
      );

      // 단계 3: GPT 가이드 생성 (백엔드에서 자동 처리)
      _updateProgress(0.7, '개인 맞춤 가이드 생성 중...');
      
      // 백엔드가 이미 GPT 가이드를 포함하여 반환했으므로
      // 추가 작업 없이 바로 사용 가능
      
      // 단계 4: 완료
      _updateProgress(1.0, '분석 완료!');

      _latestResult = result;
      _isAnalyzing = false;
      notifyListeners();

      return result;
    } catch (e) {
      _error = e.toString();
      _isAnalyzing = false;
      _analysisProgress = 0.0;
      _analysisStage = '';
      notifyListeners();
      
      print('❌ 분석 에러: $e');
      return null;
    }
  }

  /// 분석 진행 상태 업데이트
  void _updateProgress(double progress, String stage) {
    _analysisProgress = progress;
    _analysisStage = stage;
    notifyListeners();
  }

  /// 최근 분석 결과 불러오기
  Future<void> loadLatestAnalysis() async {
    try {
      final result = await _dataService.getLatestAnalysis();
      if (result != null) {
        _latestResult = result;
        notifyListeners();
      }
    } catch (e) {
      print('❌ 최근 분석 조회 에러: $e');
    }
  }

  /// 분석 히스토리 불러오기
  Future<void> loadAnalysisHistory({int limit = 50}) async {
    try {
      final history = await _dataService.getAnalysisLogs(limit: limit);
      _analysisHistory = history;
      notifyListeners();
    } catch (e) {
      print('❌ 히스토리 조회 에러: $e');
    }
  }

  /// 특정 분석 결과 조회
  Future<AnalysisResult?> getAnalysisById(String analysisId) async {
    try {
      return await _dataService.getAnalysisById(analysisId);
    } catch (e) {
      print('❌ 분석 조회 에러: $e');
      return null;
    }
  }

  /// GPT 가이드 데이터 추출 (rawAnalysisData에서)
  Map<String, dynamic>? getGptGuide(AnalysisResult result) {
    if (result.rawAnalysisData == null) return null;
    return result.rawAnalysisData!['gpt_guide'] as Map<String, dynamic>?;
  }

  /// GPT 요약 추출
  String? getGptSummary(AnalysisResult result) {
    final guide = getGptGuide(result);
    return guide?['summary'] as String?;
  }

  /// GPT 생활습관 조언 추출
  List<String>? getLifestyleTips(AnalysisResult result) {
    final guide = getGptGuide(result);
    final tips = guide?['lifestyle_tips'];
    if (tips is List) {
      return tips.map((e) => e.toString()).toList();
    }
    return null;
  }

  /// GPT 전문가 인사이트 추출
  String? getProfessionalInsight(AnalysisResult result) {
    final guide = getGptGuide(result);
    return guide?['professional_insight'] as String?;
  }

  /// 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _isAnalyzing = false;
    _analysisProgress = 0.0;
    _analysisStage = '';
    _error = null;
    notifyListeners();
  }
}