import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/image_model.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';

class ProducerProductDetailsResponseModel {
  final ProducerProductDetailsModel? data;

  ProducerProductDetailsResponseModel({this.data});

  factory ProducerProductDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProducerProductDetailsResponseModel(
      data: ProducerProductDetailsModel.fromJson(json['data']),
    );
  }
}

class ProducerProductDetailsModel {
  final String? slug;
  final Name? name;
  final About? about;
  final String? rawAbout;
  final About? description;
  final String? rawDescription;
  final CategoryModel? category;
  final UnitModel? unit;
  final List<ImageModel>? thumbnails;
  final List<ImageModel>? images;
  final String? price;
  final String? discountedPrice;
  final bool? hasDiscount;
  final int? stock;
  final ProvinceModel? province;
  final bool? isActive;

  ProducerProductDetailsModel({
    this.slug,
    this.name,
    this.about,
    this.rawAbout,
    this.description,
    this.rawDescription,
    this.category,
    this.unit,
    this.thumbnails,
    this.images,
    this.price,
    this.discountedPrice,
    this.hasDiscount,
    this.stock,
    this.province,
    this.isActive,
  });

  factory ProducerProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProducerProductDetailsModel(
      slug: json['slug'],
      name: Name.fromJson(json['name']),
      about: About.fromJson(json['about']),
      rawAbout: json['rawAbout'],
      description: About.fromJson(json['description']),
      rawDescription: json['rawDescription'],
      category: CategoryModel.fromJson(json['category']),
      unit: UnitModel.fromJson(json['unit']),
      thumbnails: List<ImageModel>.from(
        json['thumbnails']?.map((x) => ImageModel.fromJson(x)),
      ),
      images: List<ImageModel>.from(
        json['images']?.map((x) => ImageModel.fromJson(x)),
      ),
      price: json['price'],
      discountedPrice: json['discounted_price'],
      hasDiscount: json['has_discount'],
      stock: json['stock'],
      province: ProvinceModel.fromJson(json['province']),
      isActive: json['is_active'],
    );
  }
}

class About {
  final En? en;
  final En? fa;
  final En? ps;

  About({this.en, this.fa, this.ps});

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      en: En.fromJson(json['en']),
      fa: En.fromJson(json['fa']),
      ps: En.fromJson(json['ps']),
    );
  }
}

class En {
  final List<dynamic>? ops;

  En({this.ops});

  factory En.fromJson(Map<String, dynamic> json) {
    return En(ops: List<dynamic>.from(json['ops']));
  }
}

class Name {
  final String? en;
  final String? fa;
  final String? ps;

  Name({this.en, this.fa, this.ps});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(en: json['en'], fa: json['fa'], ps: json['ps']);
  }
}
