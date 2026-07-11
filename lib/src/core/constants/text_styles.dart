import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class TextStyles {
  static TextStyle get textStyleDisplayLarge => TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.lightThemeTextColor,
  );

  static TextStyle get textStyleDisplayMedium => TextStyle(
    fontSize: 45.0, // Used 45.0 for standard scale, was 28.0 in your snippet
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to displaySmall
  static TextStyle get textStyleDisplaySmall => TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w400,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to headlineLarge
  static TextStyle get textStyleHeadlineLarge => TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w600, // Semi-Bold
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to headlineMedium
  static TextStyle get textStyleHeadlineMedium => TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to headlineSmall
  static TextStyle get textStyleHeadlineSmall => TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to titleLarge (Your original Title size used here)
  static TextStyle get textStyleTitleLarge => TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600, // Semi-Bold
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to titleMedium (Your original Subtitle size used here)
  static TextStyle get textStyleTitleMedium => TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to titleSmall
  static TextStyle get textStyleTitleSmall => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to bodyLarge
  static TextStyle get textStyleBodyLarge => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700, // Regular
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to bodyMedium (Your original Body size used here)
  static TextStyle get textStyleBodyMedium => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to bodySmall
  static TextStyle get textStyleBodySmall => TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to labelLarge (Used for buttons, links, etc.)
  static TextStyle get textStyleLabelLarge => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600, // Often semi-bold for actions
    letterSpacing: 1.2,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to labelMedium (Used for captions, helper text)
  static TextStyle get textStyleLabelMedium => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.lightThemeTextColor,
  );

  // Corresponds to labelSmall
  static TextStyle get textStyleLabelSmall => TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    color: AppColors.lightThemeTextColor,
  );

  // Text Style
  static TextStyle get textStyleDisplayLargeDark =>
      textStyleDisplayLarge.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleDisplayMediumDark =>
      textStyleDisplayMedium.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleDisplaySmallDark =>
      textStyleDisplaySmall.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleHeadlineLargeDark =>
      textStyleHeadlineLarge.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleHeadlineMediumDark =>
      textStyleHeadlineMedium.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleHeadlineSmallDark =>
      textStyleHeadlineSmall.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleTitleLargeDark =>
      textStyleTitleLarge.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleTitleMediumDark =>
      textStyleTitleMedium.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleTitleSmallDark =>
      textStyleTitleSmall.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleBodyLargeDark =>
      textStyleBodyLarge.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleBodyMediumDark =>
      textStyleBodyMedium.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleBodySmallDark =>
      textStyleBodySmall.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleLabelLargeDark =>
      textStyleLabelLarge.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleLabelMediumDark =>
      textStyleLabelMedium.copyWith(color: AppColors.darkThemeTextColor);
  static TextStyle get textStyleLabelSmallDark =>
      textStyleLabelSmall.copyWith(color: AppColors.darkThemeTextColor);
}
