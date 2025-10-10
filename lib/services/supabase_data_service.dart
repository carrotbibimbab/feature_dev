// lib/services/supabase_data_service.dart
// Supabase 데이터베이스 CRUD 작업
import 'dart:io';
import 'package:bf_app/services/supabase_service.dart';
import 'package:bf_app/models/user_profile.dart';
import 'package:bf_app/models/analysis_result.dart';
import 'package:bf_app/models/uploaded_image.dart';

class SupabaseDataService {
  final _supabase = SupabaseConfig.client;

  // ==================== 프로필 관련 ====================

  // 현재 사용자 프로필 가져오기 (화면 7, 8)
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from(Tables.profiles)
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // 프로필 생성/업데이트 (화면 5, 11)
  Future<bool> upsertProfile(UserProfile profile) async {
    try {
      await _supabase.from(Tables.profiles).upsert(profile.toJson());
      return true;
    } catch (e) {
      print('Error upserting profile: $e');
      return false;
    }
  }

  // 프로필 업데이트 (화면 11: 개인정보 수정)
  Future<bool> updateProfile({
    required String userId,
    String? name,
    int? birthYear,
    String? skinType,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (birthYear != null) updates['birth_year'] = birthYear;
      if (skinType != null) updates['skin_type'] = skinType;
      updates['profile_completed'] = true;

      await _supabase.from(Tables.profiles).update(updates).eq('id', userId);

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // ==================== 이미지 업로드 관련 ====================

  // 이미지 메타데이터 저장 (화면 13)
  Future<UploadedImage?> createUploadedImage({
    required String userId,
    required String storagePath,
    required String imageUrl,
    int? fileSize,
  }) async {
    try {
      final response = await _supabase
          .from(Tables.uploadedImages)
          .insert({
            'user_id': userId,
            'storage_path': storagePath,
            'image_url': imageUrl,
            'file_size': fileSize,
            'analysis_status': AnalysisStatus.pending,
          })
          .select()
          .single();

      return UploadedImage.fromJson(response);
    } catch (e) {
      print('Error creating uploaded image: $e');
      return null;
    }
  }

  // 분석 상태 업데이트 (화면 14)
  Future<bool> updateAnalysisStatus({
    required String imageId,
    required String status,
  }) async {
    try {
      await _supabase.from(Tables.uploadedImages).update({
        'analysis_status': status,
        if (status == AnalysisStatus.completed)
          'analyzed_at': DateTime.now().toIso8601String(),
      }).eq('id', imageId);

      return true;
    } catch (e) {
      print('Error updating analysis status: $e');
      return false;
    }
  }

  // ==================== 분석 결과 관련 ====================

  // 분석 결과 저장 (화면 16)
  Future<AnalysisResult?> saveAnalysisResult(AnalysisResult result) async {
    try {
      final response = await _supabase
          .from(Tables.analyses)
          .insert(result.toJson())
          .select()
          .single();

      return AnalysisResult.fromJson(response);
    } catch (e) {
      print('Error saving analysis result: $e');
      return null;
    }
  }

  // 최근 분석 결과 가져오기 (화면 7: 나의 최근 피부 분석 결과)
  Future<AnalysisResult?> getLatestAnalysis() async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from(Tables.analyses)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      return AnalysisResult.fromJson(response);
    } catch (e) {
      print('Error fetching latest analysis: $e');
      return null;
    }
  }

  // 분석 로그 목록 가져오기 (화면 9: 나의 분석 로그)
  Future<List<AnalysisResult>> getAnalysisLogs({int limit = 50}) async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from(Tables.analyses)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => AnalysisResult.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching analysis logs: $e');
      return [];
    }
  }

  // 특정 분석 결과 가져오기 (화면 9 → 16)
  Future<AnalysisResult?> getAnalysisById(String analysisId) async {
    try {
      final response = await _supabase
          .from(Tables.analyses)
          .select()
          .eq('id', analysisId)
          .single();

      return AnalysisResult.fromJson(response);
    } catch (e) {
      print('Error fetching analysis by id: $e');
      return null;
    }
  }

  // ==================== 활동 로그 ====================

  // 활동 로그 기록 (선택적)
  Future<void> logActivity(String activityType,
      {Map<String, dynamic>? data}) async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) return;

      await _supabase.from(Tables.userActivities).insert({
        'user_id': userId,
        'activity_type': activityType,
        'activity_data': data,
      });
    } catch (e) {
      print('Activity log failed: $e');
      // 로깅 실패해도 앱 동작에는 영향 없게
    }
  }

  // ==================== 대시보드 ====================

  // 대시보드 요약 정보 (화면 7)
  Future<Map<String, dynamic>?> getDashboardSummary() async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from(Views.userDashboardSummary)
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error fetching dashboard summary: $e');
      return null;
    }
  }

  // ==================== Storage ====================

  // 프로필 이미지 업로드 (화면 8)
  Future<String?> uploadProfileImage(String userId, String filePath) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = '$userId/$fileName';

      await _supabase.storage
          .from(StorageBuckets.profileImages)
          .upload(storagePath, File(filePath));

      final publicUrl = _supabase.storage
          .from(StorageBuckets.profileImages)
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // 분석용 이미지 업로드 (화면 13)
  Future<Map<String, String>?> uploadAnalysisImage(
      String userId, String filePath) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = '$userId/$fileName';

      await _supabase.storage
          .from(StorageBuckets.userUploads)
          .upload(storagePath, File(filePath));

      final publicUrl = _supabase.storage
          .from(StorageBuckets.userUploads)
          .getPublicUrl(storagePath);

      return {
        'storage_path': storagePath,
        'public_url': publicUrl,
      };
    } catch (e) {
      print('Error uploading analysis image: $e');
      return null;
    }
  }
}

// File import for uploadProfileImage and uploadAnalysisImage
