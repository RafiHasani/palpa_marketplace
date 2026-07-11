import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchDialer(String phoneNumber) async {
  try {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> launchEmail(String phoneNumber) async {
  final Uri emailUri = Uri(scheme: 'mailto', path: 'palpa@asrepoya.com');
  try {
    await launchUrl(emailUri);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> launchBrowser(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    debugPrint(e.toString());
  }
}
