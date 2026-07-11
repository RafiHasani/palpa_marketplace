import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/constants/enums.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/image_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/doted_border_widget.dart';

class ImageSelectedCardWidget extends StatelessWidget {
  const ImageSelectedCardWidget({
    super.key,
    required this.onDelete,
    required this.imageModel,
    required this.isFeatured,
    required this.onStarClicked,
  });

  final Function() onDelete;
  final Function() onStarClicked;
  final ImageModel imageModel;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          Stack(
            clipBehavior: .none,
            children: [
              Container(
                width: 100.w,
                height: 90.h,
                decoration: BoxDecoration(borderRadius: .circular(10.r)),
                clipBehavior: .antiAliasWithSaveLayer,
                child: imageModel.uuid == ImageState.added.label
                    ? Image.file(File(imageModel.path!), fit: .fill)
                    : CachedNetworkImageWidget(image: imageModel.path),
              ),

              SizedBox(
                width: 100.w,
                height: 90.h,
                child: CustomPaint(
                  painter: DottedBorderPainter(
                    color: AppColors.cardBorderColor,
                    dashWidth: 8.h,
                    strokeWidth: 2.w,
                  ),
                ),
              ),

              PositionedDirectional(
                top: -8,
                end: -8,
                child: InkWell(
                  onTap: () {
                    onDelete();
                  },
                  child: Container(
                    clipBehavior: .none,
                    padding: .all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: .circular(56.r),
                      border: .all(color: AppColors.cardBorderColor),
                    ),
                    child: SvgIcon(assetName: 'assets/icons/delete.svg'),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onStarClicked,
            icon: SvgIcon(
              assetName: isFeatured
                  ? 'assets/icons/rate_start_filled.svg'
                  : 'assets/icons/star_orange.svg',
            ),
          ),
        ],
      ),
    );
  }
}
