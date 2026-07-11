import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/auth_response_model.dart';

abstract class AuthRepo {
  late final DioService dio;
  Future<Either<ErrorModel, Response>> login(Map<String, dynamic> body);
  Future<Either<ErrorModel, AuthResponseModel>> loginWithUsernamePassword({
    required String username,
    required String password,
  });

  Future<Either<ErrorModel, AuthResponseModel>> verifyCode(
    Map<String, dynamic> body,
  );

  Future<Either<ErrorModel, UpdateResponseModel>> getAuthedUser();

  Future<Either<ErrorModel, UpdateResponseModel>> updateProfile(
    Map<String, dynamic> body,
  );

  Future<Either<ErrorModel, Response<dynamic>>> changePassword(
    Map<String, dynamic> body,
  );

  Future<Either<ErrorModel, AuthResponseModel>> register({
    required String name,
    required String lastname,
    required String username,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<ErrorModel, Response<dynamic>>> logout();
}
