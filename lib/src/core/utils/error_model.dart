class ErrorModel implements Exception {
  final String error;
  final int statusCode;
  const ErrorModel({required this.error, required this.statusCode});

  ErrorModel copyWith({String? error, int? statusCode}) {
    return ErrorModel(
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
