import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/core/constants/app_colors.dart';

class CircularProgressWidget extends ConsumerStatefulWidget {
  const CircularProgressWidget({super.key, this.progres, this.size = 16});

  final DownloadProgress? progres;
  final double size;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends ConsumerState<CircularProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: AppColors.cardBorderColor,
      end: AppColors.primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.progres == null) {
      return SizedBox(
        height: widget.size.h,
        width: widget.size.w,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 1.5,
          backgroundColor: Platform.isIOS ? AppColors.primaryColor : null,
          valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
        ),
      );
    } else {
      return SizedBox(
        height: widget.size.h,
        width: widget.size.w,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 1.5,
          value: ((widget.progres?.downloaded ?? 0) / 100).clamp(0.0, 1.0),
          backgroundColor: Platform.isIOS ? AppColors.primaryColor : null,
          valueColor: AlwaysStoppedAnimation<Color>(_colorAnimation.value!),
        ),
      );
    }
  }
}
