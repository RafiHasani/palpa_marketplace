import 'package:equatable/equatable.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';

class CategoryModel extends Equatable {
  final String name;
  final String slug;
  final String? icon;
  final int productsCount;
  final List<CategoryModel>? children;
  final CategoryModel? parent;
  final List<Products>? products;

  const CategoryModel({
    required this.name,
    required this.slug,
    this.icon,
    required this.productsCount,
    this.children,
    this.products,
    this.parent,
  });

  CategoryModel copyWith({
    String? name,
    String? slug,
    String? icon,
    int? productsCount,
    final List<CategoryModel>? children,
    final CategoryModel? parent,
    final List<Products>? products,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      productsCount: productsCount ?? this.productsCount,
      children: children ?? this.children,
      parent: parent ?? this.parent,
      products: products ?? this.products,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<CategoryModel> children = <CategoryModel>[];
    CategoryModel? parent;
    List<Products> products = <Products>[];

    if (json['children'] != null) {
      json['children'].forEach((v) {
        children.add(CategoryModel.fromJson(v));
      });
    }

    if (json['parent'] != null) {
      parent = CategoryModel.fromJson(json['parent']);
    }

    if (json['products'] != null) {
      json['products'].forEach((v) {
        products.add(Products.fromJson(v));
      });
    }
    return CategoryModel(
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'],
      productsCount: json['products_count'],
      children: children,
      products: products,
      parent: parent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'icon': icon,
      'products_count': productsCount,
    };
  }

  @override
  List<Object?> get props => [slug];
}
