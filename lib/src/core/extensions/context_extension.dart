import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/l10n/app_localizations.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

extension ContextExtension on BuildContext {
  bool get isLightTheme => Theme.of(this).brightness == .light ? true : false;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  AppLocalizations get local => AppLocalizations.of(this)!;

  String get getRouterCurrentPath => GoRouter.of(this).state.fullPath ?? '';

  Future<void> showMySnackBar({required String content}) async {
    ScaffoldMessenger.maybeOf(this)?.showSnackBar(
      SnackBar(
        dismissDirection: .startToEnd,
        padding: .fromLTRB(16.w, 16.h, 16.w, 24.h),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.cardBorderColor,
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
