import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/configs/theme_data.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/presentation/pages/producer/text_editor_page.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/providers/general_apis_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/custom_dropdown_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/loading_widget.dart';

// ignore: must_be_immutable
class EditProductPageOne extends ConsumerStatefulWidget {
  EditProductPageOne({
    super.key,
    required this.pageOneFormKey,
    required this.specsControllerfa,
    required this.specsControllerps,
    required this.specsControlleren,
    required this.introControllerfa,
    required this.introControllerps,
    required this.introControllerEn,
    required this.productNamefa,
    required this.productNameps,
    required this.productNameen,
    required this.categoryController,
    required this.subCategoryController,
  });
  final GlobalKey<FormState> pageOneFormKey;

  late QuillController specsControllerfa;
  late QuillController specsControllerps;
  late QuillController specsControlleren;

  late QuillController introControllerfa;
  late QuillController introControllerps;
  late QuillController introControllerEn;

  late TextEditingController productNamefa;
  late TextEditingController productNameps;
  late TextEditingController productNameen;

  late TextEditingController categoryController;
  late TextEditingController subCategoryController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProductPageOneState();
}

class _EditProductPageOneState extends ConsumerState<EditProductPageOne>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(generalApisProvider.notifier).getCategories();
    });

    Future.microtask(() {
      ref.read(generalApisProvider.notifier).getProvince();
    });
    Future.microtask(() {
      ref.read(generalApisProvider.notifier).getUnites();
    });

    Future.microtask(() {
      ref.read(createProductProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen(generalApisProvider, (pre, next) {
      if (next.apiCallStatus == .complete && next.categories == null) {
        ref.read(generalApisProvider.notifier).getCategories();
      }
    });
    final categoryPorivder = ref.watch(generalApisProvider);

    final theme = ref.read(appThemeDataProvider);

    final createProductNotifier = ref.read(createProductProvider.notifier);

    ref.watch(createProductProvider);

    return LoadingWidget(
      isLoading: (categoryPorivder.apiCallStatus == .loading),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: widget.pageOneFormKey,
              child: Column(
                spacing: 16.h,
                children: [
                  16.verticalSpace,
                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.product_name_dari,
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
                        controller: widget.productNamefa,
                        validator: (value) {
                          String str = value ?? '';
                          if (str.length < 8) {
                            return context.local.product_name_dari_min_length;
                          } else if (str.length > 200) {
                            return context.local.name_max_length_error;
                          } else {
                            return null;
                          }
                        },

                        onSaved: (value) {
                          createProductNotifier.setNamefa(value ?? '');
                        },
                        maxLength: 200,
                        maxLines: 2,
                        decoration:
                            InputDecoration(
                              hintText: context.local.enter_product_name,
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

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.product_name_pashto,
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
                        controller: widget.productNameps,
                        validator: (value) {
                          String str = value ?? '';
                          if (str.length < 8) {
                            return context.local.product_name_pashto_min_length;
                          } else if (str.length > 200) {
                            return context.local.product_name_pashto_min_length;
                          } else {
                            return null;
                          }
                        },

                        onSaved: (value) {
                          createProductNotifier.setNameps(value ?? '');
                        },
                        maxLength: 200,
                        maxLines: 2,
                        decoration:
                            InputDecoration(
                              hintText: context.local.enter_product_name,
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
                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.product_name_english,
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
                        controller: widget.productNameen,
                        validator: (value) {
                          String str = value ?? '';
                          if (str.length < 8) {
                            return context
                                .local
                                .product_name_english_min_length;
                          } else if (str.length > 200) {
                            return context.local.product_name_max_length_error;
                          } else {
                            return null;
                          }
                        },

                        onSaved: (value) {
                          createProductNotifier.setNameen(value ?? '');
                        },
                        maxLength: 200,
                        maxLines: 2,
                        decoration:
                            InputDecoration(
                              hintText: context.local.enter_product_name,
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
                  Divider(color: AppColors.cardBorderColor, thickness: 3),

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.select_category,
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

                      CustomDropDownWidget<CategoryModel>(
                        hintText: context.local.select_category_hint,
                        items: (categoryPorivder.categories?.data ?? []).map((
                          item,
                        ) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChange: (val) {
                          widget.categoryController.text = val?.name ?? '';
                          createProductNotifier.setCategorySlug(null);
                          createProductNotifier.setCategorySlug(val);
                        },
                        controller: widget.categoryController,
                        validation: (value) {
                          if (value == null) {
                            return context.local.category_required;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.select_subcategory,
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
                      Consumer(
                        builder:
                            (
                              BuildContext context,
                              WidgetRef ref,
                              Widget? child,
                            ) {
                              final categories = ref
                                  .watch(createProductProvider)
                                  .categorySlug;

                              return CustomDropDownWidget<CategoryModel>(
                                hintText: context.local.select_category_hint,
                                items: (categories?.children ?? []).map((item) {
                                  return DropdownMenuItem<CategoryModel>(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),
                                onChange: (val) {
                                  if (val != null) {
                                    widget.subCategoryController.text =
                                        val.name;

                                    createProductNotifier.setSubCategorySlug(
                                      val,
                                    );
                                  }
                                },
                                controller: widget.subCategoryController,
                                validation: (value) {
                                  if (value == null) {
                                    return context.local.subcategory_required;
                                  }
                                  return null;
                                },
                              );
                            },
                      ),
                    ],
                  ),

                  Divider(color: AppColors.cardBorderColor, thickness: 3),

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.specifications_dari,
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

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final path =
                                context.getRouterCurrentPath +
                                TextEditorPage.path;
                            final result = await context.push<QuillController>(
                              path,
                              extra: [
                                context.local.specifications_dari,
                                widget.specsControllerfa,
                              ],
                            );

                            if (result != null) {
                              widget.specsControllerfa = result;

                              final String json = jsonEncode(
                                widget.specsControllerfa.document
                                    .toDelta()
                                    .toJson(),
                              );
                              // Stores the JSON Quill Delta
                              createProductNotifier.setDescriptionfa(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.specsControllerfa,
                              config: QuillEditorConfig(
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.specifications_pashto,
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

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final path =
                                context.getRouterCurrentPath +
                                TextEditorPage.path;
                            final result = await context.push<QuillController>(
                              path,
                              extra: [
                                context.local.specifications_pashto,
                                widget.specsControllerps,
                              ],
                            );

                            if (result != null) {
                              widget.specsControllerps = result;

                              final String json = jsonEncode(
                                widget.specsControllerps.document
                                    .toDelta()
                                    .toJson(),
                              );
                              // Stores the JSON Quill Delta
                              createProductNotifier.setDescriptionps(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.specsControllerps,
                              config: QuillEditorConfig(
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.specifications_english,
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

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final path =
                                context.getRouterCurrentPath +
                                TextEditorPage.path;
                            final result = await context.push<QuillController>(
                              path,
                              extra: [
                                context.local.specifications_english,
                                widget.specsControlleren,
                              ],
                            );

                            if (result != null) {
                              widget.specsControlleren = result;

                              final String json = jsonEncode(
                                widget.specsControlleren.document
                                    .toDelta()
                                    .toJson(),
                              );
                              // Stores the JSON Quill Delta
                              createProductNotifier.setDescriptionen(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.specsControlleren,
                              config: QuillEditorConfig(
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.cardBorderColor, thickness: 3),
                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.introduction_dari,
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final result = await context.push<QuillController>(
                              context.getRouterCurrentPath +
                                  TextEditorPage.path,
                              extra: [
                                context.local.introduction_dari,
                                widget.introControllerfa,
                              ],
                            );

                            if (result != null) {
                              widget.introControllerfa = result;

                              final String json = jsonEncode(
                                widget.introControllerfa.document
                                    .toDelta()
                                    .toJson(),
                              );
                              // Stores the JSON Quill Delta
                              createProductNotifier.setAboutfa(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.introControllerfa,
                              config: QuillEditorConfig(
                                // placeholder: ,
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.introduction_pashto,
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final result = await context.push<QuillController>(
                              context.getRouterCurrentPath +
                                  TextEditorPage.path,
                              extra: [
                                context.local.introduction_pashto,
                                widget.introControllerps,
                              ],
                            );

                            if (result != null) {
                              widget.introControllerps = result;

                              final String json = jsonEncode(
                                widget.introControllerps.document
                                    .toDelta()
                                    .toJson(),
                              );
                              // Stores the JSON Quill Delta
                              createProductNotifier.setAboutps(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.introControllerps,
                              config: QuillEditorConfig(
                                // placeholder: ,
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        spacing: 4.w,
                        children: [
                          Text(
                            context.local.introduction_english,
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(10.r),
                        ),
                        height: 100.h,
                        child: InkWell(
                          onTap: () async {
                            final result = await context.push<QuillController>(
                              context.getRouterCurrentPath +
                                  TextEditorPage.path,
                              extra: [
                                context.local.introduction_english,
                                widget.introControllerEn,
                              ],
                            );

                            if (result != null) {
                              widget.introControllerEn = result;

                              final String json = jsonEncode(
                                widget.introControllerEn.document
                                    .toDelta()
                                    .toJson(),
                              );
                              createProductNotifier.setAbouten(json);
                            }
                          },
                          child: AbsorbPointer(
                            child: QuillEditor.basic(
                              controller: widget.introControllerEn,
                              config: QuillEditorConfig(
                                padding: .all(10.r),
                                disableClipboard: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
