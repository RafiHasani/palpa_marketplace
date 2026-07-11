import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/product_details_model.dart';
import 'package:palpa_marketplace/src/data/models/product_review_response_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/product_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/product_repo.dart';

final productDetailsProvider =
    NotifierProvider<ProductDetailsNotifier, ProductDetailsState>(
      isAutoDispose: true,
      ProductDetailsNotifier.new,
    );

class ProductDetailsNotifier extends Notifier<ProductDetailsState> {
  late ProductRepo repo;
  @override
  ProductDetailsState build() {
    repo = ref.read(productRepoImplProvider);
    return ProductDetailsState.initial();
  }

  Future<void> getProducteDetailsData({
    required String slug,
    String? query,
    bool? hideLoader,
  }) async {
    if (!(hideLoader ?? false)) {
      state = state.copyWith(apiCallStatus: .gettingProductDetails);
    }

    try {
      final response = await repo.getProductDetailsBySlug(
        slug: slug,
        qeury: query,
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingProductDetailsFaild,
          );
        },
        (productDetails) {
          state = state.copyWith(
            apiCallStatus: .gettingProductDetailsSuccess,
            productDetailsModel: productDetails,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingProductDetailsFaild,
      );
    }
  }

  Future<void> getProducteReviews({required String slug, String? query}) async {
    try {
      state = state.copyWith(apiCallStatus: .gettingProductReivewDetails);

      final response = await repo.getProductReviewBySlug(
        slug: slug,
        qeury: query,
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingProductReivewDetailsFaild,
          );
        },
        (productDetails) {
          state = state.copyWith(
            apiCallStatus: .gettingProductReivewDetailsSuccess,
            productReviewResponseModel: productDetails,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingProductReivewDetailsFaild,
      );
    }
  }

  Future<bool?> likeProduct({required String slug, String? qeury}) async {
    try {
      state = state.copyWith(apiCallStatus: .likingProduct);
      final response = await repo.likeProduct(slug: slug, qeury: null);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .likingProductFaild,
          );
          return false;
        },
        (searchProducts) async {
          getProducteDetailsData(slug: slug, hideLoader: true);
          state = state.copyWith(apiCallStatus: .likingProductSuccess);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .likingProductFaild,
      );
      return false;
    }
  }

  Future<void> dislikeProduct({
    required String slug,
    String? qeury,
    bool? hideLoader,
  }) async {
    try {
      if (!(hideLoader ?? false)) {
        state = state.copyWith(apiCallStatus: .disLikingProduct);
      }

      final response = await repo.dislikeProduct(
        slug: slug,
        qeury: {'filter': qeury ?? ''},
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .disLikingProductFaild,
          );
        },
        (searchProducts) async {
          getProducteDetailsData(slug: slug, hideLoader: true);
          state = state.copyWith(apiCallStatus: .disLikingProductSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .disLikingProductFaild,
      );
    }
  }
}

class ProductDetailsState extends Equatable {
  final ProductDetailsApiState? apiCallStatus;
  final ProductDetailsModel? productDetailsModel;
  final ProductReviewResponseModel? productReviewResponseModel;
  final ErrorModel? errorMessage;

  const ProductDetailsState({
    this.apiCallStatus,
    this.productDetailsModel,
    this.errorMessage,
    this.productReviewResponseModel,
  });

  const ProductDetailsState.initial()
    : apiCallStatus = .initial,
      productDetailsModel = null,
      errorMessage = null,
      productReviewResponseModel = null;

  ProductDetailsState copyWith({
    ProductDetailsApiState? apiCallStatus,
    ProductDetailsModel? productDetailsModel,
    ProductReviewResponseModel? productReviewResponseModel,
    ErrorModel? errorMessage,
  }) {
    return ProductDetailsState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      productDetailsModel: productDetailsModel ?? this.productDetailsModel,
      productReviewResponseModel:
          productReviewResponseModel ?? this.productReviewResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    apiCallStatus,
    productDetailsModel,
    productReviewResponseModel,
    errorMessage,
  ];
}

enum ProductDetailsApiState {
  initial,
  // gettingProductDetails
  gettingProductDetails,
  gettingProductDetailsFaild,
  gettingProductDetailsSuccess,

  // gettingProductDetailsReview
  gettingProductReivewDetails,
  gettingProductReivewDetailsFaild,
  gettingProductReivewDetailsSuccess,

  // likingProduct
  likingProduct,
  likingProductFaild,
  likingProductSuccess,

  // disLikingProduct
  disLikingProduct,
  disLikingProductFaild,
  disLikingProductSuccess,
}
