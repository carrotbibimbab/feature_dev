// lib/services/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:bf_app/models/analysis_result.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://backend-6xc5.onrender.com',
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  // 종합 AI 분석 요청 (화면 14 → 화면 16)
  Future<AnalysisResult> analyzeImageComprehensive(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/api/v1/analysis/comprehensive',
        data: formData,
      );

      if (response.statusCode == 200) {
        return AnalysisResult.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze image');
      }
    } on DioException catch (e) {
      print('Error analyzing image: $e');
      rethrow;
    }
  }

  // 퍼스널 컬러만 분석 (필요 시)
  Future<Map<String, dynamic>> analyzePersonalColor(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/api/v1/analysis/personal-color',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to analyze personal color');
      }
    } on DioException catch (e) {
      print('Error analyzing personal color: $e');
      rethrow;
    }
  }

  // 민감성만 분석 (필요 시)
  Future<Map<String, dynamic>> analyzeSensitivity(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/api/v1/analysis/sensitivity',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to analyze sensitivity');
      }
    } on DioException catch (e) {
      print('Error analyzing sensitivity: $e');
      rethrow;
    }
  }
}
