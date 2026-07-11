import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/text_styles.dart';

class AppTheme {
  static ThemeData get lightThemeData => ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorLight,
    focusColor: AppColors.focueButtonColorLight,
    unselectedWidgetColor: AppColors.unFocuButtonColorLigth,
    primaryColorLight: AppColors.blackColor,
    primaryColor: AppColors.primaryColorLight,
    textTheme: _lightTextTheme,
    inputDecorationTheme: inputFormThemeLight,
  );

  static ThemeData get darkThemeData => ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    focusColor: AppColors.focueButtonColor,
    unselectedWidgetColor: AppColors.unFocuButtonColor,
    primaryColor: AppColors.primaryColorDark,
    textTheme: _darkTextTheme,
    inputDecorationTheme: inputFormThemeDark,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyles.textStyleDisplayLarge,
    displayMedium: TextStyles.textStyleDisplayMedium,
    displaySmall: TextStyles.textStyleDisplaySmall,
    titleLarge: TextStyles.textStyleTitleLarge,
    titleMedium: TextStyles.textStyleTitleMedium,
    titleSmall: TextStyles.textStyleTitleSmall,
    bodyLarge: TextStyles.textStyleBodyLarge,
    bodyMedium: TextStyles.textStyleBodyMedium,
    bodySmall: TextStyles.textStyleBodySmall,
    headlineLarge: TextStyles.textStyleHeadlineLarge,
    headlineMedium: TextStyles.textStyleHeadlineMedium,
    headlineSmall: TextStyles.textStyleHeadlineSmall,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyles.textStyleDisplayLargeDark,
    displayMedium: TextStyles.textStyleDisplayMediumDark,
    displaySmall: TextStyles.textStyleDisplaySmallDark,
    titleLarge: TextStyles.textStyleTitleLargeDark,
    titleMedium: TextStyles.textStyleTitleMediumDark,
    titleSmall: TextStyles.textStyleTitleSmallDark,
    bodyLarge: TextStyles.textStyleBodyLargeDark,
    bodyMedium: TextStyles.textStyleBodyMediumDark,
    bodySmall: TextStyles.textStyleBodySmallDark,
    headlineLarge: TextStyles.textStyleHeadlineLargeDark,
    headlineMedium: TextStyles.textStyleHeadlineMediumDark,
    headlineSmall: TextStyles.textStyleHeadlineSmallDark,
  );

  // input decoration Theme data
  static InputDecorationTheme get inputFormThemeLight => InputDecorationTheme(
    hintStyle: _lightTextTheme.bodySmall?.copyWith(
      color: AppColors.textFieldHintColor,
      fontSize: 12,
    ),
    filled: true,
    fillColor: AppColors.whiteColor,

    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.inputBorderUnFocusedColorLight,
        width: 0.7,
      ),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.inputBorderUnFocusedColorLight,
        width: 0.7,
      ),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),

    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.inputBorderFocusedColorLight,
        width: 0.7,
      ),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.inputBorderUnFocusedColorLight),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
  );

  static InputDecorationTheme get inputTextFeildThemeLightRadiu10 =>
      InputDecorationTheme(
        hintStyle: _lightTextTheme.bodySmall?.copyWith(
          color: AppColors.textFieldHintColor,
          fontSize: 12,
        ),
        filled: true,
        fillColor: AppColors.whiteColor,

        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderUnFocusedColorLight,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderUnFocusedColorLight,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderFocusedColorLight,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderUnFocusedColorLight,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      );

  static InputDecorationTheme get inputFormThemeDark => InputDecorationTheme(
    hintStyle: _darkTextTheme.bodySmall,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.inputBorderFocusedColorDark),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.inputBorderFocusedColorDark,
        width: 0.5,
      ),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.inputBorderFocusedColorDark),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade700),
      borderRadius: BorderRadius.all(Radius.circular(56.0)),
    ),
  );
}
