import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/image_model.dart';
import 'package:palpa_marketplace/src/data/models/rating_breakdown_model.dart';
import 'package:palpa_marketplace/src/data/models/saler_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';

class ProductDetailsModel {
  final String slug;
  final String name;
  final Map<String, dynamic>? about;
  final Map<String, dynamic>? description;
  final CategoryModel category;
  final UnitModel unit;
  final List<ImageModel> thumbnails;
  final List<ImageModel> images;
  final String price;
  final String? discountPrice;
  final bool? hasDiscount;
  final int stock;
  final String province;
  final String? ratingsAverage;
  final int? ratingsCount;
  final Map<String, RatingsBreakdown> ratingsBreakdown;
  final int? reviewsCount;
  final SalerModel saler;
  bool? isLiked;
  bool? isActive;

  ProductDetailsModel({
    required this.slug,
    required this.name,
    required this.about,
    required this.description,
    required this.category,
    required this.unit,
    required this.thumbnails,
    required this.images,
    required this.price,
    required this.discountPrice,
    required this.hasDiscount,
    required this.stock,
    required this.province,
    required this.ratingsAverage,
    required this.ratingsCount,
    required this.ratingsBreakdown,
    required this.reviewsCount,
    required this.saler,
    this.isActive,
    this.isLiked,
  });

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'about': about,
      'description': description,
      'category': category.toJson(),
      'unit': unit.toJson(),
      'thumbnails': thumbnails.map((x) => x.toJson()).toList(),
      'images': images.map((x) => x.toJson()).toList(),
      'price': price,
      'discountPrice': discountPrice,
      'hasDiscount': hasDiscount,
      'stock': stock,
      'province': province,
      'ratingsAverage': ratingsAverage,
      'ratingsCount': ratingsCount,
      'ratingsBreakdown': ratingsBreakdown,
      'reviewsCount': reviewsCount,
      'saler': saler.toJson(),
      'isLiked': isLiked,
      'isActive': isActive,
    };
  }

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, RatingsBreakdown> ratingsBreakdowns = {};

    if (json['ratings_breakdown'] != null) {
      final mapJson = json['ratings_breakdown'] as Map<String, dynamic>;

      ratingsBreakdowns = mapJson.map(
        (key, value) => MapEntry(key, RatingsBreakdown.fromJson(value)),
      );
    }

    Map<String, dynamic> about = {};

    if (json['about'] != null) {
      final mapJson = json['about'] as Map<String, dynamic>;
      debugPrint(mapJson.toString());
      about = mapJson;
    }

    Map<String, dynamic> description = {};
    if (json['description'] != null) {
      final mapJson = json['description'] as Map<String, dynamic>;
      debugPrint(mapJson.toString());
      description = mapJson;
    }

    return ProductDetailsModel(
      slug: json['slug'],
      name: json['name'],
      about: about,
      description: description,
      category: CategoryModel.fromJson(json['category']),
      unit: UnitModel.fromJson(json['unit']),
      thumbnails: List<ImageModel>.from(
        json['thumbnails']?.map((x) => ImageModel.fromJson(x)),
      ),
      images: List<ImageModel>.from(
        json['images']?.map((x) => ImageModel.fromJson(x)),
      ),
      price: json['price'],
      discountPrice: json['discounted_price'],
      hasDiscount: json['has_discount'],
      stock: json['stock'],
      province: json['province'],
      ratingsAverage: json['ratings_average'],
      ratingsCount: json['ratings_count'],
      ratingsBreakdown: ratingsBreakdowns,
      reviewsCount: json['reviews_count'],
      saler: SalerModel.fromJson(json['seller']),
      isLiked: json['is_liked'],
      isActive: json['is_active'],
    );
  }
}
