import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String path = '/privacypolicypage';
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPageWidget(hideSearch: true),

      body: Center(child: Text('Privacy & Policy')),
    );
  }
}
