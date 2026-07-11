import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/l10n/app_localizations.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/router_config.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(goRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        final locale = ref.watch(appLangProvider);
        final themeData = ref.watch(appThemeDataProvider);
        return MaterialApp.router(
          title: 'Karaniz',
          debugShowCheckedModeBanner: false,
          routerConfig: routerConfig,
          theme: themeData,
          darkTheme: themeData,
          themeMode: .light,

          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],

          locale: locale,
          supportedLocales: const [Locale('en'), Locale('fa'), Locale('ps')],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale?.languageCode == 'ps') {
              return const Locale('fa');
            }
            return locale;
          },
        );
      },
    );
  }
}
