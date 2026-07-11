import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/app_providers/app_themedata_provider.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';
import 'package:palpa_marketplace/src/core/extensions/context_extension.dart';
import 'package:palpa_marketplace/src/core/utils/lunch_url.dart';
import 'package:palpa_marketplace/src/core/utils/svg_icon.dart';
import 'package:palpa_marketplace/src/data/models/saler_model.dart';
import 'package:palpa_marketplace/src/presentation/widgets/appbar_page_widget.dart';
import 'package:palpa_marketplace/src/presentation/widgets/catched_network_image_widget.dart';

class OthersUserProfilePage extends ConsumerStatefulWidget {
  static const String path = '/othersuserprofilepage';
  const OthersUserProfilePage({super.key, required this.salerModel});

  final SalerModel salerModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OthersUserProfilePageState();
}

class _OthersUserProfilePageState extends ConsumerState<OthersUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.read(appThemeDataProvider);
    return Scaffold(
      appBar: AppbarPageWidget(hideSearch: true, title: context.local.seller),

      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,
        children: [
          Center(
            child: Column(
              spacing: 8.h,
              children: [
                CircleAvatar(
                  radius: 44.r,
                  child: CachedNetworkImageWidget(
                    image: widget.salerModel.avatar,
                  ),
                ),

                8.verticalSpace,

                Text(
                  widget.salerModel.fullName ?? '',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          32.verticalSpace,

          Padding(
            padding: .symmetric(horizontal: 24.w),
            child: Column(
              spacing: 28.h,
              mainAxisAlignment: .start,
              children: [
                if (widget.salerModel.email != null)
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16.w,
                    children: [
                      SvgIcon(assetName: 'assets/icons/message.svg'),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            context.local.email,
                            style: theme.textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () => launchEmail(
                              widget.salerModel.email ?? 'palpa@asrepoya.com',
                            ),
                            child: Text(
                              widget.salerModel.email ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                if (widget.salerModel.phone != null)
                  Row(
                    crossAxisAlignment: .start,
                    spacing: 16.w,
                    children: [
                      SvgIcon(assetName: 'assets/icons/call.svg'),
                      Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            context.local.phone_number,
                            style: theme.textTheme.bodyLarge,
                          ),
                          InkWell(
                            onTap: () =>
                                launchDialer(widget.salerModel.phone ?? ''),
                            child: Text(
                              widget.salerModel.phone ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                // Row(
                //   crossAxisAlignment: .start,
                //   spacing: 16.w,
                //   children: [
                //     SvgIcon(
                //       assetName: 'assets/icons/location.svg',
                //       height: 15.h,
                //       width: 12.w,
                //     ),
                //     Column(
                //       mainAxisAlignment: .start,
                //       crossAxisAlignment: .start,
                //       children: [
                //         Text('آدرس', style: theme.textTheme.bodyLarge),
                //         Text(
                //          widget.salerModel.add
                //           style: theme.textTheme.bodyMedium?.copyWith(
                //             color: AppColors.primaryColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          16.verticalSpace,
          if (widget.salerModel.bio != null)
            Column(
              spacing: 8.h,
              crossAxisAlignment: .start,
              mainAxisAlignment: .start,
              children: [
                Text(context.local.about, style: theme.textTheme.bodyLarge),
                Row(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.salerModel.bio ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
