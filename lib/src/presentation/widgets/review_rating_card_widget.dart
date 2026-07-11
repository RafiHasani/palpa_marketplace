import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/data/models/product_review_response_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_rating_widget.dart';

class ReviewCardWidget extends ConsumerWidget {
  const ReviewCardWidget({super.key, required this.reviewModel});

  final ReviewModel reviewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final locale = ref.read(appLangProvider);
    return Column(
      crossAxisAlignment: .start,
      spacing: 8.h,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: 16.w,
              children: [
                Container(
                  decoration: BoxDecoration(shape: .circle),
                  clipBehavior: .antiAliasWithSaveLayer,
                  child: CachedNetworkImageWidget(
                    errorWidgetSize: 24.r,
                    height: 24.h,
                    width: 24.w,
                    image: reviewModel.user?.avatar ?? '',
                  ),
                ),

                Text(
                  reviewModel.user?.fullName ?? '',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            Text(
              reviewModel.createdAt.toString().toPersianDate(locale),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.subTitileTextColor,
              ),
            ),
          ],
        ),
        Row(spacing: 4, children: getRating(reviewModel.rating ?? 0)),

        Text(
          reviewModel.comment ?? '',
          style: theme.textTheme.bodySmall,
          overflow: .ellipsis,
          maxLines: 2,
        ),
        8.verticalSpace,
      ],
    );
  }
}
