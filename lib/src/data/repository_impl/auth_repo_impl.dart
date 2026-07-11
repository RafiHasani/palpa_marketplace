import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/auth_response_model.dart';
import 'package:palpa_marketplace/src/domain/repositories/auth_repo.dart';

final authRepoImplProvider = Provider((ref) {
  return AuthRepoImpl(dio: ref.read(dioServiceProvider));
});

class AuthRepoImpl implements AuthRepo {
  @override
  DioService dio;
  AuthRepoImpl({required this.dio});

  @override
  Future<Either<ErrorModel, Response<dynamic>>> login(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await dio.post(Endpoints.getOtp, data: body);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right(response);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> verifyCode(
    Map<String, dynamic> body,
  ) async {
    final json = jsonEncode(body);
    try {
      final response = await dio.post(Endpoints.verifyCode, data: json);

      if (response.statusCode == 204 || response.statusCode == 200) {
        final authResponseModel = AuthResponseModel.fromJson(response.data);

        return Right(authResponseModel);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, UpdateResponseModel>> getAuthedUser() async {
    try {
      final response = await dio.get(Endpoints.getAuthedUser);

      if (response.statusCode == 200) {
        final authResponseModel = UpdateResponseModel.fromJson(response.data);

        return Right(authResponseModel);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, Response<dynamic>>> logout() async {
    try {
      final response = await dio.delete(Endpoints.logout);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right(response);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, UpdateResponseModel>> updateProfile(
    Map<String, dynamic> body,
  ) async {
    try {
      // Base payload
      final Map<String, dynamic> payload = {
        'name': body['name']?.toString().trim(),
        'last_name': body['last_name']?.toString().trim(),
        'dob': body['dob']?.toString().trim(),
        'address': body['address']?.toString().trim(),
        'is_producer': body['is_producer'] ? '1' : '0',
        'email': body['email']?.toString().trim(),
        'phone': body['phone']?.toString().trim(),
      };

      if (body['is_producer'] ?? false) {
        payload['bio'] = body['bio']?.toString().trim();
      }

      if (body['avatar'] != null && body['avatar'] is String) {
        payload['avatar'] = await MultipartFile.fromFile(
          body['avatar'],
          filename: body['avatar'].split('/').last,
        );
      }

      final formData = FormData.fromMap(payload);

      final response = await dio.post(
        Endpoints.updateProfile,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final updateResponseModel = UpdateResponseModel.fromJson(response.data);

        return Right(updateResponseModel);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> register({
    required String name,
    required String lastname,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final body = {
        "name": name,
        "last_name": lastname,
        "username": username,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
      final response = await dio.post(Endpoints.register, data: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final authResponseModel = AuthResponseModel.fromJson(response.data);
        return Right(authResponseModel);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    try {
      final body = {"username": username, "password": password};

      final response = await dio.post(
        Endpoints.loginWithUsernamePassword,
        data: body,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        final authResponseModel = AuthResponseModel.fromJson(response.data);
        return Right(authResponseModel);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, Response<dynamic>>> changePassword(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await dio.post(Endpoints.changePassword, data: body);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right(response);
      } else {
        return left(
          ErrorModel(
            error: response.statusMessage ?? 'Something went wrong',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return left(e.error as ErrorModel);
    }
  }
}
