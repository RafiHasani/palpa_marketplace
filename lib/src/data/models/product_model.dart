import 'package:palpa_marketplace/src/data/models/saler_model.dart';

class Products {
  String? slug;
  String? name;
  Unit? unit;
  List<Thumbnails>? thumbnails;
  bool? hasDiscount;
  String? price;
  String? discountedPrice;
  int? stock;
  String? ratingsAverage;
  SalerModel? salerModel;
  bool? isLiked;
  bool? isActive;

  Products({
    this.slug,
    this.name,
    this.unit,
    this.thumbnails,
    this.hasDiscount,
    this.price,
    this.discountedPrice,
    this.stock,
    this.ratingsAverage,
    this.salerModel,
    this.isLiked,
    this.isActive,
  });

  Products.fromJson(Map<String, dynamic> json) {
    SalerModel? saller;
    if (json['seller'] != null) {
      saller = SalerModel.fromJson(json['seller']);
    }

    slug = json['slug'];
    name = json['name'];
    unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null;
    if (json['thumbnails'] != null) {
      thumbnails = <Thumbnails>[];
      json['thumbnails'].forEach((v) {
        thumbnails!.add(Thumbnails.fromJson(v));
      });
    }
    hasDiscount = json['has_discount'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    stock = json['stock'];
    ratingsAverage = json['ratings_average'];
    isLiked = json['is_liked'];
    isActive = json['is_active'];
    salerModel = saller;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slug'] = slug;
    data['name'] = name;
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.map((v) => v.toJson()).toList();
    }
    data['has_discount'] = hasDiscount;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['stock'] = stock;
    data['ratings_average'] = ratingsAverage;
    data['seller'] = salerModel;
    data['is_liked'] = isLiked;
    data['is_active'] = isActive;

    return data;
  }
}

class Unit {
  String? symbol;
  String? name;

  Unit({this.symbol, this.name});

  Unit.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    return data;
  }
}

class Thumbnails {
  String? path;
  bool? isFeatured;

  Thumbnails({this.path, this.isFeatured});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    isFeatured = json['is_featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['is_featured'] = isFeatured;
    return data;
  }
}
