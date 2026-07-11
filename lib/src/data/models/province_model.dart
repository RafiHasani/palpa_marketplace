import 'package:equatable/equatable.dart';

class ProvinceResponseModel {
  final List<ProvinceModel>? data;
  const ProvinceResponseModel({this.data});

  factory ProvinceResponseModel.fromJson(Map<String, dynamic> json) {
    return ProvinceResponseModel(
      data: List<ProvinceModel>.from(
        json['data']?.map((x) => ProvinceModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((x) => x.toJson()).toList()};
  }
}

class ProvinceModel extends Equatable {
  final String slug;
  final String name;
  const ProvinceModel({required this.slug, required this.name});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(slug: json['slug'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name};
  }

  @override
  List<Object?> get props => [slug];
}
