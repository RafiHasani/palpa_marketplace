import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/category_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_main_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/category_section_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  static const String path = "/categories";
  const CategoriesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(categoryProvider.notifier).getCategoriesPageData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryProvider);

    ref.listen(appLangProvider, (prev, next) {
      ref.read(categoryProvider.notifier).getCategoriesPageData();
    });

    final categoryListHome = ref.watch(categoryProvider).categoryPageData ?? [];

    return Scaffold(
      //App bar
      appBar: AppbarMainWidget(
        isEnable: false,
        onSearchClicked: () =>
            context.push(context.getRouterCurrentPath + SearchPage.path),
      ),
      body: LoadingWidget(
        isLoading: state.apiCallStatus == .loading,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          padding: .only(bottom: 42.h),
          itemCount: categoryListHome.length,
          itemBuilder: (context, index) {
            final item = categoryListHome[index];
            return CategorySectionWidget(
              categoryModel: item,
              onItemClicked: () {
                context.push(
                  context.getRouterCurrentPath + ProductListPage.path,
                  extra: item,
                );
              },
              seeAll: (CategoryModel categoryModel) {
                context.push(
                  context.getRouterCurrentPath + ProductListPage.path,
                  extra: categoryModel,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
