import 'package:flutter/material.dart';

/// A widget that creates text with a black stroke outline in light mode
/// In dark mode, it displays normal text without outline
class OutlinedTextTitle extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const OutlinedTextTitle({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      // Dark mode: just show normal text without outline
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Light mode: add black stroke outline
    return Stack(
      children: [
        // Stroke layer - black outline
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..color = Colors.black
              ..strokeWidth = 2.5
              ..style = PaintingStyle.stroke,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
        // Fill layer - original color (golden)
        Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ],
    );
  }
}