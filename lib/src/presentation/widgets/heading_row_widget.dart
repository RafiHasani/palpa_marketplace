import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class HeadingRowWidget extends ConsumerWidget {
  const HeadingRowWidget({
    super.key,
    required this.title,
    this.actionButtonTitle,
    this.actionTextButton,
    this.actionTextIconButton,
    this.isActionAable = false,
    this.icon,
    this.iconAlignment,
  });

  final String title;
  final String? actionButtonTitle;
  final Function()? actionTextButton;
  final Function()? actionTextIconButton;
  final bool? isActionAable;
  final Widget? icon;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);

    return Padding(
      padding: .directional(start: 16.w),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(title, style: theme.textTheme.bodyLarge),

          if (actionTextButton != null)
            Padding(
              padding: .directional(end: 8.w),
              child: TextButton(
                onPressed: () {
                  actionTextButton?.call();
                },
                child: Text(
                  actionButtonTitle ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.focueButtonColor,
                  ),
                ),
              ),
            ),

          if (actionTextIconButton != null)
            Padding(
              padding: .directional(end: 2.w),
              child: TextButton.icon(
                iconAlignment: iconAlignment,
                onPressed: () {
                  actionTextIconButton?.call();
                },
                label: Text(
                  actionButtonTitle ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.focueButtonColor,
                  ),
                ),
                icon: icon,
              ),
            ),
        ],
      ),
    );
  }
}
