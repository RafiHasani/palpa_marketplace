import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

List<Widget> getRating(int rate, {double? startSize}) {
  List<Widget> rating = [];
  for (int i = 1; i <= 5; i++) {
    if (i <= rate) {
      rating.add(
        SvgIcon(
          assetName: 'assets/icons/rate_start.svg',
          size: startSize ?? 9.r,
        ),
      );
    } else {
      rating.add(
        SvgIcon(
          assetName: 'assets/icons/rate_star_not_filled.svg',
          size: startSize ?? 9.r,
        ),
      );
    }
  }
  return rating;
}
