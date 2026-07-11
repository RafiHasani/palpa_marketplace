import 'package:equatable/equatable.dart';

class UnitModel extends Equatable {
  final String symbol;
  final String name;

  const UnitModel({required this.symbol, required this.name});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(symbol: json['symbol'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'symbol': symbol, 'name': name};
  }

  @override
  List<Object?> get props => [symbol];
}
