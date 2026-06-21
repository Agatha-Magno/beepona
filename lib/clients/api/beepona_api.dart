import 'dart:convert';
import 'dart:typed_data';
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
        if (requiresAuth && tokens.value != null && tokens.value!.token != null) {
          options.headers['Authorization'] = 'Bearer ${tokens.value!.token}';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final requiresAuth = e.requestOptions.extra['requiresAuth'] ?? true;
        final isRetry = e.requestOptions.extra['isRetry'] ?? false;

        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            requiresAuth &&
            !isRetry) {
          try {
            await AuthController.refreshToken();

            if (tokens.value != null && tokens.value!.token != null) {
              e.requestOptions.headers['Authorization'] =
                  'Bearer ${tokens.value!.token}';
            }

            e.requestOptions.extra['isRetry'] = true;
            final cloneReq = await _dio.fetch(e.requestOptions);
            return handler.resolve(cloneReq);
          } catch (refreshError) {
            await AuthController.logout();
            return handler.next(e);
          }
        }
        return handler.next(e);
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
      final responseData =
          response.data is String ? jsonDecode(response.data) : response.data;

      return ApiResponse.fromJson(responseData as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response!.data is String
            ? jsonDecode(e.response!.data)
            : e.response!.data;
        if (errorData is Map<String, dynamic>) {
          return ApiResponse.fromJson(errorData);
        }
      }
      rethrow;
    }
  }

  Future<Uint8List> requestBytes({
    required IApiEndpointsEnum endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final options = Options(
      method: endpoint.metodo.name.toUpperCase(),
      responseType: ResponseType.bytes,
      extra: {'requiresAuth': requiresAuth},
    );

    try {
      final response = await _dio.request(
        endpoint.path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data as List<int>);
      } else {
        throw Exception(
            'Erro ao baixar arquivo: código ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Falha ao baixar arquivo: ${e.message}');
    }
  }
}
