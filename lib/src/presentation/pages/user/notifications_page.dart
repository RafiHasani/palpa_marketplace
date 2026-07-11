import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';

class NotificationsPage extends ConsumerWidget {
  static const String path = '/notificationspage';

  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Scaffold(
      appBar: AppbarPageWidget(
        title: context.local.notifications,
        hideSearch: true,
      ),

      body: Column(
        mainAxisAlignment: .center,
        spacing: 8.h,
        children: [
          Center(
            child: SvgIcon(assetName: 'assets/icons/notification_icon.svg'),
          ),
          Text(
            context.local.no_notifications_yet,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp),
          ),
          Text(
            context.local.latest_notifications_info,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.subTitileTextColor,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
