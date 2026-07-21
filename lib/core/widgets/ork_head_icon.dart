import 'package:flutter/material.dart';

/// Pictogramme original (dessiné à la main, pas une icône Material) d'une
/// tête d'orc générique — mâchoire proéminente et deux défenses — pour
/// représenter les Orks sans dépendre d'un logo de licence : l'archétype
/// de l'orc à défenses est un trope générique de la fantasy, pas une
/// création Games Workshop.
class OrkHeadIcon extends StatelessWidget {
  final double size;
  final Color color;

  const OrkHeadIcon({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _OrkHeadPainter(color: color),
    );
  }
}

class _OrkHeadPainter extends CustomPainter {
  final Color color;

  _OrkHeadPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Crâne : dôme arrondi qui s'élargit vers une mâchoire carrée.
    final head = Path()
      ..moveTo(w * 0.5, h * 0.05)
      ..cubicTo(w * 0.92, h * 0.05, w * 0.94, h * 0.42, w * 0.86, h * 0.55)
      ..lineTo(w * 0.80, h * 0.78)
      ..quadraticBezierTo(w * 0.5, h * 0.92, w * 0.20, h * 0.78)
      ..lineTo(w * 0.14, h * 0.55)
      ..cubicTo(w * 0.06, h * 0.42, w * 0.08, h * 0.05, w * 0.5, h * 0.05)
      ..close();
    canvas.drawPath(head, fill);

    // Défenses : deux triangles pointant vers le haut de part et d'autre
    // de la mâchoire, dans la couleur de fond pour se détacher de la tête.
    final tuskPaint = Paint()
      ..color = Colors.white.withValues(alpha: .92)
      ..style = PaintingStyle.fill;

    final leftTusk = Path()
      ..moveTo(w * 0.22, h * 0.72)
      ..lineTo(w * 0.14, h * 0.90)
      ..lineTo(w * 0.32, h * 0.80)
      ..close();
    final rightTusk = Path()
      ..moveTo(w * 0.78, h * 0.72)
      ..lineTo(w * 0.86, h * 0.90)
      ..lineTo(w * 0.68, h * 0.80)
      ..close();
    canvas.drawPath(leftTusk, tuskPaint);
    canvas.drawPath(rightTusk, tuskPaint);

    // Sourcils froncés : deux traits obliques qui se rejoignent au centre.
    final browPaint = Paint()
      ..color = Colors.black.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.07
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.30, h * 0.42),
      Offset(w * 0.46, h * 0.50),
      browPaint,
    );
    canvas.drawLine(
      Offset(w * 0.70, h * 0.42),
      Offset(w * 0.54, h * 0.50),
      browPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OrkHeadPainter oldDelegate) =>
      oldDelegate.color != color;
}
