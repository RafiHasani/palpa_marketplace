import 'package:equatable/equatable.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';

class OrderResponseModel extends Equatable {
  final List<OrderModel>? data;

  const OrderResponseModel({required this.data});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [data];
}

class OrderModel {
  final String number;
  final int status;
  final String amount;
  final int quantity;
  final Products product;
  final DateTime createdAt;
  final String statusLabel;

  OrderModel({
    required this.number,
    required this.status,
    required this.amount,
    required this.quantity,
    required this.product,
    required this.createdAt,
    required this.statusLabel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final order = OrderModel(
      number: json['number'],
      status: json['status'],
      amount: json['amount'],
      quantity: json['quantity'],
      statusLabel: json['status_label'],

      product: Products.fromJson(json['product']),
      createdAt: DateTime.parse(json['created_at']),
    );

    return order;
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'status': status,
      'amount': amount,
      'quantity': quantity,
      'product': product.toJson(),
      'created_at': createdAt.millisecondsSinceEpoch,
      'status_label': statusLabel,
    };
  }
}
