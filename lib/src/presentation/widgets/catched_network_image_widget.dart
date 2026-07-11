import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palpa_marketplace/src/presentation/widgets/circular_progress_widget.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.errorWidgetSize = 56,
    this.height,
    this.width,
    this.placeholder,
  });

  final String? image;
  final BoxFit fit;
  final double errorWidgetSize;
  final double? height;
  final double? width;
  final Widget? placeholder;

  bool get _isValidUrl {
    if (image == null || image!.isEmpty) return false;
    return Uri.tryParse(image!)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl) {
      return _errorWidget();
    }

    return CachedNetworkImage(
      imageUrl: image!,
      fit: fit,
      height: height,
      width: width,
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child:
              placeholder ??
              CircularProgressWidget(progres: progress, size: 28.r),
        );
      },
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      errorWidget: (_, s, o) => _errorWidget(),
    );
  }

  Widget _errorWidget() {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: errorWidgetSize,
          color: Colors.grey,
        ),
      ),
    );
  }
}
