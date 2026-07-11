import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class TextIconButtonWidget extends ConsumerWidget {
  const TextIconButtonWidget({
    super.key,
    required this.iconAlignment,
    required this.actionTextIconButton,
    required this.actionButtonTitle,
    required this.icon,
  });

  final MainAxisAlignment iconAlignment;
  final Function()? actionTextIconButton;
  final String? actionButtonTitle;
  final Widget? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return InkWell(
      borderRadius: .circular(8.r),
      onTap: () {
        actionTextIconButton?.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: .min,
          mainAxisAlignment: iconAlignment,
          spacing: 8.w,
          children: [
            Text(
              actionButtonTitle ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.focueButtonColor,
              ),
            ),
            ?icon,
          ],
        ),
      ),
    );
  }
}
