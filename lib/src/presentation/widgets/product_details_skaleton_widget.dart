// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';

class ProductDetailsSkaletonWidget extends StatefulWidget {
  final bool error;
  final Function() refresh;

  const ProductDetailsSkaletonWidget({
    super.key,
    this.error = false,
    required this.refresh,
  });
  @override
  State<StatefulWidget> createState() => _ProductDetailsSkaletonWidgetState();
}

class _ProductDetailsSkaletonWidgetState
    extends State<ProductDetailsSkaletonWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Padding(
            padding: .symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 0.2.sh,
                  decoration: BoxDecoration(
                    color: AppColors.containerFilledColor,
                    borderRadius: .circular(10.r),
                  ),
                ),
              ],
            ),
          ),

          PositionedDirectional(
            top: 0.18.sh,
            start: 32.w,
            child: Container(
              height: 12.h,
              width: 0.4.sw,
              decoration: BoxDecoration(
                color: AppColors.iconColor,
                borderRadius: .circular(10.r),
              ),
            ),
          ),

          PositionedDirectional(
            top: 0.18.sh,
            end: 32.w,
            child: Row(
              spacing: 2.w,
              children: [
                Container(
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.iconColor,
                    borderRadius: .circular(4.r),
                  ),
                ),
                Container(
                  height: 8.h,
                  width: 16.h,
                  decoration: BoxDecoration(
                    color: AppColors.iconColor,
                    borderRadius: .circular(4.r),
                  ),
                ),
                Container(
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.iconColor,
                    borderRadius: .circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0.25.sh,
            width: 1.sw,
            child: Padding(
              padding: .symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceAround,
                    mainAxisSize: .max,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 8.h,
                            width: 0.3.sw,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        spacing: 16.w,
                        children: [
                          Container(
                            height: 16.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                          Container(
                            height: 16.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Container(
                        height: 8.h,
                        width: 0.3.sw,
                        decoration: BoxDecoration(
                          color: AppColors.iconColor,
                          borderRadius: .circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  Row(
                    children: [
                      Row(
                        spacing: 16.w,
                        children: [
                          SvgIcon(
                            assetName: 'assets/icons/star_empty_icon.svg',
                            size: 8.r,
                          ),
                          Container(
                            height: 8.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                          Container(
                            height: 8.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      16.horizontalSpace,

                      Row(
                        spacing: 8.w,
                        children: [
                          Container(
                            height: 8.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                          Container(
                            height: 8.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),

                      16.horizontalSpace,

                      Row(
                        spacing: 8.w,
                        children: [
                          SvgIcon(assetName: 'assets/icons/location.svg'),
                          Container(
                            height: 8.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  24.verticalSpace,

                  Row(
                    children: [
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
                  16.verticalSpace,

                  Row(
                    children: [
                      Container(
                        height: 8.h,
                        width: 0.6.sw,
                        decoration: BoxDecoration(
                          color: AppColors.iconColor,
                          borderRadius: .circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  Row(
                    children: [
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
                  16.verticalSpace,

                  Row(
                    children: [
                      Container(
                        height: 8.h,
                        width: 0.6.sw,
                        decoration: BoxDecoration(
                          color: AppColors.iconColor,
                          borderRadius: .circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  Row(
                    spacing: 16.w,
                    children: [
                      Container(
                        height: 56.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                          color: AppColors.iconColor,
                          borderRadius: .circular(56.r),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8.h,
                        children: [
                          Container(
                            height: 8.h,
                            width: 0.2.sw,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                          Container(
                            height: 8.h,
                            width: 0.7.sw,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  32.verticalSpace,

                  Container(
                    height: 56.h,
                    width: 0.6.sw,
                    decoration: BoxDecoration(
                      color: AppColors.iconColor,
                      borderRadius: .circular(4.r),
                    ),
                  ),
                  32.verticalSpace,
                  Row(
                    children: [
                      Container(
                        height: 8.h,
                        width: 0.2.sw,
                        decoration: BoxDecoration(
                          color: AppColors.iconColor,
                          borderRadius: .circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  32.verticalSpace,
                  Row(
                    spacing: 24.w,
                    children: [
                      Column(
                        spacing: 8.h,
                        children: [
                          Container(
                            height: 8.h,
                            width: 0.1.sw,
                            decoration: BoxDecoration(
                              color: AppColors.iconColor,
                              borderRadius: .circular(4.r),
                            ),
                          ),
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

                      Column(
                        spacing: 16.h,
                        mainAxisAlignment: .start,
                        children: [
                          Row(
                            spacing: 16.w,
                            children: [
                              SvgIcon(
                                assetName: 'assets/icons/star_empty_icon.svg',
                                size: 10.r,
                              ),
                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                              Container(
                                height: 4.h,
                                width: 0.5.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),

                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.w,
                            children: [
                              SvgIcon(
                                assetName: 'assets/icons/star_empty_icon.svg',
                                size: 10.r,
                              ),
                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                              Container(
                                height: 4.h,
                                width: 0.5.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),

                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.w,
                            children: [
                              SvgIcon(
                                assetName: 'assets/icons/star_empty_icon.svg',
                                size: 10.r,
                              ),
                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                              Container(
                                height: 4.h,
                                width: 0.5.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),

                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16.w,
                            children: [
                              SvgIcon(
                                assetName: 'assets/icons/star_empty_icon.svg',
                                size: 10.r,
                              ),
                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                              Container(
                                height: 4.h,
                                width: 0.5.sw,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),

                              Container(
                                height: 8.h,
                                width: 16.w,
                                decoration: BoxDecoration(
                                  color: AppColors.iconColor,
                                  borderRadius: .circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          widget.error
              ? Center(
                  child: Container(
                    height: 56,
                    width: 56,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(56),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(56),
                      onTap: () {
                        widget.refresh();
                      },
                      child: Icon(Icons.refresh_rounded),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
