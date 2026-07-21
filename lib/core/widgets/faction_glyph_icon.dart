import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Bibliothèque de pictogrammes originaux (dessinés à la main, pas des
/// icônes Material) pour représenter chaque faction par un symbole qui lui
/// ressemble vraiment — casque, crâne, hache, griffe... — sans jamais
/// reproduire un logo ou un blason officiel Games Workshop : ce sont des
/// archétypes génériques de la fantasy/science-fiction (comme la tête
/// d'orc de [OrkHeadIcon]).
enum GlyphKind {
  wolfHead,
  fist,
  sword,
  lizard,
  raven,
  spear,
  chalice,
  helmet,
  claw,
  robotSkull,
  dagger,
  anvil,
  flameEye,
  axe,
  hydra,
  hornedSkull,
  mask,
  plagueSkull,
  knightMech,
}

class FactionGlyphIcon extends StatelessWidget {
  final GlyphKind kind;
  final double size;
  final Color color;

  const FactionGlyphIcon({
    super.key,
    required this.kind,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _FactionGlyphPainter(kind: kind, color: color),
    );
  }
}

class _FactionGlyphPainter extends CustomPainter {
  final GlyphKind kind;
  final Color color;

  _FactionGlyphPainter({required this.kind, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final accent = Paint()
      ..color = Colors.white.withValues(alpha: .92)
      ..style = PaintingStyle.fill;
    final shade = Paint()
      ..color = Colors.black.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.07
      ..strokeCap = StrokeCap.round;

    switch (kind) {
      case GlyphKind.wolfHead:
        final head = Path()
          ..moveTo(w * 0.5, h * 0.08)
          ..lineTo(w * 0.20, h * 0.02)
          ..lineTo(w * 0.30, h * 0.30)
          ..cubicTo(w * 0.05, h * 0.40, w * 0.05, h * 0.75, w * 0.28, h * 0.90)
          ..lineTo(w * 0.5, h * 0.98)
          ..lineTo(w * 0.72, h * 0.90)
          ..cubicTo(w * 0.95, h * 0.75, w * 0.95, h * 0.40, w * 0.70, h * 0.30)
          ..lineTo(w * 0.80, h * 0.02)
          ..close();
        canvas.drawPath(head, fill);
        canvas.drawLine(
          Offset(w * 0.5, h * 0.55),
          Offset(w * 0.5, h * 0.80),
          shade,
        );
        break;

      case GlyphKind.fist:
        final wrist = Path()
          ..moveTo(w * 0.30, h * 0.98)
          ..lineTo(w * 0.30, h * 0.66)
          ..lineTo(w * 0.70, h * 0.66)
          ..lineTo(w * 0.70, h * 0.98)
          ..close();
        canvas.drawPath(wrist, fill);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.12, h * 0.14, w * 0.76, h * 0.56),
            Radius.circular(w * 0.18),
          ),
          fill,
        );
        for (final x in [0.30, 0.5, 0.70]) {
          canvas.drawLine(
            Offset(w * x, h * 0.14),
            Offset(w * x, h * 0.66),
            shade,
          );
        }
        break;

      case GlyphKind.sword:
        final blade = Path()
          ..moveTo(w * 0.5, h * 0.02)
          ..lineTo(w * 0.60, h * 0.62)
          ..lineTo(w * 0.40, h * 0.62)
          ..close();
        canvas.drawPath(blade, fill);
        canvas.drawRect(
          Rect.fromLTWH(w * 0.22, h * 0.62, w * 0.56, h * 0.10),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.44, h * 0.72, w * 0.12, h * 0.24),
          fill,
        );
        canvas.drawCircle(Offset(w * 0.5, h * 0.94), h * 0.06, fill);
        break;

      case GlyphKind.lizard:
        final body = Path()
          ..moveTo(w * 0.18, h * 0.55)
          ..cubicTo(w * 0.10, h * 0.30, w * 0.30, h * 0.10, w * 0.50, h * 0.18)
          ..cubicTo(w * 0.70, h * 0.10, w * 0.94, h * 0.30, w * 0.88, h * 0.55)
          ..cubicTo(w * 0.94, h * 0.70, w * 0.80, h * 0.88, w * 0.62, h * 0.80)
          ..cubicTo(w * 0.55, h * 0.95, w * 0.40, h * 0.95, w * 0.36, h * 0.80)
          ..cubicTo(w * 0.20, h * 0.88, w * 0.12, h * 0.70, w * 0.18, h * 0.55)
          ..close();
        canvas.drawPath(body, fill);
        for (final x in [0.35, 0.5, 0.65]) {
          final spike = Path()
            ..moveTo(w * x - w * 0.05, h * 0.20)
            ..lineTo(w * x, h * 0.06)
            ..lineTo(w * x + w * 0.05, h * 0.20)
            ..close();
          canvas.drawPath(spike, accent);
        }
        break;

      case GlyphKind.raven:
        final body = Path()..moveTo(w * 0.5, h * 0.30);
        final leftWing = Path()
          ..moveTo(w * 0.5, h * 0.34)
          ..cubicTo(w * 0.30, h * 0.10, w * 0.02, h * 0.20, w * 0.06, h * 0.44)
          ..cubicTo(w * 0.20, h * 0.42, w * 0.34, h * 0.48, w * 0.44, h * 0.60)
          ..close();
        final rightWing = Path()
          ..moveTo(w * 0.5, h * 0.34)
          ..cubicTo(w * 0.70, h * 0.10, w * 0.98, h * 0.20, w * 0.94, h * 0.44)
          ..cubicTo(w * 0.80, h * 0.42, w * 0.66, h * 0.48, w * 0.56, h * 0.60)
          ..close();
        canvas.drawPath(leftWing, fill);
        canvas.drawPath(rightWing, fill);
        final head = Path()
          ..moveTo(w * 0.5, h * 0.42)
          ..cubicTo(w * 0.40, h * 0.42, w * 0.36, h * 0.56, w * 0.44, h * 0.66)
          ..lineTo(w * 0.5, h * 0.94)
          ..lineTo(w * 0.56, h * 0.66)
          ..cubicTo(w * 0.64, h * 0.56, w * 0.60, h * 0.42, w * 0.5, h * 0.42)
          ..close();
        canvas.drawPath(head, fill);
        canvas.drawPath(body, fill);
        final beak = Path()
          ..moveTo(w * 0.44, h * 0.50)
          ..lineTo(w * 0.30, h * 0.52)
          ..lineTo(w * 0.44, h * 0.58)
          ..close();
        canvas.drawPath(beak, fill);
        break;

      case GlyphKind.spear:
        canvas.drawRect(
          Rect.fromLTWH(w * 0.46, h * 0.30, w * 0.08, h * 0.66),
          fill,
        );
        final head = Path()
          ..moveTo(w * 0.5, h * 0.02)
          ..lineTo(w * 0.68, h * 0.34)
          ..lineTo(w * 0.5, h * 0.26)
          ..lineTo(w * 0.32, h * 0.34)
          ..close();
        canvas.drawPath(head, fill);
        canvas.drawLine(
          Offset(w * 0.28, h * 0.42),
          Offset(w * 0.72, h * 0.42),
          shade,
        );
        break;

      case GlyphKind.chalice:
        final bowl = Path()
          ..moveTo(w * 0.22, h * 0.20)
          ..lineTo(w * 0.78, h * 0.20)
          ..cubicTo(w * 0.78, h * 0.52, w * 0.60, h * 0.62, w * 0.5, h * 0.62)
          ..cubicTo(w * 0.40, h * 0.62, w * 0.22, h * 0.52, w * 0.22, h * 0.20)
          ..close();
        canvas.drawPath(bowl, fill);
        canvas.drawRect(
          Rect.fromLTWH(w * 0.45, h * 0.62, w * 0.10, h * 0.22),
          fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.30, h * 0.84, w * 0.40, h * 0.10),
            Radius.circular(w * 0.04),
          ),
          fill,
        );
        final flame = Path()
          ..moveTo(w * 0.5, h * 0.0)
          ..cubicTo(w * 0.62, h * 0.06, w * 0.60, h * 0.14, w * 0.5, h * 0.18)
          ..cubicTo(w * 0.40, h * 0.14, w * 0.38, h * 0.06, w * 0.5, h * 0.0)
          ..close();
        canvas.drawPath(flame, accent);
        break;

      case GlyphKind.helmet:
        final dome = Path()
          ..moveTo(w * 0.14, h * 0.55)
          ..cubicTo(w * 0.14, h * 0.10, w * 0.86, h * 0.10, w * 0.86, h * 0.55)
          ..lineTo(w * 0.78, h * 0.55)
          ..lineTo(w * 0.78, h * 0.72)
          ..cubicTo(w * 0.78, h * 0.92, w * 0.22, h * 0.92, w * 0.22, h * 0.72)
          ..lineTo(w * 0.22, h * 0.55)
          ..close();
        canvas.drawPath(dome, fill);
        canvas.drawRect(
          Rect.fromLTWH(w * 0.44, h * 0.30, w * 0.12, h * 0.42),
          accent,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.30, h * 0.46, w * 0.40, h * 0.10),
          accent,
        );
        break;

      case GlyphKind.claw:
        for (final angle in [-0.55, 0.0, 0.55]) {
          final talon = Path()
            ..moveTo(w * 0.5, h * 0.55)
            ..quadraticBezierTo(
              w * 0.5 + math.sin(angle) * w * 0.42,
              h * 0.55 - math.cos(angle) * h * 0.10,
              w * 0.5 + math.sin(angle) * w * 0.48,
              h * 0.10,
            )
            ..quadraticBezierTo(
              w * 0.5 + math.sin(angle) * w * 0.38,
              h * 0.55 - math.cos(angle) * h * 0.06,
              w * 0.5,
              h * 0.62,
            )
            ..close();
          canvas.drawPath(talon, fill);
        }
        canvas.drawCircle(Offset(w * 0.5, h * 0.66), h * 0.14, fill);
        break;

      case GlyphKind.robotSkull:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.16, h * 0.08, w * 0.68, h * 0.56),
            Radius.circular(w * 0.24),
          ),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.20, h * 0.60, w * 0.60, h * 0.30),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.28, h * 0.26, w * 0.16, h * 0.16),
          accent,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.56, h * 0.26, w * 0.16, h * 0.16),
          accent,
        );
        for (final x in [0.32, 0.46, 0.60]) {
          canvas.drawRect(
            Rect.fromLTWH(w * x, h * 0.66, w * 0.06, h * 0.18),
            accent,
          );
        }
        break;

      case GlyphKind.dagger:
        final blade = Path()
          ..moveTo(w * 0.5, h * 0.02)
          ..cubicTo(w * 0.68, h * 0.20, w * 0.62, h * 0.50, w * 0.5, h * 0.60)
          ..cubicTo(w * 0.38, h * 0.50, w * 0.32, h * 0.20, w * 0.5, h * 0.02)
          ..close();
        canvas.drawPath(blade, fill);
        canvas.drawRect(
          Rect.fromLTWH(w * 0.28, h * 0.60, w * 0.44, h * 0.08),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.44, h * 0.68, w * 0.12, h * 0.26),
          fill,
        );
        break;

      case GlyphKind.anvil:
        final body = Path()
          ..moveTo(w * 0.10, h * 0.42)
          ..lineTo(w * 0.36, h * 0.42)
          ..lineTo(w * 0.40, h * 0.30)
          ..lineTo(w * 0.86, h * 0.30)
          ..lineTo(w * 0.92, h * 0.46)
          ..lineTo(w * 0.40, h * 0.46)
          ..lineTo(w * 0.36, h * 0.58)
          ..lineTo(w * 0.64, h * 0.58)
          ..lineTo(w * 0.64, h * 0.72)
          ..lineTo(w * 0.28, h * 0.72)
          ..lineTo(w * 0.24, h * 0.58)
          ..close();
        canvas.drawPath(body, fill);
        canvas.drawRect(
          Rect.fromLTWH(w * 0.24, h * 0.72, w * 0.44, h * 0.12),
          fill,
        );
        break;

      case GlyphKind.flameEye:
        final eye = Path()
          ..moveTo(w * 0.10, h * 0.62)
          ..quadraticBezierTo(w * 0.5, h * 0.40, w * 0.90, h * 0.62)
          ..quadraticBezierTo(w * 0.5, h * 0.84, w * 0.10, h * 0.62)
          ..close();
        canvas.drawPath(eye, fill);
        canvas.drawCircle(Offset(w * 0.5, h * 0.62), h * 0.10, accent);
        final flame = Path()
          ..moveTo(w * 0.5, h * 0.0)
          ..cubicTo(w * 0.66, h * 0.10, w * 0.62, h * 0.26, w * 0.5, h * 0.34)
          ..cubicTo(w * 0.38, h * 0.26, w * 0.34, h * 0.10, w * 0.5, h * 0.0)
          ..close();
        canvas.drawPath(flame, fill);
        break;

      case GlyphKind.axe:
        canvas.drawRect(
          Rect.fromLTWH(w * 0.46, h * 0.10, w * 0.08, h * 0.82),
          fill,
        );
        final head = Path()
          ..moveTo(w * 0.5, h * 0.20)
          ..cubicTo(w * 0.70, h * 0.06, w * 0.96, h * 0.18, w * 0.90, h * 0.42)
          ..cubicTo(w * 0.74, h * 0.44, w * 0.60, h * 0.40, w * 0.5, h * 0.34)
          ..close();
        canvas.drawPath(head, fill);
        break;

      case GlyphKind.hydra:
        for (final dx in [-0.20, 0.0, 0.20]) {
          final neck = Path()
            ..moveTo(w * 0.5, h * 0.95)
            ..quadraticBezierTo(
              w * 0.5 + dx * w * 2,
              h * 0.55,
              w * 0.5 + dx * w * 2.4,
              h * 0.20,
            );
          canvas.drawPath(
            neck,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = w * 0.12
              ..strokeCap = StrokeCap.round,
          );
          canvas.drawCircle(
            Offset(w * 0.5 + dx * w * 2.4, h * 0.16),
            w * 0.08,
            fill,
          );
        }
        break;

      case GlyphKind.hornedSkull:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.18, h * 0.20, w * 0.64, h * 0.50),
            Radius.circular(w * 0.22),
          ),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.24, h * 0.62, w * 0.52, h * 0.26),
          fill,
        );
        for (final side in [-1, 1]) {
          final horn = Path()
            ..moveTo(w * (0.5 + side * 0.20), h * 0.24)
            ..quadraticBezierTo(
              w * (0.5 + side * 0.42),
              h * 0.10,
              w * (0.5 + side * 0.34),
              h * 0.0,
            )
            ..quadraticBezierTo(
              w * (0.5 + side * 0.30),
              h * 0.12,
              w * (0.5 + side * 0.14),
              h * 0.22,
            )
            ..close();
          canvas.drawPath(horn, fill);
        }
        canvas.drawCircle(Offset(w * 0.36, h * 0.42), h * 0.06, accent);
        canvas.drawCircle(Offset(w * 0.64, h * 0.42), h * 0.06, accent);
        break;

      case GlyphKind.mask:
        canvas.drawOval(
          Rect.fromLTWH(w * 0.14, h * 0.06, w * 0.72, h * 0.88),
          fill,
        );
        canvas.drawOval(
          Rect.fromLTWH(w * 0.24, h * 0.32, w * 0.16, h * 0.10),
          accent,
        );
        canvas.drawOval(
          Rect.fromLTWH(w * 0.60, h * 0.32, w * 0.16, h * 0.10),
          accent,
        );
        final smile = Path()
          ..moveTo(w * 0.30, h * 0.66)
          ..quadraticBezierTo(w * 0.5, h * 0.80, w * 0.70, h * 0.66);
        canvas.drawPath(
          smile,
          Paint()
            ..color = Colors.white.withValues(alpha: .92)
            ..style = PaintingStyle.stroke
            ..strokeWidth = h * 0.06
            ..strokeCap = StrokeCap.round,
        );
        break;

      case GlyphKind.plagueSkull:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.16, h * 0.10, w * 0.68, h * 0.56),
            Radius.circular(w * 0.24),
          ),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.22, h * 0.58, w * 0.56, h * 0.30),
          fill,
        );
        canvas.drawCircle(Offset(w * 0.36, h * 0.36), h * 0.08, accent);
        canvas.drawCircle(Offset(w * 0.64, h * 0.36), h * 0.08, accent);
        for (final x in [0.28, 0.5, 0.72]) {
          canvas.drawCircle(
            Offset(w * x, h * 0.94),
            h * 0.04,
            Paint()..color = color.withValues(alpha: .7),
          );
        }
        break;

      case GlyphKind.knightMech:
        canvas.drawCircle(Offset(w * 0.5, h * 0.18), h * 0.14, fill);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.24, h * 0.34, w * 0.52, h * 0.44),
            Radius.circular(w * 0.08),
          ),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.10, h * 0.34, w * 0.16, h * 0.24),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.74, h * 0.34, w * 0.16, h * 0.24),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.30, h * 0.78, w * 0.16, h * 0.20),
          fill,
        );
        canvas.drawRect(
          Rect.fromLTWH(w * 0.54, h * 0.78, w * 0.16, h * 0.20),
          fill,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FactionGlyphPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}
