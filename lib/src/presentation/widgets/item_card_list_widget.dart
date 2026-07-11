import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/data/models/product_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';

class ItemCardWidget extends ConsumerWidget {
  const ItemCardWidget({super.key, this.onclick, required this.products});
  final Function()? onclick;

  final Products products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    return GestureDetector(
      onTap: () => onclick?.call(),
      child: SizedBox(
        width: 200.w,
        child: Card.outlined(
          clipBehavior: .antiAlias,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.cardBorderColor),
            borderRadius: BorderRadiusGeometry.circular(6.r),
          ),
          elevation: 0,
          color: AppColors.whiteColor,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 170.h,
                width: 200.w,
                color: AppColors.containerFilledColor,
                padding: const EdgeInsets.all(16.0),
                child: CachedNetworkImageWidget(
                  image: products.thumbnails?.first.path,
                  fit: .contain,
                ),
              ),

              8.verticalSpace,
              Container(
                padding: .all(8.r),
                child: Column(
                  spacing: 8.h,
                  mainAxisSize: .min,
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      products.name ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
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
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
