import 'package:equatable/equatable.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';

class ProductsResponseModel extends Equatable {
  final List<Products>? data;

  const ProductsResponseModel({required this.data});

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Products.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [data];
}
