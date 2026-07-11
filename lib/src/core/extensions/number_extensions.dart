import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension LanguageFormat on num {
  String toLocalNumber(Locale local) {
    return NumberFormat.decimalPattern(local.languageCode).format(this);
  }

  String toLocalNumberWithSeparator(Locale local) {
    final num = NumberFormat.decimalPattern(local.languageCode)
      ..turnOffGrouping();
    return num.format(this);
  }

  String toMinutesSeconds(Locale local) {
    final minutes = this ~/ 60;
    final seconds = this % 60;

    final mins = NumberFormat.decimalPattern(
      local.languageCode,
    ).format(minutes);
    final secs = NumberFormat.decimalPattern(
      local.languageCode,
    ).format(seconds);

    final m = mins.toString();
    final s = secs.toString().padLeft(
      2,
      NumberFormat.decimalPattern(local.languageCode).format(0),
    );

    return '$m:$s';
  }
}
