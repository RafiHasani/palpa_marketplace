import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/change_password_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/update_profile_page.dart';

class ProfileBottomSheet extends ConsumerWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: .only(
          topLeft: .circular(20.r),
          topRight: .circular(20.r),
        ),
      ),
      padding: .symmetric(vertical: 24.h),
      child: Padding(
        padding: .symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          mainAxisSize: .min,
          children: [
            ListTile(
              onTap: () {
                context.push(
                  context.getRouterCurrentPath + UpdateProfilePage.path,
                );

                context.pop();
              },
              leading: Icon(
                Icons.person_pin,
                color: AppColors.subTitileTextColor,
              ),
              title: Text(
                context.local.edit_user_info,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subTitileTextColor,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                context.push(
                  context.getRouterCurrentPath + ChangePasswordPage.path,
                );
                context.pop();
              },
              leading: Icon(
                Icons.password_outlined,
                color: AppColors.subTitileTextColor,
              ),
              title: Text(
                context.local.edit_user_password,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subTitileTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
