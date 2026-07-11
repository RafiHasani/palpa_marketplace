import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

class CustomDropDownWidget<T> extends ConsumerStatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChange;
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator validation;

  const CustomDropDownWidget({
    super.key,
    required this.items,
    required this.onChange,
    required this.controller,
    required this.hintText,
    required this.validation,
  });

  @override
  ConsumerState<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T>
    extends ConsumerState<CustomDropDownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    return Stack(
      alignment: .center,
      children: [
        TextFormField(
          controller: widget.controller,
          validator: widget.validation,
          decoration:
              InputDecoration(
                suffixIcon: SizedBox(
                  height: 14.h,
                  width: 14.w,
                  child: SvgIcon(
                    assetName: 'assets/icons/open_arrow_down.svg',
                    fit: .scaleDown,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium,
              ).copyWith(
                focusedBorder:
                    AppTheme.inputTextFeildThemeLightRadiu10.focusedBorder,
                errorBorder:
                    AppTheme.inputTextFeildThemeLightRadiu10.errorBorder,
                border: AppTheme.inputTextFeildThemeLightRadiu10.border,
                focusedErrorBorder:
                    AppTheme.inputTextFeildThemeLightRadiu10.focusedErrorBorder,
                enabledBorder:
                    AppTheme.inputTextFeildThemeLightRadiu10.enabledBorder,
                disabledBorder:
                    AppTheme.inputTextFeildThemeLightRadiu10.enabledBorder,
              ),
        ),
        Row(
          mainAxisSize: .max,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: DropdownButton<T>(
                isExpanded: true,
                iconSize: 0,
                alignment: AlignmentDirectional.centerStart,
                padding: .symmetric(horizontal: 24.w),
                hint: null,
                menuWidth: 0.9.sw,
                elevation: 0,
                icon: null,
                underline: SizedBox.shrink(),
                items: widget.items,
                onChanged: (value) {
                  widget.onChange(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
