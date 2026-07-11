class SalerModel {
  final String username;
  final String? email;
  final String? phone;
  final String? fullName;
  final String? avatar;
  final String? bio;

  SalerModel({
    this.fullName,
    this.avatar,
    this.bio,
    required this.username,
    this.email,
    this.phone,
  });

  factory SalerModel.fromJson(Map<String, dynamic> json) {
    return SalerModel(
      fullName: json['full_name'],
      avatar: json['avatar'],
      bio: json['bio'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'avatar': avatar,
      'bio': bio,
    };
  }
}
