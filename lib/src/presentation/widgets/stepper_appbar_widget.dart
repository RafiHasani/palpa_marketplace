import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_stepper_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';

class StepperAppbarWidget extends ConsumerWidget
    implements PreferredSizeWidget {
  const StepperAppbarWidget({
    super.key,
    required this.stepClicked,
    required this.onBackPressed,
  });

  final Function(int value) stepClicked;
  final Function() onBackPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);
    return Column(
      mainAxisAlignment: .end,
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            IconButton(
              onPressed: () {
                onBackPressed();
              },
              icon: getArrowIcon(local),
            ),
            Text(
              context.local.publish_product,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
        16.verticalSpace,

        Padding(
          padding: .symmetric(horizontal: 16.w),
          child: CustomStepperWidget(
            stepClicked: (int step) {
              stepClicked(step);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => .fromHeight(120.h);
}
