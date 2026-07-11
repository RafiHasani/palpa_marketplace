class ImageModel {
  final String? uuid;
  final String? path;
  final bool isFeatured;

  ImageModel({this.uuid, this.path, this.isFeatured = false});

  Map<String, dynamic> toJson() {
    return {'uuid': uuid, 'path': path, 'is_featured': isFeatured};
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      uuid: json['uuid'],
      path: json['path'],
      isFeatured: json['is_featured'],
    );
  }

  ImageModel copyWith({String? uuid, String? path, bool? isFeatured}) {
    return ImageModel(
      uuid: uuid ?? this.uuid,
      path: path ?? this.path,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
