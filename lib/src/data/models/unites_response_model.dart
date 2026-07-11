import 'package:palpa_marketplace/src/data/models/unit_model.dart';

class UnitesResponseModel {
  final List<UnitModel>? data;
  const UnitesResponseModel({required this.data});

  factory UnitesResponseModel.fromJson(Map<String, dynamic> json) {
    return UnitesResponseModel(
      data: List<UnitModel>.from(
        json['data']?.map((x) => UnitModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((x) => x.toJson()).toList()};
  }
}
