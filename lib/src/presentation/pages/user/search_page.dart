import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/product_list_card_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const String path = '/searchpage';
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPage();
}

class _SearchPage extends ConsumerState<SearchPage> {
  final TextEditingController controller = .new();
  @override
  Widget build(BuildContext context) {
    final productSearchProvider = ref.watch(productPageProvider);
    final productSearched = productSearchProvider.searchedProduct?.data ?? [];

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: LoadingWidget(
        isLoading: productSearchProvider.apiCallStatus == .searchingProduct,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppbarPageWidget(
            controller: controller,
            onSubmitted: (search) {
              final productProvider = ref.read(productPageProvider.notifier);
              productProvider.searchProducts(qeury: search);
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                16.verticalSpace,
                SearchHistoryListWidget(controller: controller),
                16.verticalSpace,

                Expanded(
                  child: Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: GridView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: productSearched.length,
                      itemBuilder: (context, index) {
                        final item = productSearched[index];
                        return ProductListCardWidget(product: item);
                      },
                    ),
                  ),
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class SearchHistoryListWidget extends ConsumerWidget {
  const SearchHistoryListWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);
    final productSearchProvider = ref.watch(productPageProvider);
    final searchHistory = productSearchProvider.searchHistory ?? [];

    return searchHistory.isNotEmpty
        ? Column(
            mainAxisSize: .min,
            children: [
              Padding(
                padding: .symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      context.local.your_search_history,
                      style: theme.textTheme.bodyLarge,
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(productPageProvider.notifier).deletehHistory();
                      },
                      child: SvgIcon(assetName: 'assets/icons/delete.svg'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 56.h,
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: searchHistory.length,
                  padding: .directional(start: 16.w),
                  itemBuilder: (context, index) {
                    final item = searchHistory[index];
                    return InkWell(
                      borderRadius: .circular(65.r),
                      onTap: () {
                        controller.text = item;
                        ref
                            .read(productPageProvider.notifier)
                            .searchProducts(qeury: item);
                      },
                      child: Padding(
                        padding: .directional(end: 8.w),
                        child: Chip(
                          side: BorderSide(color: AppColors.cardBorderColor),
                          backgroundColor: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(56.r),
                          ),
                          label: Row(
                            spacing: 8.w,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                item,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textFieldHint2Color,
                                ),
                              ),
                              getOpenArrowIcon(local),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
