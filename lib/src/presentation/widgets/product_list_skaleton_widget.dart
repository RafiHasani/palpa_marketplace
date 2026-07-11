import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class ProductListSkaletonWidget extends StatefulWidget {
  final bool error;
  final Function() refresh;

  const ProductListSkaletonWidget({
    super.key,
    this.error = false,
    required this.refresh,
  });
  @override
  State<StatefulWidget> createState() => _ProductListSkaletonWidgetState();
}

class _ProductListSkaletonWidgetState extends State<ProductListSkaletonWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Padding(
            padding: .symmetric(horizontal: 16.w),
            child: GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 0.60.r,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: .all(color: AppColors.cardBorderColor),
                    borderRadius: .circular(10.r),
                  ),
                  child: Column(
                    spacing: 8.h,
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.containerFilledColor,
                          borderRadius: .circular(10.r),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 8.h,
                          children: [
                            Container(
                              height: 8.h,
                              width: 0.3.sw,
                              decoration: BoxDecoration(
                                color: AppColors.containerFilledColor,
                                borderRadius: .circular(10.r),
                              ),
                            ),
                            Container(
                              height: 8.h,
                              width: 0.4.sw,
                              decoration: BoxDecoration(
                                color: AppColors.containerFilledColor,
                                borderRadius: .circular(10.r),
                              ),
                            ),
                            Container(
                              height: 8.h,
                              width: 0.3.sw,
                              decoration: BoxDecoration(
                                color: AppColors.containerFilledColor,
                                borderRadius: .circular(10.r),
                              ),
                            ),
                            16.verticalSpace,
                            Row(
                              mainAxisAlignment: .end,
                              children: [
                                Container(
                                  height: 8.h,
                                  width: 0.2.sw,
                                  decoration: BoxDecoration(
                                    color: AppColors.containerFilledColor,
                                    borderRadius: .circular(10.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
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
