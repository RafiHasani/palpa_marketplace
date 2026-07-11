import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

RotatedBox getOpenArrowIcon(Locale local) {
  return RotatedBox(
    quarterTurns: local.languageCode == 'en' ? 2 : 4,
    child: SvgIcon(assetName: 'assets/icons/open_arrow_left.svg'),
  );
}

RotatedBox getArrowIcon(Locale local) {
  return RotatedBox(
    quarterTurns: local.languageCode == 'en' ? 2 : 4,
    child: SvgIcon(
      assetName: 'assets/icons/arrow_right.svg',
      color: AppColors.backButtonColor,
    ),
  );
}
