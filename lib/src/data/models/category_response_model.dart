import 'package:equatable/equatable.dart';
import 'category_model.dart';

class CategoryResponseModel extends Equatable {
  final List<CategoryModel>? data;

  const CategoryResponseModel({required this.data});

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [data];
}
