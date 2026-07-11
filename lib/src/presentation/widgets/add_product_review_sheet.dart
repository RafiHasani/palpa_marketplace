import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/order_response_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_elevated_button.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

class AddProductReviewSheet extends ConsumerStatefulWidget {
  const AddProductReviewSheet({super.key, this.orderModel});

  final OrderModel? orderModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProductReviewSheet();
}

class _AddProductReviewSheet extends ConsumerState<AddProductReviewSheet> {
  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int rate = 0;
  String error = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(productPageProvider.notifier);
    final theme = ref.read(appThemeDataProvider);
    final state = ref.watch(productPageProvider);

    ref.listen(productPageProvider, (pre, next) {
      if (next.apiCallStatus == .addingProductReviewSuccess) {
        if (context.canPop()) context.pop();
        provider.getMyProductReviews();
      }
      if (next.apiCallStatus == .addingProductReviewFaild) {
        showSnack(context, msg: next.errorMessage?.error);
      }
    });

    return LoadingWidget(
      isLoading: state.apiCallStatus == .addingProductReview,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.local.submit_rating_and_review,
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      spacing: 8.w,
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColors.whiteColor,
                          ),
                          child: CachedNetworkImageWidget(
                            image: widget
                                .orderModel
                                ?.product
                                .thumbnails
                                ?.first
                                .path,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.orderModel?.product.name ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.black2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    EditRatingBarWidget(
                      editRating: rate,
                      getRate: (int rate) {
                        setState(() {
                          this.rate = rate;
                        });
                      },
                    ),
                    if (error.isNotEmpty)
                      Text(
                        error,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.red,
                        ),
                      ),

                    SizedBox(height: 24.h),
                    Text(
                      context.local.review_text_hint,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8.h),

                    Form(
                      key: formKey,
                      child: Container(
                        width: 0.9.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.cardBorderColor),
                        ),
                        child: TextFormField(
                          controller: controller,
                          maxLines: 4,
                          maxLength: 1000,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.local.comment_required;
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(
                                counterText: '',
                                hintText: context.local.share_comment_hint,
                              ).copyWith(
                                focusedBorder: AppTheme
                                    .inputTextFeildThemeLightRadiu10
                                    .focusedBorder,
                                errorBorder: AppTheme
                                    .inputTextFeildThemeLightRadiu10
                                    .errorBorder,
                                border: AppTheme
                                    .inputTextFeildThemeLightRadiu10
                                    .border,
                                focusedErrorBorder: AppTheme
                                    .inputTextFeildThemeLightRadiu10
                                    .focusedErrorBorder,
                                enabledBorder: AppTheme
                                    .inputTextFeildThemeLightRadiu10
                                    .enabledBorder,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 0.9.sw,
                      child: CustomElevatedButton(
                        title: context.local.submit_review,
                        onPressed: () {
                          if (rate == 0) {
                            setState(
                              () => error = context.local.star_rating_required,
                            );
                            return;
                          }
                          if (formKey.currentState?.validate() ?? false) {
                            provider.addReviewProduct(
                              slug: widget.orderModel?.product.slug ?? '',
                              qeury: {
                                "rating": rate,
                                "comment": controller.text.trim(),
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnack(BuildContext context, {String? msg}) {
    context.showMySnackBar(content: msg ?? context.local.somethingwentwrong);
  }
}

class EditRatingBarWidget extends ConsumerStatefulWidget {
  const EditRatingBarWidget({
    super.key,
    required this.getRate,
    this.editRating,
  });
  final Function(int rate) getRate;
  final int? editRating;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRatingBarWidget();
}

class _EditRatingBarWidget extends ConsumerState<EditRatingBarWidget> {
  int rate = 0;
  @override
  void initState() {
    super.initState();
    rate = widget.editRating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: ListView.builder(
        scrollDirection: .horizontal,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (c, index) {
          if (rate <= index) {
            return GestureDetector(
              onTap: () {
                rate = index + 1;
                widget.getRate(rate);
                setState(() {});
              },
              child: Padding(
                padding: .symmetric(horizontal: 4.w),
                child: SvgIcon(assetName: 'assets/icons/star_empty_icon.svg'),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                rate = index + 1;
                widget.getRate(rate);
                setState(() {});
              },
              child: Padding(
                padding: .symmetric(horizontal: 4.w),
                child: SvgIcon(assetName: 'assets/icons/rate_start_filled.svg'),
              ),
            );
          }
        },
      ),
    );
  }
}
