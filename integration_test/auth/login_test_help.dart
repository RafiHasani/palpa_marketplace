import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';

Future<void> loginAsProducer(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const Key(TestKeys.userbottomNavigationBarSettingskey)).first,
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key(TestKeys.gotoLoginpage)).first);
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key(TestKeys.usernamefield)),
    'rafi_1',
  );

  await tester.enterText(
    find.byKey(const Key(TestKeys.passwordfield)),
    '12341234',
  );

  await tester.tap(find.byKey(const Key(TestKeys.loginButton)));
  await tester.pumpAndSettle();
}
