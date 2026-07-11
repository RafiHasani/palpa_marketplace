import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/string_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/province_model.dart';
import 'package:palpa_marketplace/src/data/models/unit_model.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/general_apis_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/dismiss_keyboard_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/doted_border_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/image_selected_card_widget.dart';

// ignore: must_be_immutable
class EditProductPageTwo extends ConsumerStatefulWidget {
  late GlobalKey<FormState> formKey;
  late TextEditingController priceController;
  late TextEditingController inStockController;
  late TextEditingController discountController;

  EditProductPageTwo({
    super.key,
    required this.formKey,
    required this.priceController,
    required this.inStockController,
    required this.discountController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProductPageTwoState();
}

class _EditProductPageTwoState extends ConsumerState<EditProductPageTwo>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen(generalApisProvider, (pre, next) {
      if (next.apiCallStatus == .complete && next.unites == null) {
        ref.read(generalApisProvider.notifier).getUnites();
      }
    });
    final generalApiState = ref.watch(generalApisProvider);

    final unites = generalApiState.unites ?? [];

    final createProductNotifier = ref.read(createProductProvider.notifier);
    final createProductState = ref.watch(createProductProvider);

    final selectedImages = createProductState.images ?? [];

    final province = ref.watch(generalApisProvider).province ?? [];

    final theme = ref.read(appThemeDataProvider);

    return DismissKeyboardWidget(
      child: SingleChildScrollView(
        child: Column(
          spacing: 16.h,
          children: [
            16.verticalSpace,
            Form(
              key: widget.formKey,
              child: Column(
                spacing: 8.h,
                children: [
                  Row(
                    spacing: 4.w,
                    children: [
                      Text(
                        context.local.product_image,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  CustomPaint(
                    painter: DottedBorderPainter(
                      color: AppColors.cardBorderColor,
                      dashWidth: 4.h,
                      strokeWidth: 2,
                    ),
                    child: Container(
                      height: 100.h,
                      width: 2.sw,
                      margin: .all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: .circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            context.local.upload_product_images_hint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.subTitileTextColor,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              createProductNotifier.pickImages();
                            },
                            label: Text(
                              context.local.upload_product_image,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            icon: SvgIcon(assetName: 'assets/icons/upload.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (selectedImages.isNotEmpty)
                    SizedBox(
                      height: 170.h,
                      child: ListView.builder(
                        scrollDirection: .horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          final item = selectedImages[index];
                          return item.uuid != ImageState.deleted.label
                              ? ImageSelectedCardWidget(
                                  imageModel: item,
                                  onDelete: () {
                                    createProductNotifier.deleteImage(index);
                                  },
                                  isFeatured: item.isFeatured,
                                  onStarClicked: () {
                                    final images = List.generate(
                                      selectedImages.length,
                                      (i) => selectedImages[i].copyWith(
                                        isFeatured: i == index,
                                      ),
                                    );
                                    createProductNotifier.setImages(images);
                                  },
                                )
                              : SizedBox.shrink();
                        },
                      ),
                    ),

                  // Column(
                  //   children: [
                  //     Row(
                  //       spacing: 4.w,
                  //       children: [
                  //         Text('آدرس', style: theme.textTheme.bodyMedium),
                  //         Text(
                  //           '*',
                  //           style: theme.textTheme.bodyMedium?.copyWith(
                  //             color: Colors.redAccent,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     8.verticalSpace,
                  //     TextFormField(
                  //       controller: addressController,
                  //       validator: (value) {
                  //         String str = value ?? '';
                  //         if (str.length < 20) {
                  //           return 'product address must be greater than 20 characters';
                  //         } else if (str.length > 50) {
                  //           return 'address must be less than 100 characters';
                  //         } else {
                  //           return null;
                  //         }
                  //       },
                  //       onSaved: (newValue) {
                  //         if(newValue !=null){
                  //           createProductNotifier.setAbout(about)
                  //         }
                  //       },
                  //       decoration:
                  //           InputDecoration(
                  //             hintText: 'ادرس محصول را وارد کنید',
                  //           ).copyWith(
                  //             focusedBorder: AppTheme
                  //                 .inputTextFeildThemeLightRadiu10
                  //                 .focusedBorder,
                  //             errorBorder: AppTheme
                  //                 .inputTextFeildThemeLightRadiu10
                  //                 .errorBorder,
                  //             border:
                  //                 AppTheme.inputTextFeildThemeLightRadiu10.border,
                  //             focusedErrorBorder: AppTheme
                  //                 .inputTextFeildThemeLightRadiu10
                  //                 .focusedErrorBorder,
                  //             enabledBorder: AppTheme
                  //                 .inputTextFeildThemeLightRadiu10
                  //                 .enabledBorder,
                  //           ),
                  //     ),
                  //   ],
                  // ),
                  if (province.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          spacing: 4.w,
                          children: [
                            Text(
                              context.local.province,
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '*',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        DropdownButtonFormField<ProvinceModel>(
                          decoration:
                              InputDecoration(
                                suffixIcon: SizedBox(
                                  height: 14.h,
                                  width: 14.w,
                                  child: SvgIcon(
                                    assetName:
                                        'assets/icons/open_arrow_down.svg',
                                    fit: .scaleDown,
                                  ),
                                ),
                                hintText: context.local.province,
                                hintStyle: theme.textTheme.bodyMedium,
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
                          initialValue: createProductState.provinceSlug,
                          validator: (value) {
                            if (value == null) {
                              return context.local.province_required;
                            }
                            return null;
                          },

                          items: province.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              createProductNotifier.setProvinceSlug(value);
                            }
                          },
                        ),
                      ],
                    ),

                  Row(
                    spacing: 8.w,
                    children: [
                      // Expanded(
                      //   flex: 3,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         spacing: 4.w,
                      //         children: [
                      //           Text(
                      //             'واحد پول',
                      //             style: theme.textTheme.bodyMedium,
                      //           ),
                      //           Text(
                      //             '*',
                      //             style: theme.textTheme.bodyMedium?.copyWith(
                      //               color: Colors.redAccent,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       8.verticalSpace,

                      //       DropdownButtonFormField<String>(
                      //         decoration:
                      //             InputDecoration(
                      //               suffixIcon: SizedBox(
                      //                 height: 14.h,
                      //                 width: 14.w,
                      //                 child: SvgIcon(
                      //                   assetName:
                      //                       'assets/icons/open_arrow_down.svg',
                      //                   fit: .scaleDown,
                      //                 ),
                      //               ),
                      //               hintText: 'افغانی',
                      //               hintStyle: theme.textTheme.bodyMedium,
                      //             ).copyWith(
                      //               focusedBorder: AppTheme
                      //                   .inputTextFeildThemeLightRadiu10
                      //                   .focusedBorder,
                      //               errorBorder: AppTheme
                      //                   .inputTextFeildThemeLightRadiu10
                      //                   .errorBorder,
                      //               border: AppTheme
                      //                   .inputTextFeildThemeLightRadiu10
                      //                   .border,
                      //               focusedErrorBorder: AppTheme
                      //                   .inputTextFeildThemeLightRadiu10
                      //                   .focusedErrorBorder,
                      //               enabledBorder: AppTheme
                      //                   .inputTextFeildThemeLightRadiu10
                      //                   .enabledBorder,
                      //             ),

                      //         items: ['افغانی', '\$'].map((item) {
                      //           return DropdownMenuItem(
                      //             value: item,
                      //             child: Text(item),
                      //           );
                      //         }).toList(),
                      //         onChanged: (value) {},
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Row(
                              spacing: 4.w,
                              children: [
                                Text(
                                  context.local.price,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  '*',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            8.verticalSpace,
                            TextFormField(
                              controller: widget.priceController,
                              validator: (value) {
                                String str = value ?? '';
                                if (str.isEmpty) {
                                  return context.local.price_required;
                                }
                                return null;
                              },
                              maxLength: 9,
                              keyboardType: .number,
                              decoration:
                                  InputDecoration(
                                    hintText: context.local.price_hint,
                                    counterText: '',
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
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  final price = newValue.parseToEnglish();
                                  createProductNotifier.setPrice(price);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (unites.isNotEmpty)
                    Row(
                      spacing: 8.w,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Row(
                                spacing: 4.w,
                                children: [
                                  Text(
                                    context.local.unit,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '*',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              8.verticalSpace,

                              DropdownButtonFormField<UnitModel>(
                                initialValue: createProductState.unitSymbol,
                                decoration:
                                    InputDecoration(
                                      suffixIcon: SizedBox(
                                        height: 14.h,
                                        width: 14.w,
                                        child: SvgIcon(
                                          assetName:
                                              'assets/icons/open_arrow_down.svg',
                                          fit: .scaleDown,
                                        ),
                                      ),
                                      hintText: context.local.kilogram,
                                      hintStyle: theme.textTheme.bodyMedium,
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

                                validator: (value) {
                                  if (value == null) {
                                    return context.local.unit_required;
                                  }
                                  return null;
                                },

                                items: unites.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    createProductNotifier.setUnitSymbol(
                                      newValue,
                                    );
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null) {
                                    createProductNotifier.setUnitSymbol(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Row(
                                spacing: 4.w,
                                children: [
                                  Text(
                                    context.local.in_stock,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '*',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              8.verticalSpace,
                              TextFormField(
                                controller: widget.inStockController,
                                keyboardType: .number,
                                validator: (value) {
                                  String str = value ?? '';
                                  if (str.isEmpty) {
                                    return context.local.in_stock_required;
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    final val = newValue.parseToEnglish();
                                    createProductNotifier.setStock(val);
                                  }
                                },
                                maxLength: 9,
                                decoration:
                                    InputDecoration(
                                      hintText: context.local.in_stock_hint,
                                      counterText: '',
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
                            ],
                          ),
                        ),
                      ],
                    ),

                  Column(
                    spacing: 8.h,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        context.local.discount,
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextFormField(
                        controller: widget.discountController,
                        keyboardType: .number,
                        onSaved: (newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            final val = newValue.parseToEnglish();
                            createProductNotifier.setDiscountedPrice(val);
                          }
                        },
                        maxLength: 9,
                        decoration:
                            InputDecoration(
                              hintText: context.local.discount,
                              counterText: '',
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
                    ],
                  ),
                ],
              ),
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
