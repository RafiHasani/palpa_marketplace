import 'package:palpa_marketplace/src/data/models/user.dart';

class AuthResponseModel {
  final User? user;
  final String? token;

  AuthResponseModel({this.user, this.token});

  AuthResponseModel copyWith({User? data, String? token}) =>
      AuthResponseModel(user: user ?? user, token: token ?? this.token);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'token': token};
  }
}

class UpdateResponseModel {
  final User? user;

  UpdateResponseModel({this.user});

  UpdateResponseModel copyWith({User? data, String? token}) =>
      UpdateResponseModel(user: user ?? user);

  factory UpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateResponseModel(user: User.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson()};
  }
}
