import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';

class CategoriesAllPage extends StatelessWidget {
  static const String path = '/categoriesall';
  const CategoriesAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //App bar
      appBar: AppbarPageWidget(),

      body: Center(child: Text('All Categories')),
    );
  }
}
