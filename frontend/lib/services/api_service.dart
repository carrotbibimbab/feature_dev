// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';  
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';  
import 'package:bf_app/config/app_config.dart';  // 추가
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart'; 

class ApiService {
  static const String baseUrl = 'https://beautyfinder-l2pt.onrender.com';
  SupabaseClient get _supabase => SupabaseConfig.client;

  // 인증 토큰 가져오기
  Future<String?> _getAuthToken() async {
    final session = _supabase.auth.currentSession;
    return session?.accessToken;
  }

  // 인증 헤더 생성
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    
    if (token == null) {
      throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  // ────────────────────────────────────────────────────────────
  // 사용자 정보
  // ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/me'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('사용자 정보 가져오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API 에러: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('프로필 가져오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API 에러: $e');
      rethrow;
    }
  }
    

  /// 분석 히스토리 조회
    /// 종합 AI 분석 요청 (화면 14 → 화면 16)
  Future<AnalysisResult> analyzeImageComprehensive(
    File imageFile, {
    String? concerns,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('인증이 필요합니다.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/v1/analysis/comprehensive'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      String fileName = imageFile.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: fileName,
        ),
      );

      if (concerns != null) {
        request.fields['concerns'] = concerns;
      }

      print('🚀 AI 분석 요청 시작...');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('✅ 분석 완료: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AnalysisResult.fromJson(data);  // ⭐ Map을 AnalysisResult로 변환
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 분석 에러: $e');
      rethrow;
    }
  }

  /// 분석 히스토리 조회
  Future<List<AnalysisResult>> getAnalysisHistory({int limit = 10}) async {
    try {
      final headers = await _getHeaders();
      
      final uri = Uri.parse('$baseUrl/api/v1/analysis/history').replace(
        queryParameters: {'limit': limit.toString()},
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body) as List;
        return data.map((item) => AnalysisResult.fromJson(item)).toList();  // ⭐ 변환
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/analysis/$analysisId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AnalysisResult.fromJson(data);  // ⭐ 변환
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
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/analysis/health'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'ok' || data['status'] == 'healthy';
      }
      
      return false;
    } catch (e) {
      print('❌ 헬스체크 에러: $e');
      return false;
    }
  }
}
