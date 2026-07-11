import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/providers/create_product_provider.dart';
import 'package:palpa_marketplace/src/presentation/widgets/checkbox_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/create_product_details_banner_widget.dart';

class CreateProductPageThree extends ConsumerStatefulWidget {
  const CreateProductPageThree({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateProductPageThree();
}

class _CreateProductPageThree extends ConsumerState<CreateProductPageThree> {
  final QuillController specsControllerfa = QuillController.basic();
  final QuillController specsControllerps = QuillController.basic();
  final QuillController specsControlleren = QuillController.basic();

  final QuillController introControllerfa = QuillController.basic();
  final QuillController introControllerps = QuillController.basic();
  final QuillController introControlleren = QuillController.basic();

  bool acceptRuls = true;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);

    final createProductState = ref.watch(createProductProvider);
    final createProductNotifier = ref.read(createProductProvider.notifier);
    final images = ref.watch(createProductProvider).images ?? [];

    final local = ref.read(appLangProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          16.verticalSpace,
          CreateProductDetailsBannerWidget(
            images: images,
            inStock: createProductState.stock,
            unitModel: createProductState.unitSymbol,
            productName: getName(local, createProductState),
          ),

          16.verticalSpace,
          Row(
            children: [
              Text(
                '${createProductState.categorySlug?.name} -  ${createProductState.subCategorySlug?.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textFieldHint2Color,
                ),
              ),
            ],
          ),

          16.verticalSpace,
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                getName(local, createProductState),
                style: theme.textTheme.bodyLarge,
              ),

              Column(
                crossAxisAlignment: .end,
                children: [
                  if (createProductState.discountedPrice != null)
                    Text(
                      '${(createProductState.discountedPrice ?? 0).toLocalNumber(local)}  ${context.local.afghani}',
                      maxLines: 1,
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFF8D99AE),
                        decorationThickness: 0.5,
                        color: Color(0xFF8D99AE),
                      ),
                    ),
                  Text(
                    '${createProductState.price?.toLocalNumber(local)} ${context.local.afghani}',
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
            spacing: 8.w,
            children: [
              SvgIcon(assetName: 'assets/icons/location.svg'),
              Text(
                createProductState.provinceSlug?.name ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textFieldHint2Color,
                ),
              ),
            ],
          ),
          24.verticalSpace,
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.specifications_dari,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: specsControllerfa,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.specifications_pashto,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: specsControllerps,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.specifications_english,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: specsControlleren,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppColors.cardBorderColor, thickness: 3),
          24.verticalSpace,
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.introduction_dari,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: introControllerfa,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.introduction_pashto,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: introControllerps,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(Size(0.9.sw, 200.h)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.local.introduction_english,
                      style: theme.textTheme.bodyLarge,
                    ),
                    AbsorbPointer(
                      child: SizedBox(
                        height: 160.h,
                        width: 0.9.sw,
                        child: QuillEditor.basic(
                          controller: introControlleren,
                          config: QuillEditorConfig(
                            padding: .all(10.r),
                            disableClipboard: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: .start,
            children: [
              CustomCheckBoxWidget(
                intialValue: createProductState.isActive,
                state: (value) {
                  createProductNotifier.setActive(value);
                },
              ),

              Text(
                context.local.active,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.black2,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: .start,
            children: [
              CustomCheckBoxWidget(
                intialValue: true,
                state: (bool isChecked) {},
              ),

              Text(
                context.local.accept_terms,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.black2,
                ),
              ),
            ],
          ),
          32.verticalSpace,
        ],
      ),
    );
  }

  String getName(Locale local, CreateProductState createProductState) {
    switch (local.languageCode) {
      case 'en':
        return createProductState.nameen ?? '';
      case 'fa':
        return createProductState.namefa ?? '';
      case 'ps':
        return createProductState.nameps ?? '';
      default:
        return createProductState.namefa ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    final state = ref.watch(createProductProvider);
    specsControllerfa.document = Document.fromJson(
      jsonDecode(state.aboutfa ?? ''),
    );
    specsControllerps.document = Document.fromJson(
      jsonDecode(state.aboutps ?? ''),
    );
    specsControlleren.document = Document.fromJson(
      jsonDecode(state.abouten ?? ''),
    );

    introControllerfa.document = Document.fromJson(
      jsonDecode(state.descriptionfa ?? ''),
    );

    introControllerps.document = Document.fromJson(
      jsonDecode(state.descriptionps ?? ''),
    );
    introControlleren.document = Document.fromJson(
      jsonDecode(state.descriptionen ?? ''),
    );
    super.didChangeDependencies();
  }
}
