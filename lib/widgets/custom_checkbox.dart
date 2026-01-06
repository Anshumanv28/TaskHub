import 'package:flutter/material.dart';
import '../app/theme.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final double size;
  final Color? borderColor;
  final Color? checkmarkColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 20,
    this.borderColor,
    this.checkmarkColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppTheme.buttonBgColor;
    final effectiveCheckmarkColor = checkmarkColor ?? AppTheme.buttonBgColor;

    return GestureDetector(
      onTap: onChanged != null
          ? () {
              onChanged!(!value);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: effectiveBorderColor, width: 2),
          color: Colors.transparent,
        ),
        child: value
            ? TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, progress, child) {
                  return CustomPaint(
                    painter: CheckmarkPainter(
                      progress: progress,
                      color: effectiveCheckmarkColor,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Checkmark path: bottom-left to center, then center to top-right
    final startX = size.width * 0.2;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.7;
    final endX = size.width * 0.8;
    final endY = size.height * 0.3;

    if (progress < 0.5) {
      // Draw first part of checkmark (bottom-left to center)
      final firstProgress = progress * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * firstProgress,
        startY + (midY - startY) * firstProgress,
      );
    } else {
      // Draw complete first part, then second part
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);

      final secondProgress = (progress - 0.5) * 2;
      path.lineTo(
        midX + (endX - midX) * secondProgress,
        midY + (endY - midY) * secondProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
