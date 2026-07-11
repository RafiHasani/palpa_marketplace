import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';

abstract class CategoryRepo {
  late final DioService dio;

  Future<Either<ErrorModel, CategoryResponseModel>> getCategory({
    String? qeury,
  });
  Future<Either<ErrorModel, CategoryResponseModel>> getCategoryBySlug(
    String slug,
  );
}
