import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_category_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_product_list_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/notifications_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_details_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/search_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/category_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/compaign_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/network_status_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_main_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/circular_progress_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/heading_row_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/item_card_list_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class ProducerHomePage extends ConsumerStatefulWidget {
  static const String path = '/producerhomepage';
  const ProducerHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerHomePageState();
}

class _ProducerHomePageState extends ConsumerState<ProducerHomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    final futures = <Future>[];

    futures.add(
      ref.read(producerProductProvider.notifier).getProducerDashboard(),
    );

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
                    context.local.no_internet,
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
      if (prev != next) {
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
      key: Key(TestKeys.producerHomePath),
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
                          context.push(
                            context.getRouterCurrentPath +
                                ProducerCategoryPage.path,
                          );
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
                                      ProducerProductListPage.path,
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

              SliverToBoxAdapter(child: 42.verticalSpace),
            ],
          ),
        ),
      ),
    );
  }
}
