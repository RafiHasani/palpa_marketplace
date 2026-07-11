import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CustomDatePickerWidget extends ConsumerStatefulWidget {
  const CustomDatePickerWidget({super.key, required this.callback});

  final Function(Jalali date) callback;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomDatePickerWidget();
}

class _CustomDatePickerWidget extends ConsumerState<CustomDatePickerWidget> {
  int selectedYear = Jalali.now().year;
  String selectedMonth = '';
  int selectedMonthNumber = 1;
  int selectedDay = 1;

  final List<int> years = List.generate(
    101,
    (i) => (Appconfig().jalaliDate.year - 118) + i,
  ).reversed.toList();
  final List<int> days = List.generate(31, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    final locale = ref.read(appLangProvider);
    final months = Constants.getMonths(locale);

    return Column(
      mainAxisSize: .min,
      children: [
        Padding(
          padding: .symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  final date = Jalali(
                    selectedYear,
                    selectedMonthNumber,
                    selectedDay,
                  );
                  widget.callback(date);
                },
                child: Text(
                  context.local.confirm,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  context.local.cancel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: years.indexOf(selectedYear),
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedYear = years[index];
                    });
                  },
                  children: years
                      .map((y) => Center(child: Text('$y')))
                      .toList(),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem:
                        months.indexWhere((item) => item == selectedMonth) - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMonth = months[index];
                      selectedMonthNumber = index + 1;
                    });
                  },
                  children: Constants.getMonths(
                    locale,
                  ).map((m) => Center(child: Text(m))).toList(),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedDay - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedDay = days[index];
                    });
                  },
                  children: days.map((d) => Center(child: Text('$d'))).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
