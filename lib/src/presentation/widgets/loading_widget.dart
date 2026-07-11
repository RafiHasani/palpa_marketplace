import 'package:flutter/material.dart';
import 'package:palpa_marketplace/src/presentation/widgets/circular_progress_widget.dart';

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? backColor;

  const LoadingWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backColor ?? Colors.black.withAlpha(16),
              child: Center(child: CircularProgressWidget()),
            ),
          ),
      ],
    );
  }
}
