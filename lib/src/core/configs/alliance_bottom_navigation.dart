import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/signin_page.dart';
import 'package:palpa_marketplace/src/presentation/widgets/bottom_navigation_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';

class AllianceBottomNavigation extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const AllianceBottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return DismissKeyboardWidget(
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: SafeArea(
          key: ValueKey(TestKeys.userbottomNavigationBarkey),
          bottom: Platform.isAndroid ? true : false,
          child: Container(
            clipBehavior: Clip.none,
            color: Colors.white,
            padding: .symmetric(
              vertical: Platform.isAndroid ? 4.h : 8.h,
              horizontal: 8.w,
            ),
            child: Column(
              mainAxisSize: .min,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 0,
                      onPressed: () {
                        if (Appconfig().token != null &&
                            Appconfig().user != null) {
                          navigationShell.goBranch(0);
                        } else {
                          context.push(LoginPage.path);
                        }
                      },
                      icon: 'assets/icons/orders.svg',
                      title: context.local.orders,
                    ),
                    Spacer(),
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 1,
                      onPressed: () => navigationShell.goBranch(1),
                      icon: 'assets/icons/category.svg',
                      title: context.local.categories,
                    ),

                    Spacer(flex: 7),
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 3,
                      onPressed: () {
                        if (Appconfig().token != null &&
                            Appconfig().user != null) {
                          navigationShell.goBranch(3);
                        } else {
                          context.push(LoginPage.path);
                        }
                      },
                      icon: 'assets/icons/favourite.svg',
                      title: context.local.favourites,
                    ),
                    Spacer(),
                    BottomNavButtons(
                      key: Key(TestKeys.userbottomNavigationBarSettingskey),
                      isFocused: navigationShell.currentIndex == 4,
                      onPressed: () {
                        navigationShell.goBranch(4);
                      },
                      icon: 'assets/icons/setting.svg',
                      title: context.local.settings,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () => navigationShell.goBranch(2),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, shape: .circle),
            padding: .all(6.r),
            margin: .only(top: 24.h),
            child: Container(
              padding: .all(24.r),
              decoration: BoxDecoration(
                shape: .circle,
                color: navigationShell.currentIndex == 2
                    ? AppColors.focueButtonColor
                    : AppColors.whiteColor,
              ),
              child: Column(
                mainAxisSize: .min,
                spacing: 4.h,
                children: [
                  SvgIcon(
                    assetName: 'assets/icons/home.svg',
                    color: navigationShell.currentIndex == 2
                        ? AppColors.whiteColor
                        : AppColors.unFocuButtonColor,
                  ),
                  Text(
                    context.local.home,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: navigationShell.currentIndex == 2
                          ? AppColors.whiteColor
                          : AppColors.unFocuButtonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
