import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

class AppbarMainWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppbarMainWidget({
    super.key,
    this.onIconClicked,
    this.isEnable = true,
    this.onSearchClicked,
  });

  final Function()? onIconClicked;
  final Function()? onSearchClicked;
  final bool isEnable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Padding(
      padding: .fromSTEB(16.w, 60.h, 16.w, 8.h),
      child: Row(
        spacing: 8.w,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (onSearchClicked != null) {
                  onSearchClicked!();
                }
              },
              child: TextField(
                enabled: isEnable,
                decoration: InputDecoration(
                  prefixIcon: SvgIcon(
                    assetName: 'assets/icons/search.svg',
                    fit: .scaleDown,
                  ),
                  hintText: context.local.search_items,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textFieldHintColor,
                  ),
                ),
              ),
            ),
          ),
          // IconButton.outlined(
          //   padding: .all(16.r),
          //   onPressed: () {
          //     if (onIconClicked != null) {
          //       onIconClicked!();
          //     }
          //   },
          //   icon: SvgIcon(
          //     assetName: 'assets/icons/bell_icon.svg',
          //     color: AppColors.textFieldHintColor,
          //   ),
          //   style: IconButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     side: BorderSide(
          //       color: AppColors.inputBorderUnFocusedColorLight,
          //       width: 0.7.w,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => .fromHeight(100.h);
}
