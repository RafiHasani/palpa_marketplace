class CompaignModel {
  final String slug;
  final String name;
  final String banner;
  const CompaignModel({
    required this.slug,
    required this.name,
    required this.banner,
  });

  CompaignModel copyWith({String? slug, String? name, String? banner}) {
    return CompaignModel(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      banner: banner ?? this.banner,
    );
  }

  factory CompaignModel.fromJson(Map<String, dynamic> json) {
    return CompaignModel(
      slug: json['slug'],
      name: json['name'],
      banner: json['banner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'banner': banner};
  }
}
