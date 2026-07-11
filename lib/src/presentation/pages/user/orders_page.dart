import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/home_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/product_list_details_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/order_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/add_product_review_sheet.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/text_button_icon_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/user_orders_widget.dart';

class OrdersPage extends ConsumerStatefulWidget {
  static const String path = "/orderspage";
  const OrdersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersPage();
}

class _OrdersPage extends ConsumerState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderProvider.notifier).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLangProvider, (prev, next) {
      if (prev != next) {
        Future.microtask(() {
          ref.read(orderProvider.notifier).getOrders();
        });
      }
    });
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(orderProvider);
    final orderList = state.orderResponseModel?.data ?? [];

    final provider = ref.read(orderProvider.notifier);

    ref.listen(orderProvider, (pre, next) {
      if (next.apiCallStatus == .placingOrderSucess) {
        if (context.canPop()) {
          context.pop();
          context.showMySnackBar(content: context.local.order_placed_success);
        }
        provider.getOrders();
      }

      if (next.apiCallStatus == .orderSatetUpdatingSuccess) {
        if (context.canPop()) {
          context.pop();
          context.showMySnackBar(content: context.local.order_canceled_success);
        }
        provider.getOrders();
      }

      if (next.apiCallStatus == .orderSatetUpdatingFailed ||
          next.apiCallStatus == .placingOrderFailed) {
        if (context.canPop()) {
          context.pop();
          context.showMySnackBar(
            content:
                next.errorMessage?.error ?? context.local.somethingwentwrong,
          );
        }
      }
    });

    return LoadingWidget(
      isLoading: state.apiCallStatus == .loadingOrder,
      child: Scaffold(
        appBar: AppbarPageWidget(
          hideSearch: true,
          titleOnly: true,
          title: context.local.orders,
        ),
        body: RefreshIndicator.adaptive(
          color: AppColors.primaryColor,
          onRefresh: () async {
            Future.microtask(() {
              ref.read(orderProvider.notifier).getOrders();
            });
          },
          child: orderList.isNotEmpty
              ? ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    final item = orderList[index];
                    return OrderListingWidget(
                      order: item,
                      updating: () {
                        show(context, item);
                      },
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: .center,
                  children: [
                    Center(child: SvgIcon(assetName: 'assets/icons/cart.svg')),
                    16.verticalSpace,
                    Text(
                      context.local.no_orders_yet,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      context.local.time_to_explore_market,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subTitileTextColor,
                      ),
                    ),
                    16.verticalSpace,
                    TextIconButtonWidget(
                      iconAlignment: .center,
                      actionTextIconButton: () {
                        context.go(HomePage.path);
                      },
                      actionButtonTitle: context.local.go_explore_market,
                      icon: getOpenArrowIcon(local),
                    ),
                  ],
                ),
        ),

        bottomNavigationBar: orderList.isNotEmpty
            ? SafeArea(
                child: Container(
                  color: AppColors.whiteColor,
                  height: 56.h,
                  margin: .only(bottom: 0.05.sh),
                  child: Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          context.local.your_cart_summary,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textFieldHintColor,
                          ),
                        ),

                        Text(
                          '${state.totalAmount?.toLocalNumber(local)} ${context.local.afghani}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Future<void> show(BuildContext context, OrderModel orderModel) async {
    final theme = ref.read(appThemeDataProvider);

    final state = ref.read(orderProvider);
    final provider = ref.read(orderProvider.notifier);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: LoadingWidget(
          isLoading: state.apiCallStatus == .orderStateUpdating,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: .zero,
                leading: SvgIcon(
                  assetName: 'assets/icons/edit.svg',
                  size: 13.r,
                ),

                title: Text(
                  context.local.cancel,
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  if (orderModel.statusLabel == OrderStatus.pending.name) {
                    provider.cancelOrderByUser(orderModel.number);
                  } else {
                    if (context.canPop()) {
                      context.pop();
                    }
                    context.showMySnackBar(
                      content: context.local.change_order_pending,
                    );
                  }
                },
              ),

              ListTile(
                contentPadding: .zero,
                leading: SvgIcon(
                  assetName: 'assets/icons/show.svg',
                  size: 13.r,
                ),
                title: Text(
                  context.local.view,
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }

                  context.push(
                    context.getRouterCurrentPath + ProductListDetailsPage.path,
                    extra: orderModel.product.slug,
                  );
                },
              ),

              ListTile(
                contentPadding: .zero,
                leading: SvgIcon(
                  assetName: 'assets/icons/more_icon.svg',
                  size: 13.r,
                ),
                title: Text(
                  context.local.submit_review,
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  showAddReview(context, orderModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddReview(
    BuildContext context,
    OrderModel orderModel,
  ) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: .only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) => SizedBox(
        height: 0.8.sh,
        child: AddProductReviewSheet(orderModel: orderModel),
      ),
    );
  }
}
