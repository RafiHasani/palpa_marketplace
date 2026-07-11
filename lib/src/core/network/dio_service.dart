import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/network_status_provider.dart';

class DioService {
  final Ref ref;
  late final Dio _dio;

  DioService(this.ref) {
    final networkNotifier = ref.read(networkStatusProvider.notifier);
    _dio = Dio(
      BaseOptions(
        baseUrl: Appconfig().baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final local = ref.watch(appLangProvider);
          final token = Appconfig().token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          options.headers['Accept-Language'] = local;
          handler.next(options);
        },
        onResponse: (response, handler) {
          networkNotifier.setState(true);
          debugPrint(response.toString());
          handler.next(response);
        },
        onError: (DioException error, handler) {
          if (error.error is SocketException) {
            networkNotifier.setState(false);
          }
          if (error.response?.statusCode == 401) {
            ref.read(authProvider.notifier).logoutStateUpdate();
            _handleError(error);
            return;
          }
          final status = error.response?.statusCode;
          if (status == 500) {
            debugPrint('Global 500 handler triggered');
          }
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  // ============================
  // HTTP METHODS
  // ============================

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ============================
  // FILE UPLOAD
  // ============================

  Future<Response> uploadFile({
    required String path,
    required File file,
    String fileKey = 'file',
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      fileKey: await MultipartFile.fromFile(file.path),
    });

    return _dio.post(path, data: formData);
  }

  // ============================
  // ERROR HANDLING
  // ============================

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('Connection timeout');

      case DioExceptionType.badResponse:
        {
          debugPrint(error.response?.data['message']);

          throw ErrorModel(
            error: error.response?.data['message'] ?? '',
            statusCode: error.response?.statusCode ?? 400,
          );
        }

      case DioExceptionType.cancel:
        throw Exception('Request cancelled');

      default:
        throw Exception('Unexpected error occurred');
    }
  }
}
