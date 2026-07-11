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
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_details_page.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';

class ProductListCardWidget extends ConsumerWidget {
  const ProductListCardWidget({super.key, this.product});

  final Products? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    final thumbnails = product?.thumbnails ?? [];

    return GestureDetector(
      onTap: () {
        context.push(
          context.getRouterCurrentPath + ProductListDetailsPage.path,
          extra: product?.slug ?? '',
        );
      },
      child: Card.outlined(
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
              padding: const EdgeInsets.all(16.0),
              child: CachedNetworkImageWidget(
                width: .maxFinite,
                fit: .cover,
                image: thumbnails.first.path ?? '',
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
                          product?.ratingsAverage?.toNumber().toLocalNumber(
                                local,
                              ) ??
                              '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    ),
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Color(0xFF00B7D5),
                        ),
                      ),
                      if (product?.hasDiscount ?? false)
                        Text(
                          product?.discountedPrice?.toNumber().toLocalNumber(
                                local,
                              ) ??
                              '',
                          maxLines: 1,
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.textFieldHintColor,
                            decorationThickness: 2.0,
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
    );
  }
}
