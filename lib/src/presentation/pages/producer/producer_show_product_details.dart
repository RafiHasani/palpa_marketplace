import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/saler_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/producer_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/show_producer_product_details_banner_widget.dart';

class ProducerShowProductDetails extends ConsumerStatefulWidget {
  static const String path = '/productdetails';
  const ProducerShowProductDetails({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProducerShowProductDetails();
}

class _ProducerShowProductDetails
    extends ConsumerState<ProducerShowProductDetails> {
  @override
  void initState() {
    Future.microtask(() async {
      await loadData();
    });

    super.initState();
  }

  Future<void> loadData() async {
    Future.microtask(() {
      ref
          .read(producerProductProvider.notifier)
          .getProducteDetailsData(slug: widget.slug);
    });
  }

  final QuillController showSpecsController = QuillController.basic();
  final QuillController showIntroController = QuillController.basic();

  @override
  void dispose() {
    showSpecsController.dispose();
    showIntroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(producerProductProvider);
    final productDetails = state.showMyProductBasicDetails;

    if (productDetails?.about != null) {
      final aboutDoc = Document.fromJson(productDetails?.about?['ops']);

      showSpecsController.document = aboutDoc;
    }

    if (productDetails?.description != null) {
      final descDoc = Document.fromJson(productDetails?.description?['ops']);
      showIntroController.document = descDoc;
    }

    final local = ref.read(appLangProvider);

    return DismissKeyboardWidget(
      child: LoadingWidget(
        isLoading: (state.producerApiStatus == .gettingMyProductBasicDetails),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppbarPageWidget(hideSearch: true),
          body: RefreshIndicator.adaptive(
            color: AppColors.primaryColor,
            onRefresh: () async {
              await loadData();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior: .onDrag,
              physics: ClampingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: .symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      ShowProducerProductDetailsBannerWidget(),
                      16.verticalSpace,
                      Row(
                        children: [
                          Text(
                            '${productDetails?.category.parent?.name} - ',

                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.subTitileTextColor,
                            ),
                            overflow: .ellipsis,
                          ),
                          Text(
                            productDetails?.category.name ?? '',

                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.subTitileTextColor,
                            ),
                            overflow: .ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            productDetails?.name ?? '',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Column(
                            crossAxisAlignment: .end,
                            children: [
                              if (productDetails?.hasDiscount ?? false)
                                Text(
                                  '${productDetails?.discountPrice?.toNumber().toLocalNumber(local)}  افغانی',
                                  maxLines: 1,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xFF8D99AE),
                                    decorationThickness: 0.5,
                                    color: Color(0xFF8D99AE),
                                  ),
                                ),
                              Text(
                                '${productDetails?.price.toNumber().toLocalNumber(local)} افغانی',
                                style: theme.textTheme.bodyLarge,
                                overflow: .ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
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
                                SvgIcon(
                                  assetName: 'assets/icons/rate_start.svg',
                                ),
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
                              ' ${productDetails?.reviewsCount?.toLocalNumber(local) ?? 0}  دیدگاه کاربران',
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
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        spacing: 8.h,
                        children: [
                          Text(
                            context.local.specifications,
                            style: theme.textTheme.bodyLarge,
                          ),
                          AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: showSpecsController,
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
                              controller: showIntroController,
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

                      56.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnack({String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }
}

class SalerCardWidget extends ConsumerWidget {
  const SalerCardWidget({super.key, required this.salerModel});

  final SalerModel salerModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    return Column(
      spacing: 8.h,
      crossAxisAlignment: .start,
      mainAxisAlignment: .start,
      children: [
        Text(context.local.seller, style: theme.textTheme.bodyLarge),
        8.verticalSpace,
        Row(
          crossAxisAlignment: .start,
          children: [
            Container(
              padding: .all(8.r),
              decoration: BoxDecoration(
                shape: .circle,
                color: AppColors.containerFilledColor,
              ),
              clipBehavior: .antiAliasWithSaveLayer,
              child: ClipRRect(
                borderRadius: .circular(56.r),
                child: CachedNetworkImageWidget(
                  image: salerModel.avatar ?? '',
                  fit: .cover,
                  errorWidgetSize: 24.h,
                  height: 44.h,
                  width: 44.w,
                ),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 8.h,
                children: [
                  Text(
                    salerModel.fullName ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12.sp),
                    overflow: .ellipsis,
                    maxLines: 1,
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
