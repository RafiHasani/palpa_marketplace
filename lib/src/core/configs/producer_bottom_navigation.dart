import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/createproduct/producer_add_product_page.dart';
import 'package:palpa_marketplace/src/presentation/widgets/bottom_navigation_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';

class ProducerBottomNavigation extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const ProducerBottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return DismissKeyboardWidget(
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: SafeArea(
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
                        navigationShell.goBranch(0);
                      },
                      icon: 'assets/icons/home.svg',
                      title: context.local.home,
                    ),
                    Spacer(),
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 1,
                      onPressed: () => navigationShell.goBranch(1),
                      icon: 'assets/icons/category.svg',
                      title: context.local.products,
                    ),

                    Spacer(flex: 7),
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 2,
                      onPressed: () {
                        navigationShell.goBranch(2);
                      },
                      icon: 'assets/icons/orders.svg',
                      title: context.local.orders2,
                    ),
                    Spacer(),
                    BottomNavButtons(
                      isFocused: navigationShell.currentIndex == 3,
                      onPressed: () {
                        navigationShell.goBranch(3);
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
          onTap: () {
            context.push(ProducerAddProductPage.path);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white, shape: .circle),
            padding: .all(6.r),
            margin: .only(top: 24.h),
            child: Container(
              padding: .all(24.r),
              decoration: BoxDecoration(
                shape: .circle,
                color: AppColors.whiteColor,
              ),
              child: Column(
                mainAxisSize: .min,
                spacing: 4.h,
                children: [
                  SvgIcon(
                    assetName: 'assets/icons/addition.svg',
                    color: AppColors.unFocuButtonColor,
                  ),
                  Text(
                    context.local.add,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.unFocuButtonColor,
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
