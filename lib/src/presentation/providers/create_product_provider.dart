import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:image_picker/image_picker.dart';

import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/utils/image_compressore.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/image_model.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';

final createProductProvider =
    StateNotifierProvider<CreateProductNotifier, CreateProductState>((ref) {
      return CreateProductNotifier();
    });

class CreateProductNotifier extends StateNotifier<CreateProductState> {
  CreateProductNotifier() : super(CreateProductState.initial());

  void setCurrentStep(int currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void setAboutfa(String aboutfa) {
    state = state.copyWith(aboutfa: aboutfa);
  }

  void setAboutps(String aboutps) {
    state = state.copyWith(aboutps: aboutps);
  }

  void setAbouten(String abouten) {
    state = state.copyWith(abouten: abouten);
  }

  void setDescriptionfa(String descriptionfa) {
    state = state.copyWith(descriptionfa: descriptionfa);
  }

  void setDescriptionps(String descriptionps) {
    state = state.copyWith(descriptionps: descriptionps);
  }

  void setDescriptionen(String descriptionen) {
    state = state.copyWith(descriptionen: descriptionen);
  }

  void setNamefa(String namefa) {
    state = state.copyWith(namefa: namefa);
  }

  void setNameps(String nameps) {
    state = state.copyWith(nameps: nameps);
  }

  void setNameen(String nameen) {
    state = state.copyWith(nameen: nameen);
  }

  void setCategorySlug(CategoryModel? categorySlug) {
    state = state.copyWith(categorySlug: () => categorySlug);
  }

  void setSubCategorySlug(CategoryModel? categorySlug) {
    state = state.copyWith(subCategorySlug: () => categorySlug);
  }

  void resetSubCategory() {
    state = state.copyWith(subCategorySlug: () => null);
  }

  void setUnitSymbol(UnitModel unitSymbol) {
    state = state.copyWith(unitSymbol: unitSymbol);
  }

  void setProvinceSlug(ProvinceModel provinceSlug) {
    state = state.copyWith(provinceSlug: () => provinceSlug);
  }

  void setPrice(num price) {
    state = state.copyWith(price: price);
  }

  void setDiscountedPrice(num discountedPrice) {
    state = state.copyWith(discountedPrice: discountedPrice);
  }

  void setStock(num stock) {
    state = state.copyWith(stock: stock);
  }

  void setLang(Language lang) {
    state = state.copyWith(lang: lang);
  }

  void setActive(bool isActive) {
    state = state.copyWith(isActive: isActive);
  }

  void setImages(List<ImageModel>? images) {
    state = state.copyWith(images: images);
  }

  void deleteImage(int index) {
    List<ImageModel> images = state.images ?? [];

    final image = images[index].copyWith(uuid: ImageState.deleted.label);
    images[index] = image;

    state = state.copyWith(images: images);
  }

  Future<void> pickImages({
    bool allowMultiple = false,
    int imageQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      final images = await picker.pickMultiImage(imageQuality: imageQuality);

      final compressedImages = await ImageCompressionService.compressImages(
        images,
      );

      List<ImageModel> stateImages = state.images ?? [];

      List<ImageModel> imageFiles = compressedImages.map((e) {
        return ImageModel(
          uuid: ImageState.added.label,
          path: e.path,
          isFeatured: false,
        );
      }).toList();

      stateImages.addAll(imageFiles);

      state = state.copyWith(images: stateImages);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void reset() {
    state = state.copyWith(
      categorySlug: () => null,
      subCategorySlug: () => null,
      provinceSlug: null,
      unitSymbol: null,

      namefa: null,
      nameps: null,
      nameen: null,

      descriptionfa: null,
      descriptionps: null,
      descriptionen: null,

      aboutfa: null,
      aboutps: null,
      abouten: null,
      isActive: false,
      currentStep: 1,

      images: null,
    );
  }
}

class CreateProductState extends Equatable {
  final String? aboutfa;
  final String? aboutps;
  final String? abouten;

  final String? descriptionfa;
  final String? descriptionps;
  final String? descriptionen;

  final String? namefa;
  final String? nameps;
  final String? nameen;

  final CategoryModel? categorySlug;
  final CategoryModel? subCategorySlug;
  final UnitModel? unitSymbol;

  final ProvinceModel? provinceSlug;
  final num? price;
  final num? discountedPrice;
  final num? stock;
  final List<ImageModel>? images;
  final Language? lang;
  final bool? isActive;

  final int currentStep;

  const CreateProductState({
    this.aboutfa,
    this.aboutps,
    this.abouten,
    this.descriptionfa,
    this.descriptionps,
    this.descriptionen,
    this.namefa,
    this.nameps,
    this.nameen,
    this.categorySlug,
    this.subCategorySlug,
    this.unitSymbol,
    this.provinceSlug,
    this.price,
    this.discountedPrice,
    this.stock,
    this.images,
    this.lang,
    this.isActive,
    this.currentStep = 1,
  });

  const CreateProductState.initial()
    : aboutfa = null,
      aboutps = null,
      abouten = null,

      descriptionfa = null,
      descriptionps = null,
      descriptionen = null,

      namefa = null,
      nameps = null,
      nameen = null,

      categorySlug = null,
      subCategorySlug = null,

      unitSymbol = null,

      provinceSlug = null,
      price = null,
      discountedPrice = null,
      stock = null,
      images = null,
      lang = null,
      isActive = null,
      currentStep = 1;

  CreateProductState copyWith({
    String? aboutfa,
    String? aboutps,
    String? abouten,
    String? descriptionfa,
    String? descriptionps,
    String? descriptionen,
    String? namefa,
    String? nameps,
    String? nameen,
    CategoryModel? Function()? categorySlug,
    CategoryModel? Function()? subCategorySlug,
    UnitModel? unitSymbol,
    ProvinceModel? Function()? provinceSlug,
    num? price,
    num? discountedPrice,
    num? stock,
    List<ImageModel>? images,
    Language? lang,
    bool? isActive,
    int? currentStep,
  }) {
    return CreateProductState(
      aboutfa: aboutfa ?? this.aboutfa,
      aboutps: aboutps ?? this.aboutps,
      abouten: abouten ?? this.abouten,
      descriptionfa: descriptionfa ?? this.descriptionfa,
      descriptionps: descriptionps ?? this.descriptionps,
      descriptionen: descriptionen ?? this.descriptionen,
      namefa: namefa ?? this.namefa,
      nameps: nameps ?? this.nameps,
      nameen: nameen ?? this.nameen,
      categorySlug: categorySlug != null ? categorySlug() : this.categorySlug,
      subCategorySlug: subCategorySlug != null
          ? subCategorySlug()
          : this.subCategorySlug,
      unitSymbol: unitSymbol ?? this.unitSymbol,
      provinceSlug: provinceSlug != null ? provinceSlug() : this.provinceSlug,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      lang: lang ?? this.lang,
      isActive: isActive ?? this.isActive,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object?> get props => [
    aboutfa,
    aboutps,
    abouten,
    descriptionfa,
    descriptionps,
    descriptionen,
    namefa,
    nameps,
    nameen,
    categorySlug,
    subCategorySlug,
    unitSymbol,
    provinceSlug,
    price,
    discountedPrice,
    stock,
    images,
    lang,
    isActive,
    currentStep,
  ];
}
