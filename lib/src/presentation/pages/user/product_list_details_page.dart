import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/producer_orders_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_details_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/appconfig.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/get_image_as_bytes.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/product_details_model.dart';
import 'package:palpa_marketplace/src/data/models/saler_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/common/others_user_profile_page.dart';
import 'package:palpa_marketplace/src/presentation/pages/user/orders_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/order_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/circular_progress_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_step_counter_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/product_details_banner_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/review_rating_card_widget.dart';

class ProductListDetailsPage extends ConsumerStatefulWidget {
  static const String path = '/productdetails';
  const ProductListDetailsPage({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListDetailsPage();
}

class _ProductListDetailsPage extends ConsumerState<ProductListDetailsPage> {
  QuillController specsController = QuillController.basic();
  QuillController introController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    Future.microtask(() {
      ref
          .read(productDetailsProvider.notifier)
          .getProducteDetailsData(slug: widget.slug, query: 'reviews');
    });
    Future.microtask(() {
      ref
          .read(productDetailsProvider.notifier)
          .getProducteReviews(slug: widget.slug);
    });
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(productDetailsProvider);
    final productDetails = state.productDetailsModel;

    final reviewData = state.productReviewResponseModel;
    final local = ref.read(appLangProvider);

    final orderState = ref.watch(orderProvider);

    ref.listen(productDetailsProvider, (prev, next) {
      if (next.apiCallStatus == .gettingProductDetailsSuccess) {
        final productDetails = next.productDetailsModel;
        loadQuillText(productDetails);
      }
    });

    ref.listen(orderProvider, (pre, next) async {
      if (next.apiCallStatus == .placingOrderSucess) {
        showSnack(msg: context.local.order_placed_success);

        if (Appconfig().user?.isProducer ?? false) {
          navigateToProducerOrders();
        } else {
          navigateToUserOrders();
        }
      }

      if (next.apiCallStatus == .placingOrderFailed) {
        showSnack(msg: next.errorMessage?.error);
      }
    });

    return DismissKeyboardWidget(
      child: LoadingWidget(
        isLoading:
            (orderState.apiCallStatus == .placingOrder ||
            state.apiCallStatus == .likingProduct ||
            state.apiCallStatus == .disLikingProduct ||
            (state.apiCallStatus == .gettingProductDetails)),
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppbarPageWidget(hideSearch: true),
          body: RefreshIndicator.adaptive(
            color: AppColors.primaryColor,
            onRefresh: () async {
              await loadData();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior: .onDrag,
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: .symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    ProductBannerWidget(),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                shareProduct(context, productDetails);
                              },
                              icon: SvgIcon(
                                assetName: 'assets/icons/upload.svg',
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (productDetails?.isLiked ?? false) {
                                  disLike();
                                } else {
                                  like();
                                }
                              },
                              icon: (productDetails?.isLiked ?? false)
                                  ? SvgIcon(
                                      assetName:
                                          'assets/icons/favourite_filled.svg',
                                      color: AppColors.primaryColor,
                                      size: 18.r,
                                    )
                                  : SvgIcon(
                                      assetName: 'assets/icons/favourite.svg',
                                      color: AppColors.focueButtonColor,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      productDetails?.name ?? '',
                      style: theme.textTheme.bodyLarge,
                    ),
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: .center,
                      spacing: 16.w,
                      children: [
                        if (productDetails?.ratingsAverage != null)
                          Row(
                            spacing: 4.w,
                            crossAxisAlignment: .center,
                            children: [
                              SvgIcon(assetName: 'assets/icons/rate_start.svg'),
                              Text(
                                '${productDetails?.ratingsAverage?.toNumber().toLocalNumber(local) ?? 0.0}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.subTitileTextColor,
                                ),
                              ),
                              4.horizontalSpace,
                              Text(
                                '(${productDetails?.ratingsCount?.toLocalNumber(local) ?? 0})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textFieldHintColor,
                                ),
                              ),
                            ],
                          ),

                        if (productDetails?.reviewsCount != null)
                          Text(
                            ' ${productDetails?.reviewsCount?.toLocalNumber(local) ?? 0}  ${context.local.user_reviews}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),

                        if (productDetails?.province != null)
                          Row(
                            spacing: 8.w,
                            children: [
                              SvgIcon(assetName: 'assets/icons/location.svg'),
                              Text(
                                '${productDetails?.province}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    24.verticalSpace,
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          context.local.specifications,
                          style: theme.textTheme.bodyLarge,
                        ),

                        AbsorbPointer(
                          child: QuillEditor.basic(
                            controller: specsController,
                            config: QuillEditorConfig(
                              padding: .all(10.r),
                              disableClipboard: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    24.verticalSpace,
                    Column(
                      spacing: 8.h,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          context.local.introduction,
                          style: theme.textTheme.bodyLarge,
                        ),
                        AbsorbPointer(
                          child: QuillEditor.basic(
                            controller: introController,
                            config: QuillEditorConfig(
                              padding: .all(10.r),
                              disableClipboard: true,
                            ),
                          ),
                        ),
                      ],
                    ),

                    24.verticalSpace,
                    if (productDetails?.saler != null)
                      SalerCardWidget(salerModel: productDetails!.saler),
                    36.verticalSpace,

                    Center(
                      child: CustomStepCounterWidget(
                        totalValue: productDetails?.stock ?? 0,
                        counterCallback: (int value) {
                          setState(() {
                            quantity = value;
                          });
                        },
                        height: 56.h,
                      ),
                    ),
                    36.verticalSpace,

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Column(
                          spacing: 8.h,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              context.local.user_reviews,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    24.verticalSpace,

                    if (productDetails?.ratingsBreakdown != null)
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        crossAxisAlignment: .center,
                        mainAxisSize: .max,
                        children: [
                          Column(
                            mainAxisAlignment: .center,
                            children: [
                              Row(
                                spacing: 4.w,
                                mainAxisAlignment: .center,
                                crossAxisAlignment: .center,
                                children: [
                                  SvgIcon(
                                    assetName: 'assets/icons/rate_start.svg',
                                  ),
                                  Text(
                                    productDetails?.ratingsAverage
                                            ?.toNumber()
                                            .toLocalNumber(local) ??
                                        '',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.black2,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${productDetails?.reviewsCount?.toLocalNumber(local) ?? ''} ${context.local.buyer}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.subTitileTextColor,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            spacing: 16.h,
                            children: productDetails!.ratingsBreakdown.entries
                                .map((element) {
                                  return RatingBarEntryWidget(
                                    starRate: element.key,
                                    percentage: element.value.percentage,
                                  );
                                })
                                .toList()
                                .reversed
                                .toList(),
                          ),
                        ],
                      ),

                    24.verticalSpace,
                    Text(
                      '${productDetails?.reviewsCount ?? 0} ${context.local.review}',
                      style: theme.textTheme.bodyLarge,
                    ),
                    8.verticalSpace,

                    state.apiCallStatus == .gettingProductReivewDetails
                        ? Center(child: CircularProgressWidget())
                        : Column(
                            crossAxisAlignment: .end,
                            spacing: 16.h,
                            mainAxisSize: .min,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: reviewData?.data?.length ?? 0,
                                itemBuilder: (_, index) {
                                  final list = reviewData?.data ?? [];
                                  return ReviewCardWidget(
                                    reviewModel: list[index],
                                  );
                                },
                              ),
                              // TextIconButtonWidget(
                              //   iconAlignment: .end,
                              //   actionTextIconButton: () {
                              //     // ref.read(productPageProvider.notifier).getProducteReviews(slug: slug);
                              //   },
                              //   actionButtonTitle: 'مشاهده دیدگاه بیشتر',
                              //   icon: null,
                              // ),
                            ],
                          ),

                    56.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          persistentFooterDecoration: BoxDecoration(
            color: AppColors.containerFilledColor,
          ),
          persistentFooterButtons:
              (state.apiCallStatus != .gettingProductDetails)
              ? [
                  Padding(
                    padding: .symmetric(horizontal: 16.h),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .center,
                      spacing: 32.w,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            isDisabled:
                                orderState.apiCallStatus == .placingOrder,
                            title: context.local.add_to_order_list,
                            onPressed: () {
                              if (Appconfig().user != null &&
                                  Appconfig().token != null) {
                                if (quantity > 0) {
                                  if (productDetails?.saler.username ==
                                      Appconfig().user?.username) {
                                    showSnack(
                                      msg: context
                                          .local
                                          .cannot_order_own_product,
                                    );
                                  } else {
                                    placeOrder(
                                      productDetails?.slug ?? '',
                                      quantity,
                                    );
                                  }
                                } else {
                                  context.showMySnackBar(
                                    content: context.local.product_quantity_min,
                                  );
                                }
                              } else {
                                context.showMySnackBar(
                                  content:
                                      context.local.login_required_to_order,
                                );
                              }
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .end,
                          mainAxisAlignment: .center,
                          spacing: 8.h,
                          children: [
                            if (productDetails?.hasDiscount ?? false)
                              Text(
                                '${productDetails?.discountPrice?.toNumber().toLocalNumber(local)}'
                                '  ${context.local.afghani}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.textFieldHintColor,
                                  decorationThickness: 0.5,
                                ),
                              ),

                            Text(
                              '${productDetails?.price.toNumber().toLocalNumber(local)} '
                              ' ${context.local.afghani} ',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Container(
                          height: 32.h,
                          width: 0.6.sw,
                          decoration: BoxDecoration(
                            color: AppColors.iconColor,
                            borderRadius: .circular(4.r),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 8.h,
                              width: 0.1.sw,
                              decoration: BoxDecoration(
                                color: AppColors.iconColor,
                                borderRadius: .circular(4.r),
                              ),
                            ),
                            8.verticalSpace,
                            Container(
                              height: 8.h,
                              width: 0.1.sw,
                              decoration: BoxDecoration(
                                color: AppColors.iconColor,
                                borderRadius: .circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Future<void> shareProduct(
    BuildContext context,
    ProductDetailsModel? item,
  ) async {
    try {
      final Uint8List? image;
      final slug = item?.slug;

      if (item?.thumbnails != null && item!.thumbnails.isNotEmpty) {
        image = await ref
            .read(productPageProvider.notifier)
            .getImageDataByte(item.thumbnails.first.path ?? '');
      } else {
        image = await getImageBytesFromAsset('assets/images/luncher.png');
      }
      String company = '';

      if (context.mounted) {
        company = context.local.karaniz;
      }

      final params = ShareParams(
        title:
            '$company - ${item?.name} - ${item?.category} - ${item?.category.parent?.name}',
        subject:
            '$company - ${item?.name} - ${item?.category} - ${item?.category.parent?.name}',
        previewThumbnail: XFile.fromData(image!),
        uri: Uri.parse('${Appconfig().baseUrl}/products/$slug'),
      );

      final shrePlus = SharePlus.instance;

      await shrePlus.share(params);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loadQuillText(ProductDetailsModel? productDetails) {
    if (productDetails?.about != null) {
      try {
        final aboutDoc = Document.fromJson(productDetails?.about?['ops']);

        introController.document = aboutDoc;
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (productDetails?.description != null) {
      try {
        final descDoc = Document.fromJson(productDetails?.description?['ops']);
        specsController.document = descDoc;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> placeOrder(String slug, int quantity) async {
    final provder = ref.read(orderProvider.notifier);
    await provder.placeOrder(slug: slug, quantity: quantity);
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }

  void navigateToUserOrders() {
    ref.read(orderProvider.notifier).getOrders();
    context.go(OrdersPage.path);
  }

  void navigateToProducerOrders() {
    context.go(ProducerOrdersPage.path);
  }

  Future<void> like() async {
    if (Appconfig().user != null && Appconfig().token != null) {
      await ref
          .read(productDetailsProvider.notifier)
          .likeProduct(slug: widget.slug);
    } else {
      showSnack(msg: context.local.login_required);
    }
  }

  Future<void> disLike() async {
    await ref
        .read(productDetailsProvider.notifier)
        .dislikeProduct(slug: widget.slug);
  }
}

class RatingBarEntryWidget extends ConsumerWidget {
  const RatingBarEntryWidget({
    super.key,
    required this.starRate,
    required this.percentage,
  });

  final String starRate;
  final int percentage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return ConstrainedBox(
      constraints: .loose(Size(0.75.sw, 10.h)),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        mainAxisSize: .max,
        spacing: 8.w,
        children: [
          SvgIcon(assetName: 'assets/icons/rate_start.svg'),
          Text(
            starRate.toNumber().toLocalNumber(local),
            style: theme.textTheme.bodySmall,
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              minHeight: 5.h,
              backgroundColor: AppColors.cardBorderColor,
              value: (percentage / 100),
              valueColor: AlwaysStoppedAnimation(AppColors.orangeColor),
              borderRadius: .circular(6.r),
            ),
          ),
          Text(
            '% ${percentage.toLocalNumber(local)}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class SalerCardWidget extends ConsumerWidget {
  const SalerCardWidget({super.key, required this.salerModel});

  final SalerModel salerModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .start,
      children: [
        Text(context.local.seller, style: theme.textTheme.bodyLarge),
        8.verticalSpace,
        Row(
          crossAxisAlignment: .start,
          children: [
            InkWell(
              onTap: () {
                context.push(
                  context.getRouterCurrentPath + OthersUserProfilePage.path,
                  extra: salerModel,
                );
              },
              child: Container(
                padding: .all(8.r),
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.containerFilledColor,
                ),
                clipBehavior: .antiAliasWithSaveLayer,
                child: CachedNetworkImageWidget(
                  image: salerModel.avatar ?? '',
                  fit: .cover,
                  errorWidgetSize: 24.h,
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 8.h,
                children: [
                  InkWell(
                    onTap: () {
                      context.push(
                        context.getRouterCurrentPath +
                            OthersUserProfilePage.path,
                        extra: salerModel,
                      );
                    },
                    child: Text(
                      salerModel.fullName ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.blackColor,
                      ),
                      overflow: .ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    salerModel.bio ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.black2,
                    ),
                    maxLines: 4,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductDetailsDescriptionWidget extends ConsumerWidget {
  const ProductDetailsDescriptionWidget({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Row(
      spacing: 4.w,
      children: [
        Container(
          height: 4.h,
          width: 4.h,
          decoration: BoxDecoration(color: Colors.black, shape: .circle),
        ),
        4.horizontalSpace,
        Text(
          title, //,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.black2),
        ),
        Text(
          description,

          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.black2),
        ),
      ],
    );
  }
}
