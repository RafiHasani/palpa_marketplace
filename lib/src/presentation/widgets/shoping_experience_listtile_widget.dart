import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/my_product_review_response_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_rating_widget.dart';

class ShopingExperienceListTileWidget extends ConsumerWidget {
  const ShopingExperienceListTileWidget({
    super.key,
    required this.optionPressed,
    required this.item,
  });

  final Function() optionPressed;
  final ShopingExperianceModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Padding(
      padding: .fromLTRB(8.w, 16.h, 16.w, 4.h),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: .start,
        children: [
          ListTile(
            contentPadding: .zero,
            leading: Container(
              padding: .all(8),
              width: 64.w,
              height: 54.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: .circular(10.r),
              ),
              child: CachedNetworkImageWidget(
                image: item.product.thumbnails?.first.path,
              ),
            ),
            title: Text(
              item.product.name ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Row(
              children: [
                Text(
                  context.local.seller_label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subTitileTextColor,
                  ),
                ),
                Text(
                  item.product.salerModel?.fullName ?? '',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),

            trailing: IconButton(
              visualDensity: .adaptivePlatformDensity,

              onPressed: () {
                optionPressed();
              },
              icon: SvgIcon(assetName: 'assets/icons/more_icon.svg'),
            ),
          ),
          Row(spacing: 4, children: getRating(item.rating, startSize: 17)),
          Text(
            item.comment,
            overflow: .ellipsis,
            maxLines: 1,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.subTitileTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
