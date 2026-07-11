import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final double? size;

  const SvgIcon({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SvgPicture.asset(
        clipBehavior: Clip.hardEdge,
        assetName,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
