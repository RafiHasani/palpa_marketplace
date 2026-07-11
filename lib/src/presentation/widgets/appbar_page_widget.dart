import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';

class AppbarPageWidget extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const AppbarPageWidget({
    super.key,
    this.hideSearch = false,
    this.title,
    this.titleOnly = false,
    this.onSubmitted,
    this.controller,
    this.onPop,
    this.hideBackButton,
    this.onSearchClicked,
    this.isEnable = true,
    this.searchFillColor,
  });

  final bool hideSearch;
  final String? title;
  final bool titleOnly;
  final Function(String? search)? onSubmitted;
  final TextEditingController? controller;
  final Function()? onPop;
  final bool? hideBackButton;

  final Function()? onSearchClicked;
  final bool isEnable;
  final Color? searchFillColor;

  @override
  ConsumerState<AppbarPageWidget> createState() => _AppbarPageWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppbarPageWidgetState extends ConsumerState<AppbarPageWidget> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (showClear != hasText) {
      setState(() => showClear = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = ref.read(appLangProvider);
    final theme = ref.read(appThemeDataProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 65.h, 8.w, 8.h),
      child: Row(
        children: [
          if (!widget.titleOnly) ...[
            IconButton(
              onPressed: () {
                if (widget.onPop != null) {
                  widget.onPop?.call();
                } else {
                  context.pop();
                }
              },
              icon: getArrowIcon(local),
            ),
          ],

          if (widget.title != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 8.w),
              child: Text(widget.title!, style: theme.textTheme.bodyLarge),
            ),

          if (!widget.hideSearch)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (widget.onSearchClicked != null) {
                    widget.onSearchClicked!();
                  }
                },
                child: TextField(
                  enabled: widget.isEnable,
                  controller: widget.controller,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    fillColor:
                        widget.searchFillColor ??
                        AppColors.containerFilledColor,
                    suffixIcon: showClear
                        ? IconButton(
                            color: AppColors.red,
                            icon: Container(
                              decoration: BoxDecoration(
                                border: .all(width: 0.5, color: AppColors.red),
                                borderRadius: .circular(56.r),
                              ),
                              child: Icon(Icons.close_rounded, size: 18.r),
                            ),
                            onPressed: () {
                              widget.controller?.clear();
                            },
                          )
                        : null,
                    prefixIcon: SvgIcon(
                      assetName: 'assets/icons/search.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    hintText: context.local.search_items,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
