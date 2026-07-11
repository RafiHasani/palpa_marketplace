import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:palpa_marketplace/src/presentation/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_test_verify.dart';

import 'package:palpa_marketplace/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App test', () {
    testWidgets('Auth Flow Test (producer)', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const app.MainApp(),
        ),
      );

      await tester.pumpAndSettle();

      await loginAndVerifyProducerHome(tester);
    });
  });
}
