import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/models/my_product_review_response_model.dart';
import 'package:palpa_marketplace/src/data/models/products_response_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/product_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/product_repo.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final productPageProvider =
    StateNotifierProvider.autoDispose<ProductNotifier, ProductState>((ref) {
      final repo = ref.read(productRepoImplProvider);
      final prefs = ref.watch(sharedPreferencesProvider);
      return ProductNotifier(repo: repo, prefs: prefs);
    });

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepo repo;
  final SharedPreferences prefs;

  ProductNotifier({required this.repo, required this.prefs})
    : super(ProductState.initial()) {
    loadSearchHistory();
  }

  Future<void> getCategoriesProductePageData({
    required String slug,
    String? query,
  }) async {
    state = state.copyWith(apiCallStatus: .gettingCategoryProductPage);
    try {
      final response = await repo.getCategoryProductBySlug(
        query: query,
        slug: slug,
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingCategoryProductPageFaild,
          );
        },
        (categories) {
          state = state.copyWith(
            apiCallStatus: ProductApiState.gettingCategoryProductPageSuccess,
            categoryProductPageData: categories.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingCategoryProductPageFaild,
      );
    }
  }

  Future<void> getProducteFeaturedMostSold({Map<String, String>? qeury}) async {
    try {
      state = state.copyWith(apiCallStatus: .gettingProductMostSold);
      final response = await repo.getProductsFeaturing(qeury: qeury);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingProductMostSoldFaild,
          );
        },
        (productFeatured) {
          state = state.copyWith(
            apiCallStatus: .gettingProductMostSoldSuccess,
            productsMostSold: productFeatured,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingProductMostSoldFaild,
      );
    }
  }

  Future<void> getProducteFeaturedMostLiked({
    Map<String, String>? qeury,
  }) async {
    try {
      state = state.copyWith(apiCallStatus: .gettingProductMostLiked);
      final response = await repo.getProductsFeaturing(qeury: qeury);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingProductMostLikedFaild,
          );
        },
        (productFeatured) {
          state = state.copyWith(
            apiCallStatus: .gettingProductMostLikedSuccess,
            productsMostLiked: productFeatured,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingProductMostLikedFaild,
      );
    }
  }

  Future<void> searchProducts({String? qeury}) async {
    try {
      state = state.copyWith(apiCallStatus: .searchingProduct);

      final response = await repo.searchProducts(
        qeury: {
          'filter': {'search': qeury},
        },
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .searchingProductFaild,
          );
        },
        (searchProducts) async {
          await addSearchHistory(qeury);

          state = state.copyWith(
            apiCallStatus: .searchingProductSuccess,
            searchedProduct: searchProducts,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .searchingProductFaild,
      );
    }
  }

  Future<void> addReviewProduct({
    required String slug,
    required Map<String, Object> qeury,
  }) async {
    try {
      state = state.copyWith(apiCallStatus: .addingProductReview);
      final response = await repo.addProductReview(slug: slug, qeury: qeury);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .addingProductReviewFaild,
          );
        },
        (response) async {
          state = state.copyWith(apiCallStatus: .addingProductReviewSuccess);
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .addingProductReviewFaild,
      );
    }
  }

  Future<void> getMyProductReviews() async {
    try {
      state = state.copyWith(apiCallStatus: .gettingMyProductReview);
      final response = await repo.getMyProductReviews();

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingMyProductReviewFaild,
          );
        },
        (reviews) async {
          state = state.copyWith(
            apiCallStatus: .gettingMyProductReviewSuccess,
            myProductReviews: reviews,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingMyProductReviewFaild,
      );
    }
  }

  Future<void> deleteReviewProduct({
    required String slug,
    String? qeury,
  }) async {
    try {
      state = state.copyWith(apiCallStatus: .deletingMyProductReview);
      final response = await repo.deleteProductReview(
        slug: slug,
        qeury: {'filter': qeury ?? ''},
      );

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .deletingMyProductReviewFaild,
          );
        },
        (searchProducts) async {
          await addSearchHistory(qeury);

          state = state.copyWith(
            apiCallStatus: .deletingMyProductReviewSuccess,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .deletingMyProductReviewFaild,
      );
    }
  }

  Future<void> getFavouriteProducts({String? qeury}) async {
    try {
      state = state.copyWith(apiCallStatus: .gettingFavouriteProduct);

      final response = await repo.getProductsLiked(qeury: null);

      return response.fold(
        (error) {
          state = state.copyWith(
            errorMessage: error,
            apiCallStatus: .gettingFavouriteProductFaild,
          );
        },
        (likedProducts) async {
          state = state.copyWith(
            apiCallStatus: .gettingFavouriteProductSuccess,
            favouriteProducts: likedProducts,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .gettingFavouriteProductFaild,
      );
    }
  }

  Future<void> addSearchHistory(String? searchItem) async {
    try {
      if (searchItem != null && searchItem != '') {
        List<String> searchHistoryList = state.searchHistory ?? [];
        if (!searchHistoryList.contains(searchItem)) {
          if (searchHistoryList.length < 10) {
            searchHistoryList.add(searchItem);
            await prefs.setStringList(
              Constants.searchHistory,
              searchHistoryList,
            );
          } else {
            searchHistoryList.removeAt(0);
            searchHistoryList.add(searchItem);
            await prefs.setStringList(
              Constants.searchHistory,
              searchHistoryList,
            );
          }
        }

        state = state.copyWith(searchHistory: searchHistoryList);
      }
    } catch (e) {
      debugPrint('Storing history on local storage faild');
    }
  }

  void loadSearchHistory() {
    List<String>? searchs = prefs.getStringList(Constants.searchHistory);
    state = state.copyWith(searchHistory: searchs);
  }

  void deletehHistory() {
    prefs.remove(Constants.searchHistory);
    state = state.copyWith(searchHistory: []);
  }

  Future<Uint8List?> getImageDataByte(String asset) async {
    return await repo.getImageDataByte(asset);
  }
}

class ProductState extends Equatable {
  final ProductApiState apiCallStatus;
  final ProductApiState? reviewStatus;
  final ErrorModel? errorMessage;
  final CategoryModel? categoryProductPageData;

  final ProductsResponseModel? productsMostSold;
  final ProductsResponseModel? productsMostLiked;

  final ProductsResponseModel? searchedProduct;
  final List<String>? searchHistory;

  final ProductsResponseModel? favouriteProducts;

  final MyProductReviewResponseModel? myProductReviews;

  const ProductState({
    this.apiCallStatus = .initial,
    this.errorMessage,
    this.categoryProductPageData,
    this.productsMostSold,
    this.productsMostLiked,
    this.searchedProduct,
    this.searchHistory,
    this.favouriteProducts,
    this.myProductReviews,
    this.reviewStatus = .initial,
  });

  const ProductState.initial()
    : apiCallStatus = .initial,
      reviewStatus = .initial,
      errorMessage = null,
      categoryProductPageData = null,
      productsMostSold = null,
      productsMostLiked = null,
      searchedProduct = null,
      searchHistory = null,
      favouriteProducts = null,
      myProductReviews = null;

  ProductState copyWith({
    ProductApiState? apiCallStatus,
    ProductApiState? reviewStatus,
    ErrorModel? errorMessage,
    CategoryModel? categoryProductPageData,
    ProductsResponseModel? productsMostSold,
    ProductsResponseModel? productsMostLiked,
    ProductsResponseModel? searchedProduct,
    List<String>? searchHistory,
    ProductsResponseModel? favouriteProducts,
    MyProductReviewResponseModel? myProductReviews,
  }) {
    return ProductState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryProductPageData:
          categoryProductPageData ?? this.categoryProductPageData,
      productsMostSold: productsMostSold ?? this.productsMostSold,
      productsMostLiked: productsMostLiked ?? this.productsMostLiked,
      searchedProduct: searchedProduct ?? this.searchedProduct,
      searchHistory: searchHistory ?? this.searchHistory,
      favouriteProducts: favouriteProducts ?? this.favouriteProducts,
      myProductReviews: myProductReviews ?? this.myProductReviews,
    );
  }

  @override
  List<Object?> get props => [
    apiCallStatus,
    reviewStatus,
    errorMessage,
    categoryProductPageData,
    productsMostSold,
    productsMostLiked,
    searchedProduct,
    searchHistory,
    favouriteProducts,
    myProductReviews,
  ];
}

enum ProductApiState {
  initial,
  // gettingCategoryProductPage
  gettingCategoryProductPage,
  gettingCategoryProductPageFaild,
  gettingCategoryProductPageSuccess,

  // gettingProductMostLiked
  gettingProductMostLiked,
  gettingProductMostLikedFaild,
  gettingProductMostLikedSuccess,

  // gettingProductMostSold
  gettingProductMostSold,
  gettingProductMostSoldFaild,
  gettingProductMostSoldSuccess,

  // searchingProduct
  searchingProduct,
  searchingProductFaild,
  searchingProductSuccess,

  // addingProductReview
  addingProductReview,
  addingProductReviewFaild,
  addingProductReviewSuccess,

  // gettingMyProductReview
  gettingMyProductReview,
  gettingMyProductReviewFaild,
  gettingMyProductReviewSuccess,

  // deletingMyProductReview
  deletingMyProductReview,
  deletingMyProductReviewFaild,
  deletingMyProductReviewSuccess,

  // gettingFavouriteProduct
  gettingFavouriteProduct,
  gettingFavouriteProductFaild,
  gettingFavouriteProductSuccess,
}
