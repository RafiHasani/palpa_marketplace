import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_product_response_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';
import 'package:palpa_marketplace/src/data/models/my_product_review_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_dashboard_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_product_details_model.dart';
import 'package:palpa_marketplace/src/data/models/product_details_model.dart';
import 'package:palpa_marketplace/src/data/models/product_review_response_model.dart';
import 'package:palpa_marketplace/src/data/models/products_response_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';

abstract class ProductRepo {
  late final DioService dio;

  Future<Either<ErrorModel, CategoryResponseModel>> getCategoryProduct({
    String? qeury,
  });
  Future<Either<ErrorModel, CategoryProductResponseModel>>
  getCategoryProductBySlug({required String slug, String? query});

  Future<Either<ErrorModel, ProductDetailsModel>> getProductDetailsBySlug({
    required String slug,
    String? qeury,
  });

  Future<Either<ErrorModel, ProductReviewResponseModel>>
  getProductReviewBySlug({required String slug, String? qeury});

  Future<Either<ErrorModel, ProductsResponseModel>> getProductsFeaturing({
    Map<String, String>? qeury,
  });

  Future<Either<ErrorModel, ProductsResponseModel>> searchProducts({
    Map<String, dynamic>? qeury,
  });

  Future<Either<ErrorModel, MyProductReviewResponseModel>>
  getMyProductReviews();

  Future<Either<ErrorModel, Response<dynamic>>> addProductReview({
    required String slug,
    Map<String, Object>? qeury,
  });

  Future<Either<ErrorModel, Response<dynamic>>> deleteProductReview({
    required String slug,
    Map<String, String>? qeury,
  });

  Future<Either<ErrorModel, Response<dynamic>>> likeProduct({
    required String slug,
    Map<String, String>? qeury,
  });
  Future<Either<ErrorModel, Response<dynamic>>> dislikeProduct({
    required String slug,
    Map<String, String>? qeury,
  });

  Future<Either<ErrorModel, Response<dynamic>>> createProduct({
    required CreateProductState body,
  });

  Future<Either<ErrorModel, ProductsResponseModel>> getProductsLiked({
    Map<String, String>? qeury,
  });

  Future<Either<ErrorModel, ProductsResponseModel>> getMyProducts();

  Future<Either<ErrorModel, ProducerDashboardResponseModel>>
  getProducerDashboard();

  Future<Either<ErrorModel, Response<dynamic>>> updateProduct({
    required CreateProductState body,
    required String slug,
  });

  Future<Either<ErrorModel, Response<dynamic>>> updateProductStatus({
    required String slug,
  });

  Future<Either<ErrorModel, ProducerProductDetailsResponseModel>>
  producerGetProductDetails({required String slug});

  Future<Uint8List?> getImageDataByte(String asset);
}
