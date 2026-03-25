import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nectracker/constants/api_constants.dart';
import 'package:nectracker/controllers/auth_controller.dart';
import 'package:nectracker/interfaces/api/i_api_endpoints_enum.dart';
import 'package:nectracker/models/api/response/api_response.dart';

class BeeponaApi {
  final Dio _dio;

  BeeponaApi() : _dio = Dio() {
    _dio.options.baseUrl = baseApiUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final requiresAuth = options.extra['requiresAuth'] ?? true;
        if (requiresAuth && token.value != null) {
          options.headers['Authorization'] = 'Bearer ${token.value}';
        }
        return handler.next(options);
      },
    ));
  }

  Future<ApiResponse<dynamic>> request({
    required IApiEndpointsEnum endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final options = Options(
      method: endpoint.metodo.name.toUpperCase(),
      extra: {'requiresAuth': requiresAuth},
    );

    try {
      final response = await _dio.request(
        endpoint.path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      // Tratando casos onde o retorno possa vir como string
      final responseData = response.data is String ? jsonDecode(response.data) : response.data;

      return ApiResponse.fromJson(responseData as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data is String ? jsonDecode(e.response!.data) : e.response!.data;
        if (errorData is Map<String, dynamic>) {
           return ApiResponse.fromJson(errorData);
        }
      }
      rethrow;
    }
  }
}
