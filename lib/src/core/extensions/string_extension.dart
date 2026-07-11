import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:shamsi_date/shamsi_date.dart';

extension DateCenvertion on String {
  String toPersianDate(Locale locale) {
    final date = DateTime.parse(this);
    final gregorian = Gregorian.fromDateTime(date);
    final jalaliDate = Jalali.fromGregorian(gregorian);
    final f = jalaliDate.formatter;

    return '${f.d.toNumber().toLocalNumber(locale)} ${f.mNAf}  ${f.yyyy.toNumber().toLocalNumber(locale)} ';
  }

  String toPersianDate2(Locale locale) {
    final date = DateTime.parse(this);
    final gregorian = Gregorian.fromDateTime(date);
    final jalaliDate = Jalali.fromGregorian(gregorian);
    final f = jalaliDate.formatter;

    return ' ${f.d.toNumber().toLocalNumber(locale)} / ${f.mm.toNumber().toLocalNumber(locale)} / ${f.yyyy.toNumber().toLocalNumber(locale)}  ';
  }

  double toNumber() {
    final num = double.parse(this);
    return num;
  }

  int toNumberInteger() {
    final num = int.parse(this);
    return num;
  }

  bool isEmail() {
    final isMatched = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-]+$').hasMatch(this);
    return isMatched;
  }

  bool isPhone() {
    final RegExp phoneRegex = RegExp(r'^([0-9\s-+()]*)$');

    return phoneRegex.hasMatch(this);
  }

  int parseNumber(String num, String language) {
    Map<String, String> arabicNumbers = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',

      // Persian, Pashto, and Urdu digits (U+06F0–U+06F9)
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    if (language.toLowerCase() == 'fa' || language.toLowerCase() == 'ps') {
      return int.tryParse(
            num.split('').map((i) => arabicNumbers[i] ?? i).join(),
          ) ??
          0;
    } else {
      final num1 = num.split('').map((i) => i).join();

      return int.parse(num1);
    }
  }

  int parseToEnglish() {
    Map<String, String> toEnglishNumbers = {
      // Arabic digits (U+0660–U+0669)
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '٬': '',

      // Persian, Pashto, and Urdu digits (U+06F0–U+06F9)
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    final num1 = split('').map((i) => toEnglishNumbers[i] ?? i).join();
    return int.parse(num1);
  }
}

extension JalaliDateFormat on Jalali {
  String fomated(Locale locale) {
    final f = formatter;

    return ' ${f.d.toNumber().toLocalNumber(locale)} / ${f.mm.toNumber().toLocalNumber(locale)} / ${f.yyyy.toNumberInteger().toLocalNumberWithSeparator(locale)}  ';
  }
}
