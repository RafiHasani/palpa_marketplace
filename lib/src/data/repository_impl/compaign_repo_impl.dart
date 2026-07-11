import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/constants/endpoints.dart';
import 'package:palpa_marketplace/src/core/network/dio_provider.dart';
import 'package:palpa_marketplace/src/core/network/dio_service.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/compaign_response_model.dart';
import 'package:palpa_marketplace/src/domain/repositories/compaign_repo.dart';

final compaignRepoImplProvider = Provider((ref) {
  return CompaignRepoImpl(dio: ref.read(dioServiceProvider));
});

class CompaignRepoImpl implements CompaignRepo {
  @override
  DioService dio;
  CompaignRepoImpl({required this.dio});

  @override
  Future<Either<ErrorModel, CompaignResponseModel>> getCompaigns() async {
    try {
      final response = await dio.get(Endpoints.getCompaigns);
      if (response.statusCode == 200) {
        final json = response.data;

        final categories = CompaignResponseModel.fromJson(json);

        return Right(categories);
      } else {
        return Left(
          ErrorModel(
            error: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(e.error as ErrorModel);
    }
  }
}
