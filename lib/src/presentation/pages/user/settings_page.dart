import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/pages/auth/signin_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/contactus_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/favourite_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/orders_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/shoping_experiance_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/change_password_bottomsheet_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class SettingsPage extends ConsumerWidget {
  static const String path = "/settingspage";
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final auth = ref.watch(authProvider);
    final user = auth.user;

    ref.listen(authProvider, (pre, next) {
      if (next.authState == .logoutSuccess) {
        navigatorHome(context);
      }

      if (next.authState == .logOutFailed) {
        showSnack(context, msg: next.errorMessage?.error);
      }
    });

    return LoadingWidget(
      isLoading: auth.authState == .loggingOut,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              auth.isAuthenticated
                  ? ListTile(
                      contentPadding: .directional(start: 16.w),
                      dense: true,
                      leading: user?.avatar != null
                          ? ClipRRect(
                              clipBehavior: .antiAliasWithSaveLayer,
                              borderRadius: .circular(56.r),
                              child: CachedNetworkImageWidget(
                                height: 40.h,
                                width: 40.w,
                                image: user?.avatar,
                                errorWidgetSize: 32.r,
                              ),
                            )
                          : CircleAvatar(child: Icon(Icons.image_search_sharp)),

                      title: Row(
                        spacing: 8.w,
                        children: [
                          Text(
                            user?.name ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          if (user?.isProducer ?? false)
                            Container(
                              padding: .symmetric(
                                vertical: 2.h,
                                horizontal: 9.w,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueLight2,
                                border: .all(color: AppColors.blueLight),
                                borderRadius: .circular(32.r),
                              ),
                              child: Text(
                                context.local.producer,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                        ],
                      ),

                      subtitle: Text(
                        user?.phone ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.subTitileTextColor,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showProfile(context);
                        },
                        icon: SvgIcon(
                          assetName: 'assets/icons/edit.svg',
                          fit: .cover,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

              Padding(
                padding: .symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  children: [
                    if (!auth.isAuthenticated)
                      SettingListTileWidget(
                        key: Key(TestKeys.gotoLoginpage),
                        leadingIcon: 'assets/icons/logout.svg',
                        title: context.local.login,
                        onClick: () {
                          context.push(LoginPage.path);
                        },
                      ),
                    if (auth.isAuthenticated)
                      SettingListTileWidget(
                        leadingIcon: 'assets/icons/paper.svg',
                        title: context.local.orders,
                        onClick: () {
                          context.go(OrdersPage.path);
                        },
                      ),

                    if (auth.isAuthenticated)
                      SettingListTileWidget(
                        leadingIcon: 'assets/icons/star_empty_icon.svg',
                        title: context.local.purchase_experiences,
                        onClick: () {
                          context.push(
                            context.getRouterCurrentPath +
                                ShopingExperiancePage.path,
                          );
                        },
                      ),
                    if (auth.isAuthenticated)
                      SettingListTileWidget(
                        leadingIcon: 'assets/icons/favourite.svg',
                        title: context.local.favourites,
                        onClick: () {
                          context.go(FavouritePage.path);
                        },
                      ),
                    SettingListTileWidget(
                      leadingIcon: 'assets/icons/setting.svg',
                      title: context.local.language,
                      onClick: () {
                        show(context);
                      },
                    ),
                    SettingListTileWidget(
                      leadingIcon: 'assets/icons/call.svg',
                      title: context.local.contact_us,
                      onClick: () {
                        context.push(
                          context.getRouterCurrentPath + ContactusPage.path,
                        );
                      },
                    ),
                    if (auth.isAuthenticated)
                      SettingListTileWidget(
                        leadingIcon: 'assets/icons/logout.svg',
                        title: context.local.logout,
                        onClick: () {
                          ref.read(authProvider.notifier).logout();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showProfile(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => ProfileBottomSheet(),
    );
  }

  void navigatorHome(BuildContext context) {
    context.go(HomePage.path);
  }

  void showSnack(BuildContext context, {String? msg}) {
    context.showMySnackBar(content: context.local.logout_failed);
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => LanguageBottomSheet(),
    );
  }
}

class LanguageBottomSheet extends ConsumerWidget {
  const LanguageBottomSheet({super.key});

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
          spacing: 16.h,
          children: [
            InkWell(
              onTap: () {
                ref.read(appLangProvider.notifier).setLanguage(Locale('en'));
                context.pop();
              },
              child: Padding(
                padding: .symmetric(vertical: 8.h),
                child: Row(
                  spacing: 16.w,
                  children: [
                    SvgIcon(
                      assetName: 'assets/icons/us.svg',
                      height: 16.h,
                      width: 25.h,
                    ),
                    Text(
                      'انگلیسی',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subTitileTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(appLangProvider.notifier).setLanguage(Locale('fa'));
                context.pop();
              },
              child: Padding(
                padding: .symmetric(vertical: 8.h),
                child: Row(
                  spacing: 16.w,
                  children: [
                    SvgIcon(
                      assetName: 'assets/icons/af.svg',
                      width: 25.w,
                      height: 16.h,
                    ),
                    Text(
                      'دری',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subTitileTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(appLangProvider.notifier).setLanguage(Locale('ps'));
                context.pop();
              },
              child: Padding(
                padding: .symmetric(vertical: 8.h),
                child: Row(
                  spacing: 16.w,
                  children: [
                    SvgIcon(
                      assetName: 'assets/icons/af.svg',
                      width: 25.w,
                      height: 16.h,
                    ),
                    Text(
                      'پشتو',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subTitileTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class SettingListTileWidget extends ConsumerWidget {
  const SettingListTileWidget({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onClick,
  });
  final String leadingIcon;
  final String title;

  final Function() onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return InkWell(
      key: key,
      borderRadius: .circular(4.r),
      onTap: () => onClick.call(),
      child: Padding(
        padding: .symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 16.w,
                children: [
                  SvgIcon(assetName: leadingIcon, size: 16.r),
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: .directional(end: 8.w),
              child: getOpenArrowIcon(local),
            ),
          ],
        ),
      ),
    );
  }
}
