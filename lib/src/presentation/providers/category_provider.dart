import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/utils/api_call_status.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/data/repository_impl/category_repo_impl.dart';
import 'package:palpa_marketplace/src/domain/repositories/category_repo.dart';

final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(
  CategoryNotifier.new,
);

class CategoryNotifier extends Notifier<CategoryState> {
  late CategoryRepo repo;

  @override
  CategoryState build() {
    repo = ref.read(categoryRepoImplProvider);
    return CategoryState.initial();
  }

  Future<void> getCategories() async {
    try {
      state = state.copyWith(apiCallStatus: .loading);
      //products,children,parent
      final response = await repo.getCategory();

      return response.fold(
        (error) {
          state = state.copyWith(errorMessage: error, apiCallStatus: .error);
        },
        (categories) {
          state = state.copyWith(
            apiCallStatus: .complete,
            categoryListHome: categories.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: ApiCallStatus.error,
      );
    }
  }

  Future<void> getCategoriesPageData() async {
    state = state.copyWith(apiCallStatus: .loading);
    try {
      final response = await repo.getCategory(qeury: 'children');

      return response.fold(
        (error) {
          state = state.copyWith(errorMessage: error, apiCallStatus: .error);
        },
        (categories) {
          state = state.copyWith(
            apiCallStatus: .complete,
            categoryPageData: categories.data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: ErrorModel(
          error: 'Something went wrong',
          statusCode: 400,
        ),
        apiCallStatus: .error,
      );
    }
  }

  Future<void> getCategoriesBySlug(String slug) async {
    try {
      state = state.copyWith(apiCallStatus: .loading);

      final response = await repo.getCategoryBySlug(slug);

      return response.fold((error) {}, (categories) {
        state = state.copyWith(
          apiCallStatus: .complete,
          categoryListHome: categories.data,
        );
      });
    } catch (e) {
      state = state.copyWith(apiCallStatus: .error);
    }
  }
}

class CategoryState extends Equatable {
  final ApiCallStatus apiCallStatus;
  final ErrorModel? errorMessage;
  final List<CategoryModel>? categoryListHome;
  final List<CategoryModel>? categoryPageData;

  const CategoryState({
    this.apiCallStatus = .initial,
    this.categoryListHome,
    this.errorMessage,
    this.categoryPageData,
  });

  const CategoryState.initial()
    : apiCallStatus = .initial,
      errorMessage = null,
      categoryListHome = const [],
      categoryPageData = const [];

  CategoryState copyWith({
    ApiCallStatus? apiCallStatus,
    ErrorModel? errorMessage,
    List<CategoryModel>? categoryListHome,
    List<CategoryModel>? categoryPageData,
  }) {
    return CategoryState(
      apiCallStatus: apiCallStatus ?? this.apiCallStatus,
      errorMessage: this.errorMessage,
      categoryListHome: categoryListHome ?? this.categoryListHome,
      categoryPageData: categoryPageData ?? this.categoryPageData,
    );
  }

  @override
  List<Object?> get props => [
    apiCallStatus,
    errorMessage,
    categoryListHome,
    categoryPageData,
  ];
}
