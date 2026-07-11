import 'package:flutter/material.dart';

class ThreeDotLoader extends StatefulWidget {
  const ThreeDotLoader({super.key, this.size = 8, this.color = Colors.black});

  final double size;
  final Color color;

  @override
  State<ThreeDotLoader> createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = (_controller.value + index * 0.2) % 1.0;
        final scale = 0.6 + (value < 0.5 ? value : 1 - value) * 0.8;

        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: .center,
      children: List.generate(3, _buildDot),
    );
  }
}
