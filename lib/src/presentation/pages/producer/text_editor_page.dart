import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';

class TextEditorPage extends ConsumerStatefulWidget {
  static const String path = '/texteditorpage';
  final String title;

  final QuillController quillController;

  const TextEditorPage({
    super.key,
    required this.title,
    required this.quillController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextEditorPage();
}

class _TextEditorPage extends ConsumerState<TextEditorPage> {
  late final FocusNode focusNode;
  late final ScrollController scrollController;
  ValueNotifier isValid = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
        } else {
          if (isValid.value) {
            context.pop(widget.quillController);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppbarPageWidget(
          title: widget.title,
          hideSearch: true,
          onPop: () {
            checkValidation();
            if (isValid.value) {
              context.pop(widget.quillController);
            }
          },
        ),
        body: SafeArea(
          child: Container(
            padding: .all(8.r),
            margin: .all(16.r),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: .circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ValueListenableBuilder(
                  valueListenable: isValid,
                  builder: (context, value, child) {
                    return !value
                        ? Column(
                            mainAxisSize: .min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.red2,
                                ),
                                child: Padding(
                                  padding: .symmetric(horizontal: 24.w),
                                  child: Text(
                                    context.local.max_200_words_allowed,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink();
                  },
                ),
                16.verticalSpace,
                SizedBox(
                  height: 32.h,
                  width: 0.9.sw,
                  child: QuillSimpleToolbar(
                    controller: widget.quillController,
                    config: QuillSimpleToolbarConfig(
                      buttonOptions: QuillSimpleToolbarButtonOptions(
                        base: QuillToolbarBaseButtonOptions(
                          iconSize: 12.r,
                          iconTheme: QuillIconTheme(
                            iconButtonSelectedData: IconButtonData(
                              style: IconButton.styleFrom(
                                shape: CircleBorder(eccentricity: 0.3),
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                              ),
                            ),
                            iconButtonUnselectedData: IconButtonData(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(),
                      color: AppColors.whiteColor,
                      showBackgroundColorButton: false,
                      multiRowsDisplay: false,
                      showFontFamily: false,
                      showFontSize: false,
                      showUndo: false,
                      showRedo: false,
                      showClearFormat: false,
                      showSearchButton: false,
                      showQuote: false,
                      showCodeBlock: false,
                      showCenterAlignment: false,
                      showDividers: false,
                      showHeaderStyle: false,
                      showInlineCode: false,
                      showListCheck: false,
                      showLineHeightButton: false,
                      showSmallButton: false,
                      showSubscript: false,
                      showStrikeThrough: false,
                      showSuperscript: false,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: .symmetric(horizontal: 16.w),
                    child: QuillEditor.basic(
                      controller: widget.quillController,
                      config: QuillEditorConfig(
                        showCursor: true,
                        scrollable: true,
                        autoFocus: false,
                        expands: false,
                        enableInteractiveSelection: true,
                        enableSelectionToolbar: false,
                        placeholder: widget.title,
                      ),
                      focusNode: focusNode,
                      scrollController: scrollController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void checkValidation() {
    final text = widget.quillController.document.toPlainText().trim();
    final count = countWordsRegex(text);
    isValid.value = count >= 1 && count <= 200;
  }

  int countWordsRegex(String text) {
    final regExp = RegExp(r'\b\w+\b');
    int count = regExp.allMatches(text).length;
    return count;
  }
}
