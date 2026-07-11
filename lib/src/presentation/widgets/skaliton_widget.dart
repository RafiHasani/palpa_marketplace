import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class SkalitonWidget extends StatelessWidget {
  final double height;
  final double width;

  const SkalitonWidget({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.containerFilledColor,
        borderRadius: .circular(10.r),
        border: .all(color: AppColors.cardBorderColor, width: 0.7.w),
      ),
    );
  }
}
