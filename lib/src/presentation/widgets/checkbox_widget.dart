import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class CustomCheckBoxWidget extends StatefulWidget {
  const CustomCheckBoxWidget({
    super.key,
    required this.state,
    this.intialValue = false,
  });

  final Function(bool isChecked) state;
  final bool? intialValue;

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.intialValue ?? isChecked,
      onChanged: (newValue) {
        isChecked = newValue ?? false;
        widget.state(isChecked);
      },
      checkColor: AppColors.primaryColor,
      activeColor: AppColors.containerFilledColor,
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.containerFilledColor;
        }
        return AppColors.containerFilledColor;
      }),
      shape: RoundedRectangleBorder(borderRadius: .circular(6.r)),
      side: BorderSide(color: AppColors.textFieldHintColor),
    );
  }
}
