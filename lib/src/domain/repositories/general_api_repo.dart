import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_response_model.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/site_settings_resonse_model.dart';
import 'package:palpa_marketplace/src/data/models/unites_response_model.dart';

abstract class GeneralApiRepo {
  late final DioService dio;
  Future<Either<ErrorModel, UnitesResponseModel>> getUnits();
  Future<Either<ErrorModel, ProvinceResponseModel>> getProvince();

  Future<Either<ErrorModel, CategoryResponseModel>> getCategories();

  Future<Either<ErrorModel, CategoryResponseModel>> getSubCategories();
  Future<Either<ErrorModel, SiteSettingsResonseModel>> getSiteSettings();
}
