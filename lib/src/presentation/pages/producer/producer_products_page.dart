import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_main_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/heading_row_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/producer_myproduct_card_widget.dart';

class ProducerProductsPage extends ConsumerStatefulWidget {
  static const String path = '/producerproductspage';
  const ProducerProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerProductsPage();
}

class _ProducerProductsPage extends ConsumerState<ProducerProductsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(producerProductProvider.notifier).getMyProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(producerProductProvider);

    ref.listen(producerProductProvider, (pre, next) {
      if (next.producerApiStatus == .updatingMyProductStatusSuccess) {
        Future.microtask(() {
          ref.read(producerProductProvider.notifier).getMyProducts();
        });
      }
    });

    final list = productsState.myProductsList ?? [];

    return Scaffold(
      appBar: AppbarMainWidget(),
      body: SafeArea(
        child: DismissKeyboardWidget(
          child: RefreshIndicator.adaptive(
            color: AppColors.primaryColor,
            onRefresh: () async {
              Future.microtask(() {
                ref.read(producerProductProvider.notifier).getMyProducts();
              });
            },
            child: LoadingWidget(
              isLoading:
                  productsState.producerApiStatus == .gettingMyProduct ||
                  productsState.producerApiStatus == .updatingMyProductStatus,
              child: Column(
                children: [
                  16.verticalSpace,
                  HeadingRowWidget(title: context.local.my_products),
                  8.verticalSpace,
                  Expanded(
                    child: Padding(
                      padding: .symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        padding: .only(bottom: 38.h),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0.h,
                          crossAxisSpacing: 0.w,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return ProducerMyproductCardWidget(product: item);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
