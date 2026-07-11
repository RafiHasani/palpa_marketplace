import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class CustomElevatedButton extends ConsumerWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    this.hieght,
    required this.onPressed,
    this.isDisabled,
    this.backColor,
    this.titleColor,
  });
  final String title;
  final double? hieght;
  final Function() onPressed;
  final bool? isDisabled;
  final Color? backColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return ElevatedButton(
      onPressed: isDisabled ?? false
          ? null
          : () {
              onPressed();
            },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        disabledBackgroundColor: AppColors.primaryColor.withAlpha(150),
        backgroundColor: backColor ?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: .circular(10.r)),
      ),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: titleColor ?? Colors.white,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
