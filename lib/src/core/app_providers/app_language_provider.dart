import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palpa_marketplace/src/core/constants/contants.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';

class AppLanguageProvider extends Notifier<Locale> {
  @override
  Locale build() {
    return Locale('fa');
  }

  Locale getLocal() {
    return state;
  }

  Future<void> setLanguage(Locale local) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(Constants.appLanguage, local.languageCode);
    state = local;
  }
}

final appLangProvider = NotifierProvider<AppLanguageProvider, Locale>(
  AppLanguageProvider.new,
);

enum AppLang { fa, ps, en }
