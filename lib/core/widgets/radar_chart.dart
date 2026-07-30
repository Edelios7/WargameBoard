import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class RadarAxis {
  final String label;

  /// 0-100.
  final double value;

  const RadarAxis({required this.label, required this.value});
}

/// Diagramme radar (toile d'araignée) dessiné à la main (CustomPainter,
/// pas de dépendance externe) — même esprit que [DonutChart]
/// (`donut_chart.dart`). Affiche un polygone de valeurs 0-100 sur N axes
/// répartis uniformément autour du centre, avec une grille de repère.
class RadarChart extends StatelessWidget {
  final List<RadarAxis> axes;
  final Color color;
  final double size;

  const RadarChart({
    super.key,
    required this.axes,
    this.color = AppColors.primary,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _RadarChartPainter(axes: axes, color: color)),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<RadarAxis> axes;
  final Color color;

  _RadarChartPainter({required this.axes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Un polygone a besoin d'au moins 3 sommets pour être lisible.
    if (axes.length < 3) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Marge fixe pour laisser la place aux labels autour du polygone —
    // clampée à 0 : sans ça, un widget plus petit que la marge (72px)
    // donnerait un rayon négatif et dessinerait tout en miroir par
    // rapport au centre au lieu d'un simple petit radar.
    final radius = math.max(0.0, size.width / 2 - 36);
    final angleStep = 2 * math.pi / axes.length;

    Offset unitVector(int i) {
      final angle = -math.pi / 2 + i * angleStep;
      return Offset(math.cos(angle), math.sin(angle));
    }

    Offset pointAt(int i, double fraction) =>
        center + unitVector(i) * radius * fraction;

    final gridPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Anneaux concentriques (25/50/75/100%).
    for (final fraction in const [0.25, 0.5, 0.75, 1.0]) {
      final ring = Path();
      for (var i = 0; i < axes.length; i++) {
        final p = pointAt(i, fraction);
        if (i == 0) {
          ring.moveTo(p.dx, p.dy);
        } else {
          ring.lineTo(p.dx, p.dy);
        }
      }
      ring.close();
      canvas.drawPath(ring, gridPaint);
    }

    // Axes (centre → chaque sommet).
    for (var i = 0; i < axes.length; i++) {
      canvas.drawLine(center, pointAt(i, 1), gridPaint);
    }

    // Polygone de valeurs.
    final dataPath = Path();
    for (var i = 0; i < axes.length; i++) {
      final fraction = (axes[i].value / 100).clamp(0.0, 1.0);
      final p = pointAt(i, fraction);
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = color.withValues(alpha: .25)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Points sur chaque sommet.
    final dotPaint = Paint()..color = color;
    for (var i = 0; i < axes.length; i++) {
      final fraction = (axes[i].value / 100).clamp(0.0, 1.0);
      canvas.drawCircle(pointAt(i, fraction), 3, dotPaint);
    }

    // Labels d'axe, juste au-delà de l'anneau extérieur.
    for (var i = 0; i < axes.length; i++) {
      final labelCenter = center + unitVector(i) * (radius + 18);
      final textPainter = TextPainter(
        text: TextSpan(text: axes[i].label, style: AppTextStyles.caption),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 68);
      textPainter.paint(
        canvas,
        labelCenter - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    if (oldDelegate.color != color || oldDelegate.axes.length != axes.length) {
      return true;
    }
    for (var i = 0; i < axes.length; i++) {
      if (oldDelegate.axes[i].value != axes[i].value ||
          oldDelegate.axes[i].label != axes[i].label) {
        return true;
      }
    }
    return false;
  }
}
