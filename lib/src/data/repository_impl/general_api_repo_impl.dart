import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/site_settings_resonse_model.dart';
import 'package:palpa_marketplace/src/data/models/unites_response_model.dart';
import 'package:palpa_marketplace/src/domain/repositories/general_api_repo.dart';

final generalRepoImplProvider = Provider((ref) {
  final dio = ref.read(dioServiceProvider);
  return GeneralApiRepoImpl(dio);
});

class GeneralApiRepoImpl implements GeneralApiRepo {
  @override
  DioService dio;

  GeneralApiRepoImpl(this.dio);

  @override
  Future<Either<ErrorModel, ProvinceResponseModel>> getProvince() async {
    final response = await dio.get(Endpoints.getProvince);
    try {
      if (response.statusCode == 200) {
        final province = ProvinceResponseModel.fromJson(response.data);
        return Right(province);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, UnitesResponseModel>> getUnits() async {
    final response = await dio.get(Endpoints.getUnits);
    try {
      if (response.statusCode == 200) {
        final units = UnitesResponseModel.fromJson(response.data);

        return Right(units);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, CategoryResponseModel>> getCategories() async {
    final response = await dio.get(
      Endpoints.getCategories,
      queryParameters: {"include": 'children'},
    );
    try {
      if (response.statusCode == 200) {
        final categories = CategoryResponseModel.fromJson(response.data);

        return Right(categories);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, CategoryResponseModel>> getSubCategories() async {
    final response = await dio.get(Endpoints.getCategories);
    try {
      if (response.statusCode == 200) {
        final categories = CategoryResponseModel.fromJson(response.data);

        return Right(categories);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, SiteSettingsResonseModel>> getSiteSettings() async {
    final response = await dio.get(Endpoints.getSiteSettings);
    try {
      if (response.statusCode == 200) {
        final contactUs = SiteSettingsResonseModel.fromJson(response.data);

        return Right(contactUs);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }
}
