import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';

class ErrorPage extends ConsumerWidget {
  static const String path = '/errorpage';
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Scaffold(
      body: Row(
        mainAxisAlignment: .center,
        children: [
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            mainAxisSize: .max,
            spacing: 16.h,
            children: [
              Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    '404',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 68.sp,
                      color: Colors.red,
                    ),
                  ),
                  Icon(
                    Icons.electrical_services_rounded,
                    size: 68.r,
                    color: Colors.red,
                  ),
                ],
              ),

              Text(
                context.local.unexpected_error,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 32.sp),
              ),

              CustomElevatedButton(
                title: context.local.go_back,
                onPressed: () {
                  if (Appconfig().user?.isProducer ?? false) {
                    navigateToProducerPage(context);
                  } else {
                    navigateToHome(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    context.go(HomePage.path);
  }

  void navigateToProducerPage(BuildContext context) {
    context.go(ProducerHomePage.path);
  }
}
