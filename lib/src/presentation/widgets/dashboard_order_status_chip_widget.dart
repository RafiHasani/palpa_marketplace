import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';

Widget getDashboardOrderStatusWidget(
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
    case 'processing':
      return Container(
        padding: .symmetric(vertical: 2.h, horizontal: 9.w),
        decoration: BoxDecoration(
          color: AppColors.blueLight2,
          border: .all(color: AppColors.blueLight),
          borderRadius: .circular(32.r),
        ),
        child: Text(
          context.local.processing,
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
