import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';

class TermsConditionPage extends StatelessWidget {
  static const String path = '/termsconditionpage';
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPageWidget(hideSearch: true),

      body: Center(child: Text('Terms & Conditions')),
    );
  }
}
