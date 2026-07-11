import 'dart:ui';

class Constants {
  static const appLanguage = 'appLang';
  static const authToken = 'authToken';
  static const user = 'user';

  static const children = 'children';
  static const parent = 'parent';
  static const products = 'products';
  static const searchHistory = 'searchHistory';

  static const passwordLengthLimit = 25;
  static const usernameLengthLimit = 10;

  static const List<String> pashtoMonths = [
    'وری', // Wray
    'غویی', // Ghwai
    'غبرګولی', // Ghbargolai
    'چنګاښ', // Changakh
    'زمری', // Zmarai
    'وږی', // Wazhai
    'تله', // Tula
    'لړم', // Laram
    'لیندۍ', // Lindai
    'مرغومی', // Marghomai
    'سلواغه', // Salwāgha
    'کب', // Kab
  ];

  static const List<String> dariMonths = [
    'حمل', // Hamal
    'ثور', // Sawr
    'جوزا', // Jawza
    'سرطان', // Saratan
    'اسد', // Asad
    'سنبله', // Sonbola
    'میزان', // Mizan
    'عقرب', // Aqrab
    'قوس', // Qaws
    'جدی', // Jadi
    'دلو', // Dalwa
    'حوت', // Hoot
  ];

  static const List<String> gregorianMonths = [
    'January', // 1
    'February', // 2
    'March', // 3
    'April', // 4
    'May', // 5
    'June', // 6
    'July', // 7
    'August', // 8
    'September', // 9
    'October', // 10
    'November', // 11
    'December', // 12
  ];

  static List<String> getMonths(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return gregorianMonths;
      case 'fa':
        return dariMonths;
      case 'ps':
        return pashtoMonths;
      default:
        return dariMonths;
    }
  }

  static const languagesEnglish = ['Dari', 'Pashtu', 'English'];

  static const languagesdaripashtu = ['دري', 'پښتو', 'انګلیسي'];

  static const languages = [
    Language(nameFa: 'دري', namePs: 'دري', nameEn: 'Dari', symbol: 'fa'),
    Language(nameFa: 'پښتو', namePs: 'پښتو', nameEn: 'Pashtu', symbol: 'ps'),
    Language(
      nameFa: 'انګلیسي',
      namePs: 'انګلیسي',
      nameEn: 'انګلیسي',
      symbol: 'en',
    ),
  ];
}

class Language {
  final String nameFa;
  final String namePs;
  final String nameEn;
  final String symbol;

  const Language({
    required this.nameFa,
    required this.namePs,
    required this.nameEn,
    required this.symbol,
  });
}
