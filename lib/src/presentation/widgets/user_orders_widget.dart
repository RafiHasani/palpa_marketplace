import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';

class OrderListingWidget extends ConsumerWidget {
  const OrderListingWidget({
    super.key,
    required this.order,
    required this.updating,
  });

  final OrderModel order;
  final Function() updating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return ListTile(
      isThreeLine: true,
      onTap: () {
        updating();
      },
      leading: Container(
        padding: .all(8.r),
        width: 64.w,
        height: 54.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: .circular(10.r),
        ),
        child: CachedNetworkImageWidget(
          image: order.product.thumbnails?.first.path,
        ),
      ),
      title: Text(
        order.product.name ?? '',
        maxLines: 1,
        overflow: .ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: Column(
        children: [
          Row(
            spacing: 4.w,
            children: [
              Text(
                '${context.local.seller} : ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subTitileTextColor,
                ),
              ),
              Text(
                order.product.salerModel?.fullName ?? '',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          Row(
            spacing: 4.w,
            children: [
              Text(
                '${context.local.order_count_label} : ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subTitileTextColor,
                ),
              ),
              Text(
                '${order.amount.toNumber().toLocalNumberWithSeparator(local)}  ${order.product.unit?.name}',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.black2,
                ),
              ),
            ],
          ),
        ],
      ),

      trailing: OrderStatusWidget(
        orderStatus: order.statusLabel,
        price:
            '${order.amount.toNumber().toLocalNumber(local)} ${context.local.afghani}',
      ),
    );
  }

  void showSnack(BuildContext context, {String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }
}

class OrderStatusWidget extends ConsumerWidget {
  final String orderStatus;
  final String price;

  const OrderStatusWidget({
    super.key,
    required this.orderStatus,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .end,
      mainAxisSize: .min,
      spacing: 8.h,
      children: [
        getOrderStatusWidget(context, theme, orderStatus),
        Text(
          price,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget getOrderStatusWidget(
    BuildContext context,
    ThemeData theme,
    String status,
  ) {
    switch (status) {
      case 'pending':
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.purpul2,
            border: .all(color: AppColors.purpulBorder),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.pending,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
      case 'approved':
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.blueLight2,
            border: .all(color: AppColors.blueLight),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.approved,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
      case 'canceled':
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.blue2,
            border: .all(color: AppColors.blue),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.cancel,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
      case 'completed':
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.greenLight2,
            border: .all(color: AppColors.greenLight),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.completed,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
      case 'rejected':
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.red2,
            border: .all(color: AppColors.red),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.rejected,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
      default:
        return Container(
          padding: .symmetric(vertical: 2.h, horizontal: 9.w),
          decoration: BoxDecoration(
            color: AppColors.purpul2,
            border: .all(color: AppColors.purpulBorder),
            borderRadius: .circular(32.r),
          ),
          child: Text(
            context.local.pending,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp),
          ),
        );
    }
  }
}
