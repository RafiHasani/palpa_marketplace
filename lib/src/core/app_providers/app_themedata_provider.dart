import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/text_styles.dart';

final appThemeDataProvider = Provider<ThemeData>((ref) {
  final locale = ref.watch(appLangProvider);

  final String fontFamily = (locale.languageCode == AppLang.en.toString())
      ? 'Roboto'
      : 'BahijNazanin';

  return ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorLight,
    focusColor: AppColors.focueButtonColorLight,
    unselectedWidgetColor: AppColors.unFocuButtonColorLigth,
    primaryColorLight: AppColors.blackColor,
    primaryColor: AppColors.primaryColorLight,
    brightness: Brightness.light,
    fontFamily: fontFamily,

    textTheme: TextTheme(
      displayLarge: TextStyles.textStyleDisplayLarge.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 32,
      ),
      displayMedium: TextStyles.textStyleDisplayMedium.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 28,
      ),
      displaySmall: TextStyles.textStyleDisplaySmall.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 24,
      ),

      headlineLarge: TextStyles.textStyleHeadlineLarge.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 22,
      ),
      headlineMedium: TextStyles.textStyleHeadlineMedium.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 20,
      ),
      headlineSmall: TextStyles.textStyleHeadlineSmall.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 18,
      ),

      titleLarge: TextStyles.textStyleTitleLarge.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 16,
      ),
      titleMedium: TextStyles.textStyleTitleMedium.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 14,
      ),
      titleSmall: TextStyles.textStyleTitleSmall.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 12,
      ),

      bodyLarge: TextStyles.textStyleBodyLarge.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 14,
      ),
      bodyMedium: TextStyles.textStyleBodyMedium.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 12,
      ),
      bodySmall: TextStyles.textStyleBodySmall.copyWith(
        fontFamily: fontFamily,
        color: AppColors.lightThemeTextColor,
        fontSize: 10,
      ),
    ),

    inputDecorationTheme: AppTheme.inputFormThemeLight,
  );
});
