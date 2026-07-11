import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';

class CustomStepperWidget extends ConsumerStatefulWidget {
  const CustomStepperWidget({super.key, required this.stepClicked});

  final Function(int step) stepClicked;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomStepperWidget();
}

class _CustomStepperWidget extends ConsumerState<CustomStepperWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProductProvider);
    final provider = ref.read(createProductProvider.notifier);
    final theme = ref.read(appThemeDataProvider);
    return Column(
      spacing: 8.h,
      children: [
        Row(
          mainAxisSize: .max,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            InkWell(
              onTap: () {
                provider.setCurrentStep(1);
                widget.stepClicked(1);
              },
              child: CustomSteper(isActive: (state.currentStep >= 1), count: 1),
            ),
            Expanded(
              child: Divider(
                height: 2.h,
                color: (state.currentStep >= 2)
                    ? AppColors.primaryColor
                    : AppColors.lineColor,
                thickness: 2,
              ),
            ),
            InkWell(
              onTap: () {
                if (state.currentStep > 1) {
                  provider.setCurrentStep(2);
                  widget.stepClicked(2);
                }
              },
              child: CustomSteper(isActive: (state.currentStep >= 2), count: 2),
            ),
            Expanded(
              child: Divider(
                height: 2.h,
                color: (state.currentStep == 3)
                    ? AppColors.primaryColor
                    : AppColors.lineColor,
                thickness: 2,
              ),
            ),
            InkWell(
              child: CustomSteper(isActive: (state.currentStep >= 3), count: 3),
            ),
          ],
        ),

        Padding(
          padding: .symmetric(horizontal: 4.w),
          child: Row(
            mainAxisSize: .max,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Text(
                context.local.information,
                style: theme.textTheme.bodyMedium,
              ),
              Spacer(),
              Text(
                '${context.local.details}    ',
                style: theme.textTheme.bodyMedium,
              ),
              Spacer(),
              Text(context.local.publish, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSteper extends ConsumerWidget {
  const CustomSteper({super.key, required this.isActive, required this.count});

  final bool isActive;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return Row(
      mainAxisSize: .max,
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: .all(color: AppColors.lineColor),
            shape: .circle,
          ),
          child: CircleAvatar(
            radius: 16.r,
            backgroundColor: isActive
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            child: Text(
              count.toLocalNumber(local),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isActive ? AppColors.whiteColor : AppColors.black2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
