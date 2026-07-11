import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

class BottomNavButtons extends ConsumerWidget {
  const BottomNavButtons({
    super.key,
    required this.isFocused,
    required this.onPressed,
    required this.icon,
    required this.title,
  });

  final bool isFocused;
  final VoidCallback onPressed;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);

    return InkWell(
      onTap: () => onPressed(),
      child: Padding(
        padding: .symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          spacing: 4.h,
          children: [
            SvgIcon(
              assetName: icon,
              color: isFocused
                  ? AppColors.focueButtonColor
                  : AppColors.unFocuButtonColor,
            ),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isFocused
                    ? theme.focusColor
                    : theme.unselectedWidgetColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
