import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/categories_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/notifications_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_details_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/category_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/compaign_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/network_status_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_main_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/circular_progress_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/heading_row_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/item_card_list_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String path = "/home";
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    Future.microtask(() async {
      await loadData();
    });
    super.initState();
  }

  Future<void> loadData() async {
    final futures = <Future>[];

    futures.add(ref.read(compaignProvider.notifier).getCompaigns());
    futures.add(ref.read(categoryProvider.notifier).getCategories());
    futures.add(
      ref
          .read(productPageProvider.notifier)
          .getProducteFeaturedMostSold(qeury: {'sort': 'sales'}),
    );

    futures.add(
      ref
          .read(productPageProvider.notifier)
          .getProducteFeaturedMostLiked(qeury: {'sort': 'likes'}),
    );

    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    ref.listen<bool>(networkStatusProvider, (pre, next) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      if (!next) {
        messenger.showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 0.7.sh),
            content: Center(
              child: Row(
                children: [
                  Text(
                    'اتصال اینترنت پیدا نشد!',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            duration: const Duration(days: 1),
            backgroundColor: AppColors.red,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10.r),
            ),
          ),
        );
      } else {
        messenger.hideCurrentSnackBar();
      }
    });
    ref.listen(networkStatusProvider, (prev, next) {
      if (next) {
        loadData();
      }
    });

    ref.listen(appLangProvider, (prev, next) {
      if (next != prev) {
        loadData();
      }
    });
    final categoriesState = ref.read(categoryProvider);

    final categories = categoriesState.categoryListHome ?? [];

    final productLoadState = ref.watch(productPageProvider);

    final productsMostSoled =
        ref.read(productPageProvider).productsMostSold?.data ?? [];

    final productsMostliked =
        ref.read(productPageProvider).productsMostLiked?.data ?? [];

    return Scaffold(
      key: ValueKey(TestKeys.userHomePath),
      //App bar
      appBar: AppbarMainWidget(
        isEnable: false,
        onSearchClicked: () {
          context.push(context.getRouterCurrentPath + SearchPage.path);
        },
        onIconClicked: () {
          context.push(context.getRouterCurrentPath + NotificationsPage.path);
        },
      ),

      body: SafeArea(
        child: RefreshIndicator.adaptive(
          color: AppColors.primaryColor,
          onRefresh: () async {
            Future.microtask(() {
              loadData();
            });
          },
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: 16.verticalSpace),
              SliverToBoxAdapter(
                child: Padding(
                  padding: .symmetric(horizontal: 16.w),
                  child: BannerWidget(),
                ),
              ),
              SliverToBoxAdapter(child: 16.verticalSpace),

              // categories
              SliverToBoxAdapter(
                child: LoadingWidget(
                  isLoading: categoriesState.apiCallStatus == .loading,
                  child: Column(
                    children: [
                      HeadingRowWidget(
                        title: context.local.categories,
                        actionButtonTitle: context.local.all_categories,
                        isActionAable: true,
                        actionTextButton: () {
                          context.go(CategoriesPage.path);
                        },
                      ),
                      Padding(
                        padding: .symmetric(horizontal: 8.w),
                        child: SizedBox(
                          height: 100.h,
                          child: ListView.builder(
                            itemCount: categories.length,
                            scrollDirection: .horizontal,
                            itemBuilder: (context, index) {
                              final item = categories[index];
                              return CategoryItemsWidget(
                                image: item.icon ?? '',
                                title: item.name,
                                onclick: () => context.push(
                                  context.getRouterCurrentPath +
                                      ProductListPage.path,
                                  extra: item,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: 8.verticalSpace),
              (productLoadState.apiCallStatus == .gettingProductMostSold)
                  ? SliverToBoxAdapter(
                      child: Center(child: CircularProgressWidget()),
                    )
                  : productsMostSoled.isNotEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: .symmetric(vertical: 16.h),
                        child: Column(
                          children: [
                            HeadingRowWidget(title: context.local.best_sellers),
                            8.verticalSpace,
                            SizedBox(
                              height: 270.h,
                              child: ListView.builder(
                                padding: .symmetric(horizontal: 16.w),
                                scrollDirection: .horizontal,
                                itemCount: productsMostSoled.length,
                                itemBuilder: (context, index) {
                                  final item = productsMostSoled[index];
                                  return ItemCardWidget(
                                    products: item,
                                    onclick: () {
                                      context.push(
                                        context.getRouterCurrentPath +
                                            ProductListDetailsPage.path,
                                        extra: item.slug,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(child: SizedBox.shrink()),

              SliverToBoxAdapter(child: 8.verticalSpace),

              // GridView list
              (productLoadState.apiCallStatus == .gettingProductMostLiked)
                  ? SliverToBoxAdapter(
                      child: Center(child: CircularProgressWidget()),
                    )
                  : productsMostliked.isNotEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: .symmetric(vertical: 16.h),
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            HeadingRowWidget(title: context.local.most_loved),
                            8.verticalSpace,
                            Padding(
                              padding: .symmetric(horizontal: 16.w),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16.h,
                                      crossAxisSpacing: 8.w,
                                      childAspectRatio: 0.75,
                                    ),
                                itemCount: productsMostliked.length,
                                itemBuilder: (c, index) {
                                  final item = productsMostliked[index];
                                  return GridItemCardWidget(products: item);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(child: SizedBox.shrink()),

              SliverToBoxAdapter(child: 32.verticalSpace),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemCardWidget extends ConsumerWidget {
  const GridItemCardWidget({super.key, required this.products});
  final Products products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return GestureDetector(
      onTap: () {
        context.push(
          context.getRouterCurrentPath + ProductListDetailsPage.path,
          extra: products.slug,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(10.r),
          border: .all(color: AppColors.cardBorderColor, width: 1.w),
        ),
        clipBehavior: .antiAliasWithSaveLayer,
        child: Column(
          children: [
            Container(
              height: 170.h,
              width: .maxFinite,
              color: AppColors.containerFilledColor,
              padding: .symmetric(horizontal: 16.w),
              child: CachedNetworkImageWidget(
                image: products.thumbnails?.first.path,
                fit: .contain,
              ),
            ),

            Padding(
              padding: .symmetric(vertical: 16.h, horizontal: 8.w),
              child: Column(
                spacing: 8.h,
                mainAxisSize: .min,
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Text(products.name ?? '', style: theme.textTheme.bodyMedium),
                  Row(
                    spacing: 8.w,
                    children: [
                      Text(
                        '${products.price?.toNumber().toLocalNumber(local)} ${context.local.afghani}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      if (products.hasDiscount ?? false)
                        Text(
                          '${products.discountedPrice?.toNumber().toLocalNumber(local)} ${context.local.afghani}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.textFieldHintColor,
                            decorationThickness: 0.5,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItemsWidget extends ConsumerWidget {
  const CategoryItemsWidget({
    super.key,
    required this.image,
    required this.title,
    required this.onclick,
  });
  final String image;
  final String title;

  final Function() onclick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return GestureDetector(
      onTap: () => onclick.call(),
      child: Container(
        width: 80.w,
        padding: .directional(end: 16.w),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            CircleAvatar(
              radius: 28.r,
              child: Container(
                clipBehavior: .antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  shape: .circle,
                  border: .all(color: AppColors.whiteColor, width: 4.w),
                ),
                child: CachedNetworkImageWidget(
                  image: image,
                  fit: .cover,
                  errorWidgetSize: 44.r,
                ),
              ),
            ),
            Text(
              textAlign: .center,
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class BannerWidget extends ConsumerWidget {
  BannerWidget({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compaignState = ref.watch(compaignProvider);
    final compaigns = compaignState.compaignList;

    return ClipRRect(
      borderRadius: .circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(10.r),
          border: .all(color: AppColors.cardBorderColor, width: 0.7.w),
        ),
        height: 140.h,
        child: LoadingWidget(
          isLoading: compaignState.apiCallStatus == .loading,
          child: Stack(
            children: [
              PageView.builder(
                allowImplicitScrolling: true,
                clipBehavior: Clip.antiAlias,
                controller: pageController,
                itemCount: compaigns.length,
                itemBuilder: (context, index) {
                  final item = compaigns[index];
                  return CachedNetworkImageWidget(image: item.banner);
                },
              ),
              if (compaignState.compaignList.isNotEmpty)
                PositionedDirectional(
                  bottom: 8.h,
                  end: 0,
                  start: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: compaigns.length,
                      effect: ExpandingDotsEffect(
                        dotWidth: 6,
                        activeDotColor: AppColors.focueButtonColor,
                        dotColor: AppColors.whiteColor,
                        dotHeight: 4,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
