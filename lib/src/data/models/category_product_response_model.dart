import 'package:equatable/equatable.dart';
import 'category_model.dart';

class CategoryProductResponseModel extends Equatable {
  final CategoryModel? data;

  const CategoryProductResponseModel({required this.data});

  factory CategoryProductResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductResponseModel(
      data: (json['data'] != null)
          ? CategoryModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }

  @override
  List<Object?> get props => [data];
}
