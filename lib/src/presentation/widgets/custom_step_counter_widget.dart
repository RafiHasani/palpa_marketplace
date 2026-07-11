import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/input_formater.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

class CustomStepCounterWidget extends ConsumerStatefulWidget {
  const CustomStepCounterWidget({
    super.key,
    this.totalValue,
    required this.counterCallback,
    required this.height,
  });

  final int? totalValue;
  final Function(int value) counterCallback;
  final double height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomStepCounterWidget();
}

class _CustomStepCounterWidget extends ConsumerState<CustomStepCounterWidget> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<int> count = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    numberContrllersforTranslation();
    controller.text = '1';
  }

  void numberContrllersforTranslation() {
    final local = ref.read(appLangProvider);
    controller.addListener(() {
      final text = controller.text;
      final newText = localizeNumber(text, local);

      if (text != newText) {
        controller.value = controller.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);

    return Container(
      height: widget.height,
      width: 0.6.sw,
      decoration: BoxDecoration(
        border: .all(color: AppColors.cardBorderColor),
        borderRadius: .circular(6.r),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          IconButton(
            onPressed: () {
              String str = controller.text;
              if (str.isEmpty) {
                count.value = 1;
                controller.text = count.value.toLocalNumberWithSeparator(local);
                widget.counterCallback(count.value);
              } else {
                count.value = str.parseToEnglish();
                count.value += 1;
                controller.text = count.value.toLocalNumberWithSeparator(local);
                widget.counterCallback(count.value);
              }
            },
            icon: SvgIcon(assetName: 'assets/icons/positive.svg'),
          ),
          Container(
            width: 1.w,
            color: AppColors.cardBorderColor,
            margin: .symmetric(vertical: 8.h),
          ),
          Spacer(flex: 1),
          ValueListenableBuilder<int>(
            valueListenable: count,
            builder: (context, value, child) {
              return SizedBox(
                width: 0.3.sw,
                child: TextField(
                  enableInteractiveSelection: false,
                  inputFormatters: [LengthLimitingTextInputFormatter(9)],
                  keyboardType: .number,
                  controller: controller,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                  ),
                  textAlign: .center,
                  textAlignVertical: .center,
                  decoration: InputDecoration(
                    counterText: '',
                    border: .none,
                    errorBorder: .none,
                    enabledBorder: .none,
                    focusedBorder: .none,
                    disabledBorder: .none,
                  ),
                  maxLength: 9,
                  maxLines: 1,
                  showCursor: true,
                ),
              );
            },
          ),
          Spacer(flex: 1),
          Container(
            width: 1.w,
            color: AppColors.cardBorderColor,
            margin: .symmetric(vertical: 8.h),
          ),
          IconButton(
            onPressed: () {
              if (count.value > 1) {
                String str = controller.text;
                count.value = str.parseToEnglish();

                count.value -= 1;

                controller.text = count.value.toLocalNumberWithSeparator(local);
                widget.counterCallback(count.value);
              }
            },
            icon: SvgIcon(assetName: 'assets/icons/negative.svg'),
          ),
        ],
      ),
    );
  }
}
