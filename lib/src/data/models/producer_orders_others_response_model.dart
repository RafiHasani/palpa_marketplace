import 'package:palpa_marketplace/src/data/models/meta.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';

class ProducerOrdersOthersResponseModel {
  ProducerOrdersOthersResponseModel({required this.data, required this.meta});

  final List<ProducerOrderModel> data;
  final Meta? meta;

  factory ProducerOrdersOthersResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProducerOrdersOthersResponseModel(
      data: json["data"] == null
          ? []
          : List<ProducerOrderModel>.from(
              json["data"]!.map((x) => ProducerOrderModel.fromJson(x)),
            ),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }
}

class ProducerOrderModel {
  ProducerOrderModel({
    required this.number,
    required this.status,
    required this.statusLabel,
    required this.amount,
    required this.quantity,
    required this.product,
    required this.buyer,
    required this.createdAt,
  });

  final String? number;
  final num? status;
  final String? statusLabel;
  final String? amount;
  final num? quantity;
  final Products? product;
  final Buyer? buyer;
  final DateTime? createdAt;

  factory ProducerOrderModel.fromJson(Map<String, dynamic> json) {
    return ProducerOrderModel(
      number: json["number"],
      status: json["status"],
      statusLabel: json["status_label"],
      amount: json["amount"],
      quantity: json["quantity"],
      product: json["product"] == null
          ? null
          : Products.fromJson(json["product"]),
      buyer: json["buyer"] == null ? null : Buyer.fromJson(json["buyer"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "number": number,
    "status": status,
    "status_label": statusLabel,
    "amount": amount,
    "quantity": quantity,
    "product": product?.toJson(),
    "buyer": buyer?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Buyer {
  Buyer({
    required this.username,
    required this.fullName,
    required this.avatar,
    required this.bio,
  });

  final String? username;
  final String? fullName;
  final String? avatar;
  final String? bio;

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      username: json["username"],
      fullName: json["full_name"],
      avatar: json["avatar"],
      bio: json["bio"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "full_name": fullName,
    "avatar": avatar,
    "bio": bio,
  };
}
