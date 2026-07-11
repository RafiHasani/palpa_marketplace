import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_language_provider.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/extensions/number_extensions.dart';
import 'package:palpa_marketplace/src/data/models/category_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/get_open_arrow_local_method.dart';
import 'package:palpa_marketplace/src/presentation/widgets/heading_row_widget.dart';

class CategorySectionWidget extends ConsumerStatefulWidget {
  const CategorySectionWidget({
    super.key,
    required this.categoryModel,
    required this.onItemClicked,
    required this.seeAll,
  });
  final CategoryModel categoryModel;

  final Function() onItemClicked;
  final Function(CategoryModel categoryModel) seeAll;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategorySectionWidget();
}

class _CategorySectionWidget extends ConsumerState<CategorySectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = ref.read(appLangProvider);
    final children = widget.categoryModel.children ?? [];
    return Column(
      children: [
        HeadingRowWidget(
          title: widget.categoryModel.name,
          actionButtonTitle: context.local.all,
          isActionAable: true,
          actionTextIconButton: () {
            widget.seeAll(widget.categoryModel);
          },
          icon: getOpenArrowIcon(local),
          iconAlignment: .end,
        ),

        SizedBox(
          height: 120.h,
          child: ListView.builder(
            itemCount: children.length,
            padding: .directional(end: 16.w),
            scrollDirection: .horizontal,
            itemBuilder: (context, index) {
              final item = children[index];
              return CategoryCardWidget(
                key: Key(item.slug),
                categoryModel: item,
                onClick: () => widget.onItemClicked(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryCardWidget extends ConsumerWidget {
  const CategoryCardWidget({
    super.key,
    required this.categoryModel,
    required this.onClick,
  });
  final CategoryModel categoryModel;

  final Function() onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeDataProvider);
    final local = ref.read(appLangProvider);
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 90.h,
        width: 80.w,
        margin: .directional(start: 16.w),
        decoration: BoxDecoration(
          borderRadius: .circular(10.r),
          color: Colors.white,
          border: .all(width: 0.7, color: AppColors.cardBorderColor),
        ),
        clipBehavior: .antiAlias,
        child: Padding(
          padding: .symmetric(vertical: 8.h, horizontal: 4.w),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            spacing: 8.h,
            children: [
              SizedBox(
                height: 22.h,
                width: 30.w,
                child: CachedNetworkImageWidget(
                  image: categoryModel.icon,
                  fit: .cover,
                  errorWidgetSize: 32.r,
                ),
              ),

              Column(
                spacing: 4.h,
                children: [
                  Text(
                    textAlign: .center,
                    categoryModel.name,
                    maxLines: 2,
                    overflow: .clip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    '${categoryModel.productsCount.toLocalNumber(local)} ${context.local.type}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textFieldHintColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
