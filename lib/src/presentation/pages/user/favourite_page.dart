import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/product_list_card_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/text_button_icon_widget.dart';

class FavouritePage extends ConsumerStatefulWidget {
  static const String path = "/favouritepage";
  const FavouritePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouritePage();
}

class _FavouritePage extends ConsumerState<FavouritePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(productPageProvider.notifier).getFavouriteProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLangProvider, (prev, next) {
      if (prev != next) {
        Future.microtask(() async {
          await ref.read(productPageProvider.notifier).getFavouriteProducts();
        });
      }
    });
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);

    final state = ref.watch(productPageProvider);
    final likedList = state.favouriteProducts?.data ?? [];

    return LoadingWidget(
      isLoading: state.apiCallStatus == .gettingFavouriteProduct,
      child: Scaffold(
        appBar: AppbarPageWidget(
          hideSearch: true,
          titleOnly: true,
          title: context.local.favourites,
        ),
        body: SafeArea(
          child: RefreshIndicator.adaptive(
            color: AppColors.primaryColor,
            onRefresh: () async {
              await ref
                  .read(productPageProvider.notifier)
                  .getFavouriteProducts();
            },
            child: likedList.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.h,
                      crossAxisSpacing: 0.w,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: likedList.length,
                    itemBuilder: (c, index) {
                      final item = likedList[index];
                      return ProductListCardWidget(product: item);
                    },
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 120.h),

                      Center(
                        child: SvgIcon(
                          assetName: 'assets/icons/favourite_cross_icon_.svg',
                        ),
                      ),
                      16.verticalSpace,

                      Center(
                        child: Text(
                          context.local.no_favourites_yet,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                      4.verticalSpace,

                      Center(
                        child: Text(
                          context.local.no_favourites_list,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.subTitileTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      16.verticalSpace,

                      Center(
                        child: TextIconButtonWidget(
                          iconAlignment: .center,
                          actionTextIconButton: () {
                            context.go(HomePage.path);
                          },
                          actionButtonTitle: context.local.go_explore_market,
                          icon: getOpenArrowIcon(local),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
