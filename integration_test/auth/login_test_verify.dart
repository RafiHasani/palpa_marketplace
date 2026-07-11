import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palpa_marketplace/src/core/constants/test_keys.dart';

import 'login_test_help.dart';

Future<void> loginAndVerifyProducerHome(WidgetTester tester) async {
  await loginAsProducer(tester);

  expect(find.byKey(const Key(TestKeys.producerHomePath)), findsOneWidget);
}
