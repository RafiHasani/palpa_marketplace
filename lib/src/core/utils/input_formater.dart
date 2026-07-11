import 'dart:ui';

String localizeNumber(String num, Locale locale) {
  Map<String, String> arabicNumbers = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  Map<String, String> toEnglishNumbers = {
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

  if (locale.languageCode.toLowerCase() == 'fa' ||
      locale.languageCode.toLowerCase() == 'ps') {
    return num.split('').map((i) => arabicNumbers[i] ?? i).join();
  } else if (locale.languageCode.toLowerCase() == 'en') {
    return num.split('').map((i) => toEnglishNumbers[i] ?? i).join();
  }
  return "";
}
