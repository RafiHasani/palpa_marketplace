import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/data/models/image_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreateProductDetailsBannerWidget extends ConsumerStatefulWidget {
  final PageController pageController = PageController(initialPage: 0);
  final List<ImageModel> images;
  final num? inStock;
  final UnitModel? unitModel;
  final String? productName;

  CreateProductDetailsBannerWidget({
    super.key,
    required this.images,
    this.inStock,
    this.unitModel,
    this.productName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateProductDetailsBannerWidget();
}

class _CreateProductDetailsBannerWidget
    extends ConsumerState<CreateProductDetailsBannerWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    return ClipRRect(
      borderRadius: .circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(10.r),
          border: .all(color: AppColors.cardBorderColor, width: 0.7.w),
        ),
        height: 140.h,
        child: Container(
          clipBehavior: .antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: AppColors.containerFilledColor,
            borderRadius: .circular(10.r),
            border: .all(color: AppColors.cardBorderColor, width: 0.7.w),
          ),
          height: 230.h,
          child: Stack(
            children: [
              PageView.builder(
                clipBehavior: Clip.antiAlias,
                controller: widget.pageController,
                physics: ClampingScrollPhysics(),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final image = widget.images[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.containerFilledColor,
                    ),
                    padding: .symmetric(horizontal: .24.sw),
                    child: image.uuid != ImageState.deleted.label
                        ? image.uuid == ImageState.added.label
                              ? Image.file(File(image.path!), fit: .cover)
                              : CachedNetworkImageWidget(image: image.path)
                        : SizedBox.shrink(),
                  );
                },
              ),
              if (widget.inStock != null && widget.productName != null)
                PositionedDirectional(
                  bottom: 16.h,
                  end: 0,
                  start: 0,
                  child: Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: .circular(56.r),
                          ),
                          padding: .symmetric(horizontal: 8.w, vertical: 4.h),
                          child: Text(
                            '${context.local.only} ${widget.inStock?.toLocalNumber(local)} '
                            ' ${widget.unitModel?.name} ${context.local.remaining_in_stock}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                        if (widget.images.isNotEmpty)
                          SmoothPageIndicator(
                            controller: widget.pageController,
                            count: widget.images.length,
                            effect: ExpandingDotsEffect(
                              dotWidth: 5.w,
                              activeDotColor: AppColors.focueButtonColor,
                              dotColor: Colors.white,
                              dotHeight: 5.h,
                            ),
                          ),
                      ],
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
