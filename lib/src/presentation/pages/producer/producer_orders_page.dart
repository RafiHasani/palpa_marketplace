import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_orders/producer_orders_mine_tab_widget.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_orders/producer_orders_others_tab_widget.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';

class ProducerOrdersPage extends ConsumerStatefulWidget {
  static const String path = '/producerorderspage';
  const ProducerOrdersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerOrdersPageState();
}

class _ProducerOrdersPageState extends ConsumerState<ProducerOrdersPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    Future.microtask(() {
      ref.read(producerProductProvider.notifier).getOrdersOfMine();
    });
    Future.microtask(() {
      ref.read(producerProductProvider.notifier).getOrdersOfOther();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLangProvider, (prev, next) {
      if (prev != next) {
        loadData();
      }
    });
    final theme = ref.read(appThemeDataProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: .fromHeight(100.h),
          child: AppBar(
            leadingWidth: 0.5.sw,
            leading: Padding(
              padding: .symmetric(horizontal: 16.w),
              child: Text(
                context.local.orders,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            bottom: TabBar(
              labelColor: AppColors.primaryColor,
              padding: .symmetric(horizontal: 16.w),
              indicatorColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.unFocuButtonColor,
              labelStyle: theme.textTheme.bodySmall,
              indicatorSize: .tab,
              tabs: [
                Tab(text: context.local.other_orders),
                Tab(text: context.local.my_orders),
              ],
              onTap: (value) {
                if (value == 0) {
                  ref.read(producerProductProvider.notifier).getOrdersOfOther();
                } else {
                  ref.read(producerProductProvider.notifier).getOrdersOfMine();
                }
              },
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ProducerOrdersOthersTabWidget(),
              ProducerOrdersMineTabWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
