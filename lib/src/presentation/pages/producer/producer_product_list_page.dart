import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/heading_row_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/product_list_card_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/product_list_skaleton_widget.dart';

class ProducerProductListPage extends ConsumerStatefulWidget {
  static const String path = '/producerproductlistpage';

  final CategoryModel categoryModel;

  const ProducerProductListPage({super.key, required this.categoryModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerProductListPageState();
}

class _ProducerProductListPageState
    extends ConsumerState<ProducerProductListPage> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(productPageProvider.notifier)
          .getCategoriesProductePageData(
            slug: widget.categoryModel.slug,
            query: Constants.products,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.read(appLangProvider);
    final state = ref.watch(productPageProvider);

    final productsList = state.categoryProductPageData?.products ?? [];

    return Scaffold(
      //App bar
      backgroundColor: Colors.white,
      appBar: AppbarPageWidget(
        isEnable: false,
        onSearchClicked: () {
          context.push(context.getRouterCurrentPath + SearchPage.path);
        },
      ),
      body: DismissKeyboardWidget(
        child: RefreshIndicator.adaptive(
          color: AppColors.primaryColor,
          onRefresh: () async {
            Future.microtask(() {
              ref
                  .read(productPageProvider.notifier)
                  .getCategoriesProductePageData(
                    slug: widget.categoryModel.slug,
                    query: Constants.products,
                  );
            });
          },
          child: (state.apiCallStatus != .gettingCategoryProductPage)
              ? Column(
                  children: [
                    16.verticalSpace,
                    HeadingRowWidget(
                      title:
                          ' ${widget.categoryModel.productsCount.toLocalNumber(locale)} ${context.local.product_in_category}'
                          '${widget.categoryModel.name}',
                    ),
                    8.verticalSpace,
                    Expanded(
                      child: Padding(
                        padding: .symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8.h,
                                crossAxisSpacing: 8.w,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: productsList.length,
                          itemBuilder: (context, index) {
                            final item = productsList[index];
                            return ProductListCardWidget(product: item);
                          },
                        ),
                      ),
                    ),

                    24.verticalSpace,
                  ],
                )
              : ProductListSkaletonWidget(refresh: () {}),
        ),
      ),
    );
  }
}
