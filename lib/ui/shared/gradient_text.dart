import 'package:align/app/theme.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText({
    required this.text,
    super.key,
    this.style,
    this.gradient = AppColors.gradientPlayerX,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style ?? Theme.of(context).textTheme.displayLarge)?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
