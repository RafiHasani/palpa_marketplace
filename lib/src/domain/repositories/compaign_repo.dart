import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/compaign_response_model.dart';

abstract class CompaignRepo {
  late final DioService dio;

  Future<Either<ErrorModel, CompaignResponseModel>> getCompaigns();
}
