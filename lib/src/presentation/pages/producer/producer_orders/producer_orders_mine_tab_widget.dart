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
import 'package:palpa_marketplace/src/data/models/producer_orders_others_response_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/order_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dashboard_order_status_chip_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ProducerOrdersMineTabWidget extends ConsumerStatefulWidget {
  const ProducerOrdersMineTabWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerOrdersMineTabWidgetState();
}

class _ProducerOrdersMineTabWidgetState
    extends ConsumerState<ProducerOrdersMineTabWidget> {
  final ValueNotifier<bool> showActions = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final stat = ref.watch(producerProductProvider);
    final orderStat = ref.watch(orderProvider);
    final orders = stat.producerOthersMine?.data ?? [];

    ref.listen(orderProvider, (pre, next) {
      if (next.apiCallStatus == .orderSatetUpdatingSuccess) {
        ref.read(producerProductProvider.notifier).getOrdersOfMine();
        return;
      }
      if (next.apiCallStatus == .orderSatetUpdatingFailed) {
        context.showMySnackBar(content: next.errorMessage?.error ?? '');
        return;
      }
    });
    return LoadingWidget(
      isLoading:
          stat.producerApiStatus == .gettingOrderMine ||
          orderStat.apiCallStatus == .orderStateUpdating,
      child: Padding(
        padding: .fromLTRB(8.w, 8.h, 8.w, 0),
        child: RefreshIndicator.adaptive(
          onRefresh: () {
            return ref.read(producerProductProvider.notifier).getOrdersOfMine();
          },
          child: ListView.builder(
            padding: .only(bottom: 24.h),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              return OthersMineCardWidget(
                item: item,
                onCancel: () {
                  ref
                      .read(orderProvider.notifier)
                      .cancelOrderByUser(item.number ?? '');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class OthersMineCardWidget extends ConsumerWidget {
  final ValueNotifier<bool> showActions = ValueNotifier(false);

  OthersMineCardWidget({super.key, required this.item, required this.onCancel});

  final ProducerOrderModel item;
  final Function() onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return Card(
      elevation: 0,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(10.r),
        side: BorderSide(color: AppColors.cardBorderColor),
      ),

      child: Padding(
        padding: .symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            ListTile(
              contentPadding: .zero,
              leading: CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.transparent,
                child: CachedNetworkImageWidget(
                  image: item.product?.thumbnails?.first.path ?? '',
                ),
              ),

              title: Text(
                item.product?.salerModel?.fullName ?? '',
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: context.local.date_label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.subTitileTextColor,
                      ),
                    ),

                    TextSpan(
                      text: (item.createdAt ?? DateTime.now())
                          .toJalali()
                          .fomated(local),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Row(
                crossAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  getDashboardOrderStatusWidget(
                    context,
                    theme,
                    item.statusLabel ?? '',
                  ),
                  IconButton(
                    onPressed: () {
                      showActions.value = !showActions.value;
                    },
                    icon: SvgIcon(
                      assetName: 'assets/icons/open_arrow_down.svg',
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: .symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4.h,
                children: [
                  Text(
                    item.product?.name ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.local.quantity_label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subTitileTextColor,
                          ),
                        ),

                        TextSpan(
                          text:
                              '${item.quantity?.toLocalNumber(local)} ${item.product?.unit?.name}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            if (item.statusLabel == 'pending')
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: ValueListenableBuilder<bool>(
                  valueListenable: showActions,
                  builder: (_, visible, w) {
                    if (!visible) return const SizedBox.shrink();
                    return Row(
                      spacing: 24.w,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            title: context.local.cancel,
                            onPressed: onCancel,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
