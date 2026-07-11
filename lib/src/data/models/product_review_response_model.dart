import 'package:palpa_marketplace/src/data/models/meta.dart';

class ProductReviewResponseModel {
  final List<ReviewModel>? data;
  final Meta? meta;

  ProductReviewResponseModel({this.data, this.meta});

  factory ProductReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewResponseModel(
      data: List<ReviewModel>.from(
        json['data']?.map((x) => ReviewModel.fromJson(x)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class ReviewModel {
  final ReviewUser? user;
  final int? rating;
  final String? comment;
  final String? createdAt;

  ReviewModel({this.user, this.rating, this.comment, this.createdAt});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      user: ReviewUser.fromJson(json['user']),
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}

class ReviewUser {
  final String? fullName;
  final String? avatar;
  final String? username;

  ReviewUser({this.fullName, this.avatar, this.username});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      fullName: json['full_name'],
      avatar: json['avatar'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'full_name': fullName, 'avatar': avatar, 'username': username};
  }
}
