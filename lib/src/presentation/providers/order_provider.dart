import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/order_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/order_repo.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final repo = ref.read(orderRepoImplProvider);
  return OrderNotifier(repo: repo);
});

class OrderNotifier extends StateNotifier<OrderState> {
  OrderRepo repo;
  OrderNotifier({required this.repo}) : super(OrderState.initial());

  Future<void> getOrders() async {
    try {
      state = state.copyWith(apiCallStatus: .loadingOrder);

      final response = await repo.getUserOrdersList();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .loadingOrderFailed,
          );
        },
        (orders) {
          final total = calculateCartTotal(orders.data ?? []);

          state = state.copyWith(
            apiCallStatus: .loadingOrderSuccess,
            orderResponseModel: orders,
            totalAmount: total,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .loadingOrderFailed,
      );
    }
  }

  Future<void> cancelOrderByUser(String orderNumber) async {
    try {
      state = state.copyWith(apiCallStatus: .orderStateUpdating);

      final response = await repo.cancelOrderByUser(orderNumber: orderNumber);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .orderSatetUpdatingFailed,
          );
        },
        (orders) {
          state = state.copyWith(apiCallStatus: .orderSatetUpdatingSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
      );
    }
  }

  Future<void> approveOrderByUser(String orderNumber) async {
    try {
      state = state.copyWith(apiCallStatus: .orderStateUpdating);

      final response = await repo.approveOrderByUser(orderNumber: orderNumber);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .orderSatetUpdatingFailed,
          );
        },
        (orders) {
          state = state.copyWith(apiCallStatus: .orderSatetUpdatingSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
      );
    }
  }

  Future<void> placeOrder({required String slug, required int quantity}) async {
    try {
      state = state.copyWith(apiCallStatus: .placingOrder);

      final body = {"product_slug": slug, "quantity": quantity};

      final response = await repo.placeOrder(qeury: body);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .placingOrderFailed,
          );
        },
        (orders) {
          state = state.copyWith(apiCallStatus: .placingOrderSucess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .placingOrderFailed,
      );
    }
  }

  double calculateCartTotal(List<OrderModel> orders) {
    double total = 0;

    for (final order in orders) {
      final amount = order.amount.toNumber();
      total += amount;
    }

    return total;
  }
}

class OrderState extends Equatable {
  final OrderApiState apiCallStatus;
  final OrderResponseModel? orderResponseModel;
  final ErrorModel? errorMessage;
  final double? totalAmount;

  const OrderState({
    required this.apiCallStatus,
    this.orderResponseModel,
    this.errorMessage,
    this.totalAmount,
  });

  const OrderState.initial()
    : apiCallStatus = .initial,
      orderResponseModel = null,
      errorMessage = null,
      totalAmount = 0.0;

  OrderState copyWith({
    OrderApiState? apiCallStatus,
    OrderResponseModel? orderResponseModel,
    ErrorModel? errorMessage,
    double? totalAmount,
  }) {
    return OrderState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      orderResponseModel: orderResponseModel ?? this.orderResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
    apiCallStatus,
    orderResponseModel,
    errorMessage,
    totalAmount,
  ];
}

enum OrderApiState {
  initial,
  placingOrder,
  placingOrderFailed,
  placingOrderSucess,
  loadingOrder,
  loadingOrderFailed,
  loadingOrderSuccess,
  orderStateUpdating,
  orderSatetUpdatingFailed,
  orderSatetUpdatingSuccess,
}
