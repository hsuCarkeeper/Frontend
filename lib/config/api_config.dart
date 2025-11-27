/// API 설정 및 엔드포인트 상수
class ApiConfig {
  // Firebase Cloud Functions 베이스 URL
  // region: asia-northeast3 (서울)
  // projectId: checkandgo-e1045
  static const String baseUrl =
      'https://asia-northeast3-checkandgo-e1045.cloudfunctions.net';

  // API 엔드포인트
  static const String trips = '/trips';
  static const String checklist = '/checklist';

  // 헤더
  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';

  /// 특정 여행의 체크리스트 엔드포인트
  /// 예: /trips/trp_1/checklist
  static String tripChecklist(String tripId) => '/trips/$tripId/checklist';

  /// Authorization 헤더 값 생성
  /// 예: "Bearer <token>"
  static String bearerToken(String token) => 'Bearer $token';

  /// 공통 헤더 생성
  static Map<String, String> headers({String? authToken}) {
    return {
      'Content-Type': contentType,
      if (authToken != null) authorizationHeader: bearerToken(authToken),
    };
  }
}

/// API 에러 응답
class ApiErrorResponse {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  ApiErrorResponse({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>;
    return ApiErrorResponse(
      code: error['code'] as String,
      message: error['message'] as String,
      details: error['details'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'ApiError($code): $message ${details != null ? details.toString() : ''}';
  }
}
