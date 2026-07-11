import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';

import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class ProducerDashboardPage extends ConsumerStatefulWidget {
  static const String path = '/producerdashboardpage';
  const ProducerDashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProducerDashboardPageState();
}

class ProducerDashboardPageState extends ConsumerState<ProducerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final prdouctState = ref.watch(producerProductProvider);

    final dashboard = prdouctState.producerDashboard;
    final local = ref.read(appLangProvider);

    return Scaffold(
      appBar: AppbarPageWidget(hideSearch: true),
      body: SafeArea(
        child: LoadingWidget(
          isLoading: prdouctState.producerApiStatus == .gettingDashboard,
          child: Column(
            children: [
              Padding(
                padding: .symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      spacing: 16.w,
                      children: [
                        DashboardProductsStatusWidget(
                          icon: 'assets/icons/active_products.svg',
                          title: (dashboard?.activeProductsCount ?? 0)
                              .toLocalNumber(local),
                          subTitle: 'محصولات فعال',
                        ),
                        DashboardProductsStatusWidget(
                          icon: 'assets/icons/info_circle.svg',
                          title: (dashboard?.pendingOrdersCount ?? 0)
                              .toLocalNumber(local),
                          subTitle: 'در انتظار تایید',
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      spacing: 16.w,
                      children: [
                        DashboardProductsStatusWidget(
                          icon: 'assets/icons/orders.svg',
                          title: (dashboard?.newOrdersCount ?? 0).toLocalNumber(
                            local,
                          ),
                          subTitle: context.local.new_orders,
                          iconColor: AppColors.blue3,
                        ),
                        DashboardProductsStatusWidget(
                          icon: 'assets/icons/star_orange.svg',
                          title: ((dashboard?.productsRatingAverage ?? '0')
                              .toNumber()
                              .toLocalNumber(local)),
                          subTitle: context.local.average_rating,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              // HeadingRowWidget(
              //   title: 'فعالیت های اخیر',
              //   actionButtonTitle: 'همه',
              //   isActionAable: true,
              //   iconAlignment: .end,
              //   actionTextIconButton: () {},
              //   icon: SvgIcon(assetName: 'assets/icons/open_arrow_left.svg'),
              // ),

              // Expanded(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: 3,
              //     itemBuilder: (context, index) {
              //       return DashboardActivityWidget();
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardProductsStatusWidget extends ConsumerWidget {
  const DashboardProductsStatusWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.iconColor,
  });
  final String icon;
  final String title;
  final String subTitle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Expanded(
      child: Container(
        padding: .all(16.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: .all(color: AppColors.cardBorderColor),
          borderRadius: .circular(10.r),
        ),

        child: Row(
          crossAxisAlignment: .center,

          spacing: 16.w,
          children: [
            Container(
              padding: .all(16.r),
              decoration: BoxDecoration(
                borderRadius: .circular(56.r),
                color: AppColors.containerFilledColor,
              ),
              child: SvgIcon(assetName: icon, color: iconColor),
            ),

            Column(
              crossAxisAlignment: .start,

              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
                ),
                Text(
                  subTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subTitileTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
