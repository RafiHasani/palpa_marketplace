import 'package:equatable/equatable.dart';

class ProducerDashboardResponseModel extends Equatable {
  final ProducerDashboard? data;

  const ProducerDashboardResponseModel({required this.data});

  factory ProducerDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    final map = json['data'] as Map<String, dynamic>;
    return ProducerDashboardResponseModel(
      data: ProducerDashboard.fromJson(map),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }

  @override
  List<Object?> get props => [data];
}

class ProducerDashboard extends Equatable {
  final num activeProductsCount;
  final num pendingOrdersCount;
  final num newOrdersCount;
  final String productsRatingAverage;

  const ProducerDashboard({
    required this.activeProductsCount,
    required this.pendingOrdersCount,
    required this.newOrdersCount,
    required this.productsRatingAverage,
  });

  Map<String, dynamic> toJson() {
    return {
      'active_products_count': activeProductsCount,
      'pending_orders_count': pendingOrdersCount,
      'new_orders_count': newOrdersCount,
      'products_rating_average': productsRatingAverage,
    };
  }

  factory ProducerDashboard.fromJson(Map<String, dynamic> json) {
    return ProducerDashboard(
      activeProductsCount: json['active_products_count'],
      pendingOrdersCount: json['pending_orders_count'],
      newOrdersCount: json['new_orders_count'],
      productsRatingAverage: json['products_rating_average'],
    );
  }

  @override
  List<Object?> get props => [
    activeProductsCount,
    pendingOrdersCount,
    newOrdersCount,
    productsRatingAverage,
  ];
}
