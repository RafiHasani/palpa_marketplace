import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';
import 'package:palpa_marketplace/src/domain/repositories/category_repo.dart';

final categoryRepoImplProvider = Provider((ref) {
  return CategoryRepoImpl(dio: ref.read(dioServiceProvider));
});

class CategoryRepoImpl implements CategoryRepo {
  @override
  DioService dio;
  CategoryRepoImpl({required this.dio});

  @override
  Future<Either<ErrorModel, CategoryResponseModel>> getCategory({
    String? qeury,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.getCategories,
        queryParameters: (qeury != null) ? {"include": qeury} : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final categories = CategoryResponseModel.fromJson(json);

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
  Future<Either<ErrorModel, CategoryResponseModel>> getCategoryBySlug(
    String slug,
  ) async {
    try {
      final response = await dio.get('${Endpoints.getCategoriesBySlug}/$slug');
      if (response.statusCode == 200) {
        final json = response.data;

        final categories = CategoryResponseModel.fromJson(json);

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
}
