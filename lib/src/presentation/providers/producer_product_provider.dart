import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/data/models/producer_orders_others_response_model.dart';
import 'package:palpa_marketplace/src/data/models/product_details_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/order_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/order_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/my_product_review_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_dashboard_response_model.dart';
import 'package:palpa_marketplace/src/data/models/producer_product_details_model.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/product_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/product_repo.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';

final producerProductProvider =
    StateNotifierProvider<ProducerProductNotifier, ProducerProductState>((ref) {
      final prefs = ref.read(sharedPreferencesProvider);
      final repo = ref.read(productRepoImplProvider);
      final orderRepo = ref.read(orderRepoImplProvider);

      return ProducerProductNotifier(
        repo: repo,
        prefs: prefs,
        orderRepo: orderRepo,
      );
    });

class ProducerProductNotifier extends StateNotifier<ProducerProductState> {
  final ProductRepo repo;
  final OrderRepo orderRepo;
  final SharedPreferences prefs;

  ProducerProductNotifier({
    required this.repo,
    required this.prefs,
    required this.orderRepo,
  }) : super(ProducerProductState.initial());

  Future<void> createProduct(CreateProductState productState) async {
    state = state.copyWith(producerApiStatus: .creatingMyProduct);
    try {
      final response = await repo.createProduct(body: productState);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .creatingMyProductFailed,
          );
        },
        (likedProducts) async {
          state = state.copyWith(producerApiStatus: .creatingMyProductSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .creatingMyProductFailed,
      );
    }
  }

  Future<void> updateProduct(
    CreateProductState productState,
    String slug,
  ) async {
    state = state.copyWith(producerApiStatus: .updatingMyProduct);
    try {
      final response = await repo.updateProduct(body: productState, slug: slug);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .updatingMyProductFailed,
          );
        },
        (likedProducts) async {
          state = state.copyWith(producerApiStatus: .updatingMyProductSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .updatingMyProductFailed,
      );
    }
  }

  Future<void> getMyProducts() async {
    try {
      state = state.copyWith(producerApiStatus: .gettingMyProduct);
      final response = await repo.getMyProducts();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingMyProductFailed,
          );
        },
        (myProducts) async {
          state = state.copyWith(
            producerApiStatus: .gettingMyProductSuccess,
            myProductsList: myProducts.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingMyProductFailed,
      );
    }
  }

  Future<void> getProducerDashboard() async {
    try {
      state = state.copyWith(producerApiStatus: .gettingDashboard);
      final response = await repo.getProducerDashboard();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingDashboardFailed,
          );
        },
        (producerDashboard) async {
          state = state.copyWith(
            producerApiStatus: .gettingDashboardSuccess,
            producerDashboard: producerDashboard.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingDashboardFailed,
      );
    }
  }

  Future<void> activeInactiveProduct({required String slug}) async {
    try {
      state = state.copyWith(producerApiStatus: .updatingMyProductStatus);

      final response = await repo.updateProductStatus(slug: slug);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .updatingMyProductStatusFailed,
          );
        },
        (updating) {
          state = state.copyWith(
            producerApiStatus: .updatingMyProductStatusSuccess,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .updatingMyProductStatusFailed,
      );
    }
  }

  Future<void> getProducerProducteDetails({required String slug}) async {
    try {
      state = state.copyWith(producerApiStatus: .gettingMyProductDetails);
      //products,children,parent
      final response = await repo.producerGetProductDetails(slug: slug);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingMyProductDetailsFailed,
          );
        },
        (productDetails) {
          state = state.copyWith(
            producerApiStatus: .gettingMyProductDetailsSuccess,
            producerProductDetailsModel: productDetails.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingMyProductDetailsFailed,
      );
    }
  }

  Future<void> getProducteDetailsData({
    required String slug,
    String? query,
  }) async {
    try {
      state = state.copyWith(producerApiStatus: .gettingMyProductBasicDetails);
      //products,children,parent
      final response = await repo.getProductDetailsBySlug(
        slug: slug,
        qeury: query,
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingMyProductBasicDetailsFailed,
          );
        },
        (productDetails) {
          state = state.copyWith(
            producerApiStatus: .gettingMyProductBasicDetailsSuccess,
            showMyProductBasicDetails: productDetails,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingMyProductBasicDetailsFailed,
      );
    }
  }

  Future<void> getOrdersOfMine() async {
    try {
      state = state.copyWith(producerApiStatus: .gettingOrderMine);
      final response = await orderRepo.getProducerOrderOfMine();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingOrderMineFailed,
          );
        },
        (myOrders) async {
          state = state.copyWith(
            producerApiStatus: .gettingOrderMineSuccess,
            producerOthersMine: myOrders,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingOrderMineFailed,
      );
    }
  }

  Future<void> getOrdersOfOther() async {
    try {
      state = state.copyWith(producerApiStatus: .gettingOrderOthers);
      final response = await orderRepo.getProducerOrderOfOthers();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            producerApiStatus: .gettingOrderOthersFailed,
          );
        },
        (otherProducts) async {
          state = state.copyWith(
            producerApiStatus: .gettingOrderOthersSuccess,
            producerOthersOthers: otherProducts,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        producerApiStatus: .gettingOrderOthersFailed,
      );
    }
  }
}

class ProducerProductState extends Equatable {
  final ProducerApiStatus producerApiStatus;
  final ErrorModel? errorMessage;
  final List<Products>? myProductsList;
  final MyProductReviewResponseModel? myProductReviews;
  final ProducerDashboard? producerDashboard;
  final ProducerProductDetailsModel? producerProductDetailsModel;
  final ProductDetailsModel? showMyProductBasicDetails;

  final ProducerOrdersOthersResponseModel? producerOthersMine;
  final ProducerOrdersOthersResponseModel? producerOthersOthers;

  const ProducerProductState({
    this.producerApiStatus = .initial,
    this.errorMessage,
    this.myProductReviews,
    this.myProductsList,
    this.producerDashboard,
    this.producerProductDetailsModel,
    this.showMyProductBasicDetails,
    this.producerOthersMine,
    this.producerOthersOthers,
  });

  const ProducerProductState.initial()
    : producerApiStatus = .initial,
      errorMessage = null,
      myProductReviews = null,
      myProductsList = null,
      producerDashboard = null,
      producerProductDetailsModel = null,
      showMyProductBasicDetails = null,
      producerOthersMine = null,
      producerOthersOthers = null;

  @override
  List<Object?> get props => [
    producerApiStatus,
    errorMessage,
    myProductsList,
    myProductReviews,
    producerDashboard,
    producerProductDetailsModel,
    showMyProductBasicDetails,
    producerOthersMine,
    producerOthersOthers,
  ];

  ProducerProductState copyWith({
    ProducerApiStatus? producerApiStatus,
    ErrorModel? errorMessage,
    List<Products>? myProductsList,
    MyProductReviewResponseModel? myProductReviews,
    ProducerDashboard? producerDashboard,
    ProducerProductDetailsModel? producerProductDetailsModel,
    ProductDetailsModel? showMyProductBasicDetails,
    ProducerOrdersOthersResponseModel? producerOthersMine,
    ProducerOrdersOthersResponseModel? producerOthersOthers,
  }) {
    return ProducerProductState(
      producerApiStatus: producerApiStatus ?? this.producerApiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      myProductsList: myProductsList ?? this.myProductsList,
      myProductReviews: myProductReviews ?? this.myProductReviews,
      producerDashboard: producerDashboard ?? this.producerDashboard,
      producerProductDetailsModel:
          producerProductDetailsModel ?? this.producerProductDetailsModel,
      showMyProductBasicDetails:
          showMyProductBasicDetails ?? this.showMyProductBasicDetails,
      producerOthersMine: producerOthersMine ?? this.producerOthersMine,
      producerOthersOthers: producerOthersOthers ?? this.producerOthersOthers,
    );
  }
}

enum ProducerApiStatus {
  initial,
  gettingMyProduct,
  gettingMyProductFailed,
  gettingMyProductSuccess,
  //product details
  gettingMyProductDetails,
  gettingMyProductDetailsFailed,
  gettingMyProductDetailsSuccess,

  // product detail basic
  gettingMyProductBasicDetails,
  gettingMyProductBasicDetailsFailed,
  gettingMyProductBasicDetailsSuccess,

  // Getting orders mine
  gettingOrderMine,
  gettingOrderMineFailed,
  gettingOrderMineSuccess,

  // Getting orders others
  gettingOrderOthers,
  gettingOrderOthersFailed,
  gettingOrderOthersSuccess,

  //create product
  creatingMyProduct,
  creatingMyProductFailed,
  creatingMyProductSuccess,

  //update product
  updatingMyProduct,
  updatingMyProductFailed,
  updatingMyProductSuccess,

  //Loading Dashboard
  gettingDashboard,
  gettingDashboardFailed,
  gettingDashboardSuccess,

  //updating my product Status
  updatingMyProductStatus,
  updatingMyProductStatusFailed,
  updatingMyProductStatusSuccess,
}
