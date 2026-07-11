import 'package:equatable/equatable.dart';
import 'package:palpa_marketplace/src/data/models/compaign_model.dart';

class CompaignResponseModel extends Equatable {
  final List<CompaignModel>? data;

  const CompaignResponseModel({required this.data});

  factory CompaignResponseModel.fromJson(Map<String, dynamic> json) {
    return CompaignResponseModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CompaignModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [data];
}
