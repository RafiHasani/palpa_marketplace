import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/utils/api_call_status.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/site_settings_resonse_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/general_api_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/general_api_repo.dart';

final generalApisProvider =
    StateNotifierProvider<GeneralApisNotifier, GeneralApiState>((ref) {
      final repo = ref.read(generalRepoImplProvider);
      return GeneralApisNotifier(repo: repo);
    });

class GeneralApisNotifier extends StateNotifier<GeneralApiState> {
  final GeneralApiRepo repo;

  GeneralApisNotifier({required this.repo}) : super(GeneralApiState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await getProvince();
    await getUnites();
    await getCategories();
  }

  Future<void> getProvince() async {
    try {
      state = state.copyWith(apiCallStatus: .loading);

      final response = await repo.getProvince();

      return response.fold(
        (error) {
          state = state.copyWith(errorModel: error, apiCallStatus: .error);
        },
        (province) {
          Appconfig().province = province.data;
          state = state.copyWith(
            apiCallStatus: .complete,
            province: province.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorModel: ErrorModel(error: 'Something went wrong', statusCode: 400),
      );
    }
  }

  Future<void> getUnites() async {
    try {
      state = state.copyWith(apiCallStatus: .loading);

      final response = await repo.getUnits();

      return response.fold(
        (error) {
          state = state.copyWith(errorModel: error, apiCallStatus: .error);
        },
        (unites) {
          Appconfig().unites = unites.data;
          state = state.copyWith(apiCallStatus: .complete, unites: unites.data);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorModel: ErrorModel(error: 'Something went wrong', statusCode: 400),
      );
    }
  }

  Future<void> getCategories() async {
    try {
      state = state.copyWith(apiCallStatus: .loading);

      final response = await repo.getCategories();

      return response.fold(
        (error) {
          state = state.copyWith(errorModel: error, apiCallStatus: .error);
        },
        (categories) {
          state = state.copyWith(
            apiCallStatus: .complete,
            categories: categories,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorModel: ErrorModel(error: 'Something went wrong', statusCode: 400),
      );
    }
  }

  Future<void> getSiteSetting() async {
    try {
      state = state.copyWith(apiCallStatus: .loading);

      final response = await repo.getSiteSettings();

      return response.fold(
        (error) {
          state = state.copyWith(errorModel: error, apiCallStatus: .error);
        },
        (settings) {
          state = state.copyWith(
            apiCallStatus: .complete,
            settingModel: settings.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorModel: ErrorModel(error: 'Something went wrong', statusCode: 400),
      );
    }
  }
}

class GeneralApiState extends Equatable {
  final ApiCallStatus apiCallStatus;
  final ErrorModel? errorModel;
  final List<ProvinceModel>? province;
  final List<UnitModel>? unites;
  final CategoryResponseModel? categories;
  final CategoryResponseModel? subCategory;
  final SiteSettingModel? settingModel;

  final UnitModel? selectedUnit;

  const GeneralApiState({
    required this.apiCallStatus,
    this.errorModel,
    this.province,
    this.unites,
    this.categories,
    this.subCategory,
    this.selectedUnit,
    this.settingModel,
  });

  const GeneralApiState.initial()
    : apiCallStatus = .initial,
      errorModel = null,
      province = null,
      unites = null,
      categories = null,
      subCategory = null,
      selectedUnit = null,
      settingModel = null;

  GeneralApiState copyWith({
    ApiCallStatus? apiCallStatus,
    ErrorModel? errorModel,
    List<ProvinceModel>? province,
    List<UnitModel>? unites,
    CategoryResponseModel? categories,
    CategoryResponseModel? subCategory,
    UnitModel? selectedUnit,
    SiteSettingModel? settingModel,
  }) {
    return GeneralApiState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      errorModel: errorModel ?? this.errorModel,
      province: province ?? this.province,
      unites: unites ?? this.unites,
      categories: categories ?? this.categories,
      subCategory: subCategory ?? this.subCategory,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      settingModel: settingModel ?? this.settingModel,
    );
  }

  @override
  List<Object?> get props => [
    apiCallStatus,
    errorModel,
    province,
    unites,
    categories,
    subCategory,
    selectedUnit,
    settingModel,
  ];
}
