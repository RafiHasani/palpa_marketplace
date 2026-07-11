import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';
import 'package:palpa_marketplace/src/data/models/user.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Appconfig {
  static final Appconfig _singleton = Appconfig._internal();
  factory Appconfig() {
    return _singleton;
  }

  Appconfig._internal();

  final String baseUrl =
      'https://api.karaniz.com'; // 'https://api.palpa.store';

  String? token;
  User? user;

  List<String> searchedProducts = [];

  String? appLang;

  Jalali jalaliDate = Jalali.now();

  List<UnitModel>? unites;
  List<ProvinceModel>? province;
}
