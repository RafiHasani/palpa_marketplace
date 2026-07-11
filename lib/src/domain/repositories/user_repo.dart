import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/auth_response_model.dart';

abstract class UserRepo {
  late final DioService dio;
  Future<Either<ErrorModel, AuthResponseModel>> updateProfile(
    Map<String, dynamic> body,
  );
}
