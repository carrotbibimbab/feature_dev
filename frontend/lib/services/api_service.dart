// lib/services/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/services/supabase_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://backend-6xc5.onrender.com',
    connectTimeout: const Duration(seconds: 120), // AI 분석 시간 고려
    receiveTimeout: const Duration(seconds: 120),
  ));

  /// Authorization 토큰 설정
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    print('🔐 API 토큰 설정 완료');
  }

  /// Supabase에서 자동으로 토큰 가져와서 설정
  Future<void> _ensureAuth() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    // Supabase의 access token을 백엔드 API에 사용
    final session = SupabaseConfig.client.auth.currentSession;
    if (session != null) {
      setAuthToken(session.accessToken);
    }
  }

  /// 종합 AI 분석 요청 (화면 14 → 화면 16)
  Future<AnalysisResult> analyzeImageComprehensive(
    File imageFile, {
    String? concerns, // 피부 고민 (선택)
  }) async {
    try {
      // 인증 확인
      await _ensureAuth();

      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        if (concerns != null) "concerns": concerns,
      });

      print('🚀 AI 분석 요청 시작...');
      
      final response = await _dio.post(
        '/api/v1/analysis/comprehensive',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('✅ 분석 완료: ${response.statusCode}');

      if (response.statusCode == 200) {
        // 🎯 백엔드가 프론트엔드 형식으로 바로 반환!
        // 변환 작업 없이 바로 파싱
        return AnalysisResult.fromJson(response.data);
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ 분석 에러: ${e.message}');
      if (e.response != null) {
        print('   응답 데이터: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// 분석 히스토리 조회
  Future<List<AnalysisResult>> getAnalysisHistory({int limit = 10}) async {
    try {
      await _ensureAuth();

      final response = await _dio.get(
        '/api/v1/analysis/history',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        // 배열이 직접 반환됨
        final List data = response.data as List;
        return data.map((item) => AnalysisResult.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print('❌ 히스토리 조회 에러: $e');
      return [];
    }
  }

  /// 특정 분석 결과 조회
  Future<AnalysisResult?> getAnalysisById(String analysisId) async {
    try {
      await _ensureAuth();

      final response = await _dio.get('/api/v1/analysis/$analysisId');

      if (response.statusCode == 200) {
        
        return AnalysisResult.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('❌ 분석 조회 에러: $e');
      return null;
    }
  }

  /// AI 서비스 상태 확인
  Future<bool> checkAIServiceHealth() async {
    try {
      final response = await _dio.get('/api/v1/analysis/health');
      return response.data['status'] == 'ok' || response.data['status'] == 'healthy';
    } catch (e) {
      print('❌ 헬스체크 에러: $e');
      return false;
    }
  }
}