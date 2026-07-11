import 'package:palpa_marketplace/src/data/models/meta.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';
import 'package:palpa_marketplace/src/data/models/user.dart';

class MyProductReviewResponseModel {
  final List<ShopingExperianceModel>? data;
  final Meta? meta;

  MyProductReviewResponseModel({this.data, this.meta});

  factory MyProductReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return MyProductReviewResponseModel(
      data: List<ShopingExperianceModel>.from(
        json['data']?.map((x) => ShopingExperianceModel.fromJson(x)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class ShopingExperianceModel {
  final User user;
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final Products product;
  const ShopingExperianceModel({
    required this.user,
    required this.rating,
    required this.comment,
    this.createdAt,
    required this.product,
  });

  factory ShopingExperianceModel.fromJson(Map<String, dynamic> json) {
    return ShopingExperianceModel(
      user: User.fromJson(json['user']),
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.tryParse(json['created_at']),
      product: Products.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'rating': rating,
      'comment': comment,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'product': product.toJson(),
    };
  }
}
