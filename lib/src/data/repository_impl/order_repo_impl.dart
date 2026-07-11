import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_orders_others_response_model.dart';
import 'package:palpa_marketplace/src/domain/repositories/order_repo.dart';

final orderRepoImplProvider = Provider((ref) {
  return OrderRepoImpl(dio: ref.read(dioServiceProvider));
});

class OrderRepoImpl implements OrderRepo {
  @override
  DioService dio;
  OrderRepoImpl({required this.dio});

  @override
  Future<Either<ErrorModel, OrderResponseModel>> getUserOrdersList({
    Map<String, String>? qeury,
  }) async {
    try {
      final response = await dio.get(
        Endpoints.orders,
        queryParameters: (qeury != null) ? qeury : null,
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final products = OrderResponseModel.fromJson(json);

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
  Future<Either<ErrorModel, Response<dynamic>>> placeOrder({
    required Map<String, Object> qeury,
  }) async {
    try {
      final response = await dio.post(
        Endpoints.orders,
        data: jsonEncode(qeury),
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
  Future<Either<ErrorModel, Response<dynamic>>> cancelOrderByUser({
    required String orderNumber,
  }) async {
    try {
      final action = 'cancel';

      final endpoint = '${Endpoints.orders}/$orderNumber/$action';

      final response = await dio.post(endpoint);
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
  Future<Either<ErrorModel, ProducerOrdersOthersResponseModel>>
  getProducerOrderOfMine({Map<String, String>? qeury}) async {
    try {
      final response = await dio.get(
        Endpoints.orders,
        queryParameters: {'filter[from]': 'mine'},
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final orders = ProducerOrdersOthersResponseModel.fromJson(json);

        return Right(orders);
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
  Future<Either<ErrorModel, ProducerOrdersOthersResponseModel>>
  getProducerOrderOfOthers({Map<String, String>? qeury}) async {
    try {
      final response = await dio.get(
        Endpoints.orders,
        queryParameters: {'filter[from]': 'others'},
      );
      if (response.statusCode == 200) {
        final json = response.data;

        final orders = ProducerOrdersOthersResponseModel.fromJson(json);

        return Right(orders);
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
  Future<Either<ErrorModel, Response<dynamic>>> approveOrderByUser({
    required String orderNumber,
  }) async {
    try {
      final action = 'approve';

      final endpoint = '${Endpoints.orders}/$orderNumber/$action';

      final response = await dio.post(endpoint);
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
}
