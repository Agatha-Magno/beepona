class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic errors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, {T Function(dynamic)? fromJsonT}) {
    return ApiResponse<T>(
      success: json['success'] ?? json['Success'] ?? false,
      message: (json['message'] ?? json['Message']) as String?,
      data: (json['data'] ?? json['Data']) != null && fromJsonT != null
          ? fromJsonT(json['data'] ?? json['Data'])
          : (json['data'] ?? json['Data']) as T?,
      errors: json['errors'] ?? json['Errors'],
    );
  }
}
