import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_orders_others_response_model.dart';

abstract class OrderRepo {
  late final DioService dio;

  Future<Either<ErrorModel, OrderResponseModel>> getUserOrdersList({
    Map<String, String>? qeury,
  });

  Future<Either<ErrorModel, Response<dynamic>>> placeOrder({
    required Map<String, Object> qeury,
  });

  Future<Either<ErrorModel, Response<dynamic>>> cancelOrderByUser({
    required String orderNumber,
  });

  Future<Either<ErrorModel, Response<dynamic>>> approveOrderByUser({
    required String orderNumber,
  });

  Future<Either<ErrorModel, ProducerOrdersOthersResponseModel>>
  getProducerOrderOfOthers({Map<String, String>? qeury});

  Future<Either<ErrorModel, ProducerOrdersOthersResponseModel>>
  getProducerOrderOfMine({Map<String, String>? qeury});
}
