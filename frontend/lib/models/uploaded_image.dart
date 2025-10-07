// lib/models/uploaded_image.dart
// 데이터베이스 'uploaded_images' 테이블 모델
// 화면 13-14: 이미지 업로드 및 분석 상태 관리
import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_image.freezed.dart';
part 'uploaded_image.g.dart';

@freezed
class UploadedImage with _$UploadedImage {
  const factory UploadedImage({
    required String id,
    @JsonKey(name: 'user_id') required String userId,

    // 스토리지 정보
    @JsonKey(name: 'storage_path') required String storagePath,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'file_size') int? fileSize,

    // 분석 상태 (화면 14: 분석 중 페이지)
    @JsonKey(name: 'analysis_status') String? analysisStatus,
    // pending → processing → completed / failed

    // 타임스탬프
    @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
    @JsonKey(name: 'analyzed_at') DateTime? analyzedAt,
  }) = _UploadedImage;

  factory UploadedImage.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageFromJson(json);
}

// 분석 상태 상수
class AnalysisStatus {
  static const String pending = 'pending'; // 대기 중
  static const String processing = 'processing'; // 분석 중 (화면 14)
  static const String completed = 'completed'; // 완료 (화면 16으로 이동)
  static const String failed = 'failed'; // 실패 (화면 15)

  static String toKorean(String status) {
    switch (status) {
      case pending:
        return '대기 중';
      case processing:
        return '분석 중';
      case completed:
        return '완료';
      case failed:
        return '실패';
      default:
        return status;
    }
  }
}
