import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/editproduct/producer_edit_product.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_show_product_details.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';

class ProducerMyproductCardWidget extends ConsumerWidget {
  const ProducerMyproductCardWidget({super.key, this.product});

  final Products? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    final thumbnails = product?.thumbnails ?? [];

    return Stack(
      children: [
        Card.outlined(
          clipBehavior: .antiAlias,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.cardBorderColor),
            borderRadius: BorderRadiusGeometry.circular(6.r),
          ),
          elevation: 0,
          color: AppColors.whiteColor,
          child: Column(
            children: [
              Container(
                height: 170.h,
                width: .maxFinite,
                color: AppColors.containerFilledColor,
                padding: .all(24.0),
                child: CachedNetworkImageWidget(
                  width: .maxFinite,
                  fit: .cover,
                  image: thumbnails.isNotEmpty
                      ? thumbnails.first.path ?? ''
                      : '',
                ),
              ),

              Container(
                padding: .all(8.r),
                child: Column(
                  spacing: 8.h,
                  mainAxisSize: .min,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Container(
                          padding: .symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            border: .all(
                              width: 0.7.w,
                              color: AppColors.cardBorderColor,
                            ),
                            shape: .rectangle,
                            borderRadius: .circular(56.r),
                          ),
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 4.w,
                            children: [
                              SvgIcon(assetName: 'assets/icons/rate_start.svg'),
                              Text(
                                product?.ratingsAverage
                                        ?.toNumber()
                                        .toLocalNumber(local) ??
                                    '',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 8.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          radius: 44.r,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) {
                                return EditMyProductBottomSheet(
                                  edit: () {
                                    context.pop();
                                    context.push(
                                      context.getRouterCurrentPath +
                                          ProducerEditProduct.path,
                                      extra: product?.slug ?? '',
                                    );
                                  },
                                  activeInactive: () {
                                    context.pop();
                                    ref
                                        .read(producerProductProvider.notifier)
                                        .activeInactiveProduct(
                                          slug: product?.slug ?? '',
                                        );
                                  },
                                  show: () {
                                    context.pop();
                                    context.push(
                                      context.getRouterCurrentPath +
                                          ProducerShowProductDetails.path,
                                      extra: product?.slug ?? '',
                                    );
                                  },
                                  isActive: product?.isActive ?? false,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgIcon(
                              assetName: 'assets/icons/vertical_more.svg',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product?.name ?? '',
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          ' ${product?.stock?.toLocalNumber(local)} ${product?.unit?.name} ${context.local.remaining_in_stock}',
                          overflow: .ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Color(0xFF00B7D5),
                          ),
                        ),
                        if (product?.hasDiscount ?? false)
                          Text(
                            '${product?.discountedPrice?.toNumber().toLocalNumber(local)}  ${context.local.afghani}',
                            maxLines: 1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Color(0xFF8D99AE),
                              decorationThickness: 0.5,
                              color: Color(0xFF8D99AE),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        Text(
                          '${product?.price?.toNumber().toLocalNumber(local)} ${context.local.afghani}',
                          style: theme.textTheme.bodyLarge,
                          overflow: .ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        PositionedDirectional(
          end: 16.w,
          top: 16.h,
          child: getProductStatusWidget(
            context,
            theme,
            product?.isActive ?? false,
          ),
        ),
      ],
    );
  }
}

Widget getProductStatusWidget(
  BuildContext context,
  ThemeData theme,
  bool status,
) {
  switch (status) {
    case false:
      return Container(
        padding: .symmetric(vertical: 2.h, horizontal: 9.w),
        decoration: BoxDecoration(
          color: AppColors.purpul2,
          border: .all(color: AppColors.purpulBorder),
          borderRadius: .circular(32.r),
        ),
        child: Text(
          context.local.inActive,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
        ),
      );
    case true:
      return Container(
        padding: .symmetric(vertical: 2.h, horizontal: 9.w),
        decoration: BoxDecoration(
          color: AppColors.greenLight2,
          border: .all(color: AppColors.greenLight),
          borderRadius: .circular(32.r),
        ),
        child: Text(
          context.local.active,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
        ),
      );
  }
}

class EditMyProductBottomSheet extends ConsumerWidget {
  const EditMyProductBottomSheet({
    super.key,
    required this.edit,
    required this.activeInactive,
    required this.show,
    required this.isActive,
  });
  final Function() edit;
  final Function() show;
  final Function() activeInactive;
  final bool isActive;

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
            leading: SvgIcon(
              assetName: 'assets/icons/edit.svg',
              color: AppColors.subTitileTextColor,
            ),
            title: Text(
              context.local.edit_review,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
            ),
          ),

          ListTile(
            onTap: () {
              show();
            },
            leading: SvgIcon(assetName: 'assets/icons/show.svg'),
            title: Text(
              context.local.view,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
            ),
          ),

          ListTile(
            onTap: () {
              activeInactive();
            },
            leading: isActive
                ? SvgIcon(assetName: 'assets/icons/active_inactive.svg')
                : Icon(Icons.edit_document, color: AppColors.primaryColor),
            title: Text(
              isActive ? context.local.deactivate : context.local.activate,
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
