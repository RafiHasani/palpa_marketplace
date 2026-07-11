import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
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
import 'package:palpa_marketplace/src/domain/repositories/product_repo.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

final productRepoImplProvider = Provider((ref) {
  return ProductRepoImpl(dio: ref.read(dioServiceProvider));
});

class ProductRepoImpl implements ProductRepo {
  @override
  DioService dio;
  ProductRepoImpl({required this.dio});

  @override
  Future<Either<ErrorModel, CategoryResponseModel>> getCategoryProduct({
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
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, CategoryProductResponseModel>>
  getCategoryProductBySlug({required String slug, String? query}) async {
    try {
      final response = await dio.get(
        '${Endpoints.getCategoriesBySlug}/$slug',
        queryParameters: (query != null) ? {"include": query} : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final categories = CategoryProductResponseModel.fromJson(json);

        return Right(categories);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, ProductDetailsModel>> getProductDetailsBySlug({
    required String slug,
    String? qeury,
  }) async {
    try {
      final response = await dio.get(
        '${Endpoints.getProductDetailsBySlug}/$slug',
        queryParameters: (qeury != null) ? {"include": qeury} : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;
        final data = json['data'];

        final productDetails = ProductDetailsModel.fromJson(data);

        return Right(productDetails);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, ProductReviewResponseModel>>
  getProductReviewBySlug({required String slug, String? qeury}) async {
    try {
      final response = await dio.get(
        '${Endpoints.getProduct}/$slug/reviews', // reviews
        queryParameters: (qeury != null) ? {"include": qeury} : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final productReview = ProductReviewResponseModel.fromJson(json);

        return Right(productReview);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, ProductsResponseModel>> getProductsFeaturing({
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.getProduct,
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProductsResponseModel.fromJson(json);

        return Right(products);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, ProductsResponseModel>> searchProducts({
    Map<String, dynamic>? qeury,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.searchProducts,
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProductsResponseModel.fromJson(json);

        return Right(products);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, MyProductReviewResponseModel>>
  getMyProductReviews() async {
    try {
      final response = await dio.get(Endpoints.getMyProductReviews);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = MyProductReviewResponseModel.fromJson(response.data);
        return Right(data);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } catch (e) {
      return Left(ErrorModel(error: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<ErrorModel, Response<dynamic>>> addProductReview({
    required String slug,
    Map<String, Object>? qeury,
  }) async {
    try {
      final response = await dio.post(
        '${Endpoints.addReview}$slug/reviews',
        data: qeury,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right(response);
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
  Future<Either<ErrorModel, Response<dynamic>>> deleteProductReview({
    required String slug,
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.delete(
        Endpoints.searchProducts,
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200) {
        return Right(response);
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
  Future<Either<ErrorModel, Response<dynamic>>> dislikeProduct({
    required String slug,
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.delete(
        '${Endpoints.likeDislikeProduct}$slug/likes',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right(response);
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
  Future<Either<ErrorModel, Response<dynamic>>> likeProduct({
    required String slug,
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.post(
        '${Endpoints.likeDislikeProduct}$slug/likes',
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right(response);
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
  Future<Either<ErrorModel, ProductsResponseModel>> getProductsLiked({
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.favorites,
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProductsResponseModel.fromJson(json);

        return Right(products);
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
  Future<Either<ErrorModel, Response<dynamic>>> createProduct({
    required CreateProductState body,
  }) async {
    // 1. Prepare FormData (Your indexing logic is correct)
    FormData formData = FormData();
    try {
      List<dynamic> jsonDescfa =
          jsonDecode(body.descriptionfa ?? '') as List<dynamic>;
      final mapDescfa = <String, dynamic>{'ops': jsonDescfa};
      final mapJsonDescfa = jsonEncode(mapDescfa);

      List<dynamic> jsonDescps =
          jsonDecode(body.descriptionps ?? '') as List<dynamic>;
      final mapDescps = <String, dynamic>{'ops': jsonDescps};
      final mapJsonDescps = jsonEncode(mapDescps);

      List<dynamic> jsonDescen =
          jsonDecode(body.descriptionen ?? '') as List<dynamic>;
      final mapDescen = <String, dynamic>{'ops': jsonDescen};
      final mapJsonDescen = jsonEncode(mapDescen);

      List<dynamic> jsonAboutfa =
          jsonDecode(body.aboutfa ?? '') as List<dynamic>;
      final mapAboutfa = <String, dynamic>{'ops': jsonAboutfa};
      final mapJsonAboutfa = jsonEncode(mapAboutfa);

      List<dynamic> jsonAboutps =
          jsonDecode(body.aboutps ?? '') as List<dynamic>;
      final mapAboutps = <String, dynamic>{'ops': jsonAboutps};
      final mapJsonAboutps = jsonEncode(mapAboutps);

      List<dynamic> jsonAbouten =
          jsonDecode(body.abouten ?? '') as List<dynamic>;
      final mapAbouten = <String, dynamic>{'ops': jsonAbouten};
      final mapJsonAbouten = jsonEncode(mapAbouten);

      formData.fields.addAll([
        MapEntry('name[en]', body.nameen ?? ''),
        MapEntry('name[fa]', body.namefa ?? ''),
        MapEntry('name[ps]', body.nameps ?? ''),
        MapEntry('description[en]', mapJsonDescfa),
        MapEntry('description[fa]', mapJsonDescen),
        MapEntry('description[ps]', mapJsonDescps),
        MapEntry('about[en]', mapJsonAbouten),
        MapEntry('about[fa]', mapJsonAboutfa),
        MapEntry('about[ps]', mapJsonAboutps),
        MapEntry('category_slug', body.subCategorySlug!.slug),
        MapEntry('unit_symbol', body.unitSymbol?.symbol ?? 'kg'),
        MapEntry('price', body.price?.toInt().toString() ?? '0'),
        MapEntry('stock', body.stock?.toInt().toString() ?? '0'),
        MapEntry('province_slug', body.provinceSlug!.slug),
        MapEntry('is_active', (body.isActive ?? false) ? '1' : '0'),
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (body.discountedPrice != null) {
      formData.fields.add(
        MapEntry('discounted_price', body.discountedPrice.toString()),
      );
    }

    for (int i = 0; i < body.images!.length; i++) {
      final image = body.images![i];
      formData.files.add(
        MapEntry(
          'images[$i][file]',
          await MultipartFile.fromFile(
            image.path!,
            filename: p.basename(image.path!),
            // Add this to satisfy Laravel image validation
            contentType: DioMediaType('image', '*'),
          ),
        ),
      );
      formData.fields.add(
        MapEntry('images[$i][is_featured]', image.isFeatured ? '1' : '0'),
      );
    }

    debugPrint(formData.toString());

    try {
      final response = await dio.post(
        Endpoints.createProduct,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      // Laravel 'assertCreated()' returns 201
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return Right(response);
      } else {
        return Left(
          ErrorModel(
            error: 'Unexpected status code',
            statusCode: response.statusCode ?? 500,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint(' ERROR DETAILS: ${e.response}');
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, ProductsResponseModel>> getMyProducts() async {
    try {
      final response = await dio.get(Endpoints.getMyProduct);
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProductsResponseModel.fromJson(json);

        return Right(products);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('422 ERROR DETAILS: ${e.response}');
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, ProducerDashboardResponseModel>>
  getProducerDashboard() async {
    try {
      final response = await dio.get(
        Endpoints.getProducerDashboard,
      ); // get user products
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProducerDashboardResponseModel.fromJson(json);

        return Right(products);
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
  Future<Either<ErrorModel, Response<dynamic>>> updateProduct({
    required CreateProductState body,
    required String slug,
  }) async {
    FormData formData = FormData();

    try {
      List<dynamic> jsonDescfa =
          jsonDecode(body.descriptionfa ?? '') as List<dynamic>;
      final mapDescfa = <String, dynamic>{'ops': jsonDescfa};
      final mapJsonDescfa = jsonEncode(mapDescfa);

      List<dynamic> jsonDescps =
          jsonDecode(body.descriptionps ?? '') as List<dynamic>;
      final mapDescps = <String, dynamic>{'ops': jsonDescps};
      final mapJsonDescps = jsonEncode(mapDescps);

      List<dynamic> jsonDescen =
          jsonDecode(body.descriptionen ?? '') as List<dynamic>;
      final mapDescen = <String, dynamic>{'ops': jsonDescen};
      final mapJsonDescen = jsonEncode(mapDescen);

      List<dynamic> jsonAboutfa =
          jsonDecode(body.aboutfa ?? '') as List<dynamic>;
      final mapAboutfa = <String, dynamic>{'ops': jsonAboutfa};
      final mapJsonAboutfa = jsonEncode(mapAboutfa);

      List<dynamic> jsonAboutps =
          jsonDecode(body.aboutps ?? '') as List<dynamic>;
      final mapAboutps = <String, dynamic>{'ops': jsonAboutps};
      final mapJsonAboutps = jsonEncode(mapAboutps);

      List<dynamic> jsonAbouten =
          jsonDecode(body.abouten ?? '') as List<dynamic>;
      final mapAbouten = <String, dynamic>{'ops': jsonAbouten};
      final mapJsonAbouten = jsonEncode(mapAbouten);

      formData.fields.addAll([
        MapEntry('name[en]', body.nameen ?? ''),
        MapEntry('name[fa]', body.namefa ?? ''),
        MapEntry('name[ps]', body.nameps ?? ''),
        MapEntry('description[en]', mapJsonDescen),
        MapEntry('description[fa]', mapJsonDescfa),
        MapEntry('description[ps]', mapJsonDescps),
        MapEntry('about[en]', mapJsonAbouten),
        MapEntry('about[fa]', mapJsonAboutfa),
        MapEntry('about[ps]', mapJsonAboutps),
        MapEntry('category_slug', body.subCategorySlug!.slug),
        MapEntry('unit_symbol', body.unitSymbol?.symbol ?? 'kg'),
        MapEntry('price', body.price?.toInt().toString() ?? '0'),
        MapEntry('stock', body.stock?.toInt().toString() ?? '0'),
        MapEntry('province_slug', body.provinceSlug!.slug),
        MapEntry('is_active', (body.isActive ?? false) ? '1' : '0'),
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (body.discountedPrice != null) {
      formData.fields.add(
        MapEntry('discounted_price', body.discountedPrice.toString()),
      );
    }

    for (int i = 0; i < body.images!.length; i++) {
      final image = body.images![i];

      if (image.uuid != ImageState.deleted.label) {
        formData.fields.add(
          MapEntry('images[$i][is_featured]', image.isFeatured ? '1' : '0'),
        );
      }

      if (image.uuid != ImageState.deleted.label &&
          image.uuid != ImageState.added.label) {
        formData.fields.add(MapEntry('images[$i][uuid]', image.uuid ?? ''));
      }
      if (image.uuid == ImageState.added.label) {
        formData.files.add(
          MapEntry(
            'images[$i][file]',
            await MultipartFile.fromFile(
              image.path!,
              filename: p.basename(image.path!),
              contentType: DioMediaType('image', '*'),
            ),
          ),
        );
      }
    }

    debugPrint(formData.toString());

    try {
      final response = await dio.post(
        '${Endpoints.producerUpdateProduct}/$slug',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      // Laravel 'assertCreated()' returns 201
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return Right(response);
      } else {
        return Left(
          ErrorModel(
            error: 'Unexpected status code',
            statusCode: response.statusCode ?? 500,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint(' ERROR DETAILS: ${e.response}');
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Either<ErrorModel, Response<dynamic>>> updateProductStatus({
    required String slug,
  }) async {
    try {
      final endpoint = '${Endpoints.producerUpdateProduct}/$slug/status';

      final response = await dio.put(endpoint);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right(response);
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
  Future<Either<ErrorModel, ProducerProductDetailsResponseModel>>
  producerGetProductDetails({required String slug}) async {
    try {
      final response = await dio.get(
        '${Endpoints.producerGetProductDetails}/$slug',
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final products = ProducerProductDetailsResponseModel.fromJson(json);

        return Right(products);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint(' ERROR DETAILS: ${e.response}');
      return Left(e.error as ErrorModel);
    }
  }

  @override
  Future<Uint8List?> getImageDataByte(String asset) async {
    final dioHttpClient = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),

        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    );

    final response = await dioHttpClient.get<List<int>>(
      asset,
      options: Options(
        responseType: ResponseType.bytes, // critical
        followRedirects: true,
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    if (response.statusCode == 200) {
      if (response.data == null) {
        throw Exception('Image download failed — empty response');
      }

      return Uint8List.fromList(response.data!);
    } else {
      return null;
    }
  }
}
