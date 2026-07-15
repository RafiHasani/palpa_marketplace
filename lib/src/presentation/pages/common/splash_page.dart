import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/data/models/user.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_home_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/auth_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/network_status_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dot_animation_splash_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String path = '/splashpage';
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _appInitiate();
      } catch (_) {}
    });
  }

  Future<void> _appInitiate() async {
    await _getAuthData();
  }

  Future<bool> _getAuthData() async {
    final auth = ref.watch(authProvider.notifier);

    try {
      auth.getAuthFromLocalStorage();

      if (Appconfig().appLang != null) {
        ref
            .read(appLangProvider.notifier)
            .setLanguage(Locale(Appconfig().appLang ?? 'fa'));
      }

      if (Appconfig().token != null && Appconfig().user != null) {
        String authToken = Appconfig().token!;
        User user = Appconfig().user!;

        auth.changeStateToAuth(user: user, token: authToken);

        if (mounted && (user.isProducer ?? false)) {
          await Future.delayed(Duration(milliseconds: 500)).then((_) {
            navigateTo(ProducerHomePage.path);
          });
        } else {
          await Future.delayed(Duration(milliseconds: 500)).then((_) {
            navigateTo(HomePage.path);
          });
        }

        return true;
      } else {
        await Future.delayed(Duration(milliseconds: 500)).then((_) {
          navigateTo(HomePage.path);
        });

        return false;
      }
    } catch (_) {}

    return false;
  }

  void navigateTo(String path) {
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        fit: .expand,
        children: [
          Image.asset(fit: .fill, 'assets/images/lunch_bg.png'),
          Center(
            child: SizedBox(
              height: 280.h,
              width: 320.w,
              child: Image.asset('assets/images/logo2.png', fit: .contain),
            ),
          ),

          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 16.h,
            child: ThreeDotLoader(size: 10, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
