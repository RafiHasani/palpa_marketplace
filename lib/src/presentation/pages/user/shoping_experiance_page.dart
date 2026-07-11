import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/my_product_review_response_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/edit_product_review_sheet.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/shoping_experience_listtile_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/text_button_icon_widget.dart';

class ShopingExperiancePage extends ConsumerStatefulWidget {
  static const String path = '/shopingexperiancepage';
  const ShopingExperiancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShopingExperiancePage();
}

class _ShopingExperiancePage extends ConsumerState<ShopingExperiancePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(productPageProvider.notifier).getMyProductReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(productPageProvider);
    final productReviewList = state.myProductReviews?.data ?? [];
    final proudctProvider = ref.read(productPageProvider.notifier);

    return LoadingWidget(
      isLoading: state.apiCallStatus == .gettingMyProductReview,
      child: Scaffold(
        appBar: AppbarPageWidget(
          hideSearch: true,
          title: context.local.purchase_experiences,
        ),
        body: SafeArea(
          child: RefreshIndicator.adaptive(
            color: AppColors.primaryColor,
            onRefresh: () async {
              Future.microtask(() {
                ref.read(productPageProvider.notifier).getMyProductReviews();
              });
            },
            child: productReviewList.isNotEmpty
                ? ListView.builder(
                    itemCount: productReviewList.length,
                    itemBuilder: (context, index) {
                      final item = productReviewList[index];
                      return ShopingExperienceListTileWidget(
                        optionPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return EditShopingReivewBottomSheet(
                                edit: () {
                                  context.pop();
                                  show(context, item);
                                },
                                delete: () {
                                  proudctProvider.deleteReviewProduct(
                                    slug: item.product.slug ?? '',
                                  );
                                },
                              );
                            },
                          );
                        },
                        item: item,
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: .center,
                    spacing: 8.h,
                    children: [
                      Center(
                        child: SvgIcon(
                          assetName: 'assets/icons/favourite_cross_icon_.svg',
                        ),
                      ),
                      Text(
                        context.local.no_favourites_yet,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        context.local.no_favourites_list,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.subTitileTextColor,
                        ),
                        maxLines: 2,
                      ),
                      16.verticalSpace,
                      TextIconButtonWidget(
                        iconAlignment: .center,
                        actionTextIconButton: () {
                          context.go(HomePage.path);
                        },
                        actionButtonTitle: context.local.go_explore_market,
                        icon: getOpenArrowIcon(local),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> show(
    BuildContext context,
    ShopingExperianceModel? productReview,
  ) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: .only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) => SizedBox(
        height: 0.6.sh,
        child: EditProductReviewSheet(productReview: productReview),
      ),
    );
  }
}

class EditShopingReivewBottomSheet extends ConsumerWidget {
  const EditShopingReivewBottomSheet({
    super.key,
    required this.edit,
    required this.delete,
  });
  final Function() edit;
  final Function() delete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: .min,
        children: [
          ListTile(
            onTap: () {
              edit();
            },
            leading: SvgIcon(assetName: 'assets/icons/edit.svg'),
            title: Text(
              context.local.edit_review,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
            ),
          ),

          ListTile(
            onTap: () {
              delete();
            },
            leading: SvgIcon(
              assetName: 'assets/icons/delete.svg',
              color: AppColors.red,
            ),
            title: Text(
              context.local.delete_review,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
            ),
          ),

          24.verticalSpace,
        ],
      ),
    );
  }
}
