import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/lunch_url.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/providers/general_apis_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class ContactusPage extends ConsumerStatefulWidget {
  static const String path = '/contactuspage';
  const ContactusPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactusPageState();
}

class _ContactusPageState extends ConsumerState<ContactusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(generalApisProvider.notifier).getSiteSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generalApisProvider);
    final settings = state.settingModel;
    final theme = ref.read(appThemeDataProvider);
    return LoadingWidget(
      isLoading: state.apiCallStatus == .loading,
      child: Scaffold(
        appBar: AppbarPageWidget(
          hideSearch: true,
          title: context.local.contact_us,
        ),

        body: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            Column(
              spacing: 8.h,
              children: [
                Container(
                  alignment: .center,
                  padding: .all(24.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: .circle,
                  ),
                  child: SvgIcon(assetName: 'assets/icons/contact_us.svg'),
                ),

                Text(
                  context.local.contact_us,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  context.local.contact_methods_info,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            32.verticalSpace,

            Padding(
              padding: .symmetric(horizontal: 24.w),
              child: Column(
                spacing: 28.h,
                mainAxisAlignment: .start,
                children: [
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16.w,
                    children: [
                      SvgIcon(assetName: 'assets/icons/message.svg'),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            context.local.email,
                            style: theme.textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () => launchEmail(
                              settings?.contactEmail ?? 'palpa@asrepoya.com',
                            ),
                            child: Text(
                              settings?.contactEmail ?? 'palpa@asrepoya.com',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16.w,
                    children: [
                      SvgIcon(assetName: 'assets/icons/call.svg'),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Text('تماس', style: theme.textTheme.bodyLarge),
                          InkWell(
                            onTap: () => launchDialer(
                              settings?.contactPhone ?? '0792311783',
                            ),
                            child: Text(
                              settings?.contactPhone ?? '0792311783',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16.w,
                    children: [
                      SvgIcon(
                        assetName: 'assets/icons/location.svg',
                        height: 15.h,
                        width: 12.w,
                      ),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Text('آدرس', style: theme.textTheme.bodyLarge),
                          Text(
                            settings?.address ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: .start,
                    mainAxisSize: .max,
                    spacing: 8.w,
                    children: [
                      SvgIcon(
                        assetName: 'assets/icons/linkedin.svg',
                        size: 18.r,
                      ),
                      InkWell(
                        onTap: () {
                          launchBrowser(
                            settings?.socials?.linkedin ?? 'palpa@asrepoya.com',
                          );
                        },
                        child: Text(
                          settings?.socials?.linkedin ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    spacing: 8.w,
                    children: [
                      SvgIcon(
                        assetName: 'assets/icons/facebook.svg',
                        size: 18.r,
                      ),
                      InkWell(
                        onTap: () {
                          launchBrowser(
                            settings?.socials?.facebook ?? 'palpa@asrepoya.com',
                          );
                        },
                        child: Text(
                          settings?.socials?.facebook ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8.w,
                    children: [
                      SvgIcon(
                        assetName: 'assets/icons/instagram.svg',
                        size: 18.r,
                      ),
                      InkWell(
                        onTap: () {
                          launchBrowser(
                            settings?.socials?.instagram ??
                                'palpa@asrepoya.com',
                          );
                        },
                        child: Text(
                          settings?.socials?.instagram ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8.w,
                    children: [
                      SvgIcon(assetName: 'assets/icons/xicon.svg', size: 18.r),
                      InkWell(
                        onTap: () {
                          launchBrowser(
                            settings?.socials?.x ?? 'palpa@asrepoya.com',
                          );
                        },
                        child: Text(
                          settings?.socials?.x ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
