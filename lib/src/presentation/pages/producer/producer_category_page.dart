import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/category_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/category_section_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class ProducerCategoryPage extends ConsumerStatefulWidget {
  static const String path = "/producercategorypage";
  const ProducerCategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerCategoryPageState();
}

class _ProducerCategoryPageState extends ConsumerState<ProducerCategoryPage> {
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
    final categoryListHome = state.categoryPageData ?? [];

    return Scaffold(
      //App bar
      appBar: AppbarPageWidget(
        isEnable: false,
        searchFillColor: AppColors.whiteColor,
        onSearchClicked: () {
          context.push(context.getRouterCurrentPath + SearchPage.path);
        },
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
                  context.getRouterCurrentPath + ProducerProductListPage.path,
                  extra: item,
                );
              },
              seeAll: (CategoryModel categoryModel) {
                context.push(
                  context.getRouterCurrentPath + ProducerProductListPage.path,
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
