import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_details_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductBannerWidget extends ConsumerWidget {
  final PageController pageController = PageController(initialPage: 0);

  ProductBannerWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    final state = ref.watch(productDetailsProvider);
    final product = state.productDetailsModel;

    final images = product?.images ?? [];
    return LoadingWidget(
      isLoading: state.apiCallStatus == .gettingProductDetails,

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
              controller: pageController,
              physics: ClampingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.containerFilledColor,
                  ),
                  padding: .symmetric(horizontal: .24.sw),
                  child: CachedNetworkImageWidget(
                    key: Key(image.uuid ?? ''),
                    image: image.path,
                  ),
                );
              },
            ),
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
                        color: Colors.red,
                        borderRadius: .circular(56.r),
                      ),
                      padding: .symmetric(horizontal: 8.w, vertical: 4.h),
                      child: Text(
                        '${context.local.only}'
                        ' ${product?.stock.toLocalNumber(local)} '
                        ' ${product?.unit.name} '
                        '${context.local.remaining_in_stock}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                    if (images.isNotEmpty)
                      SmoothPageIndicator(
                        controller: pageController,
                        count: images.length,
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
    );
  }
}
