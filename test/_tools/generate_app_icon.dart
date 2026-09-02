// Script ponctuel (pas un vrai test) pour générer les sources de l'icône
// d'application — un hexagone façon "tuile de plateau" en 3 facettes
// (jeu de lumière isométrique façon gemme), dans la couleur d'accent par
// défaut de l'appli. Exécuter avec :
//   flutter test test/_tools/generate_app_icon.dart
// Régénère assets/icon/icon.png (avec fond) et
// assets/icon/icon_foreground.png (transparent, pour l'icône adaptative
// Android), puis `dart run flutter_launcher_icons` applique ces sources à
// toutes les plateformes.
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double _size = 1024;
const Offset _center = Offset(_size / 2, _size / 2);

const Color _background = Color(0xFF0A0C10);
const Color _glow = Color(0xFF7F31E6);
const Color _facetTop = Color(0xFFB668F6);
const Color _facetLeft = Color(0xFF7F31E6);
const Color _facetRight = Color(0xFF551FA0);
const Color _outline = Color(0xFF05060A);

List<Offset> _hexVertices(double radius) {
  return List.generate(6, (i) {
    final angle = (-90 + i * 60) * pi / 180;
    return Offset(
      _center.dx + radius * cos(angle),
      _center.dy + radius * sin(angle),
    );
  });
}

void _drawHex(Canvas canvas, double radius, {double highlightOpacity = 0.16}) {
  final vertices = _hexVertices(radius);
  final v0 = vertices[0]; // haut
  final v1 = vertices[1];
  final v2 = vertices[2];
  final v3 = vertices[3]; // bas
  final v4 = vertices[4];
  final v5 = vertices[5];

  final topFacet = Path()
    ..moveTo(_center.dx, _center.dy)
    ..lineTo(v5.dx, v5.dy)
    ..lineTo(v0.dx, v0.dy)
    ..lineTo(v1.dx, v1.dy)
    ..close();
  final leftFacet = Path()
    ..moveTo(_center.dx, _center.dy)
    ..lineTo(v1.dx, v1.dy)
    ..lineTo(v2.dx, v2.dy)
    ..lineTo(v3.dx, v3.dy)
    ..close();
  final rightFacet = Path()
    ..moveTo(_center.dx, _center.dy)
    ..lineTo(v3.dx, v3.dy)
    ..lineTo(v4.dx, v4.dy)
    ..lineTo(v5.dx, v5.dy)
    ..close();

  canvas.drawPath(topFacet, Paint()..color = _facetTop);
  canvas.drawPath(leftFacet, Paint()..color = _facetLeft);
  canvas.drawPath(rightFacet, Paint()..color = _facetRight);

  final outline = Path()
    ..moveTo(v0.dx, v0.dy)
    ..lineTo(v1.dx, v1.dy)
    ..lineTo(v2.dx, v2.dy)
    ..lineTo(v3.dx, v3.dy)
    ..lineTo(v4.dx, v4.dy)
    ..lineTo(v5.dx, v5.dy)
    ..close();
  canvas.drawPath(
    outline,
    Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.02
      ..strokeJoin = StrokeJoin.round,
  );
  // Lignes internes entre facettes, légèrement assombries pour bien
  // séparer les 3 plans (effet "gemme taillée").
  final innerEdges = Paint()
    ..color = _outline.withValues(alpha: .5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = radius * 0.012;
  canvas.drawLine(_center, v1, innerEdges);
  canvas.drawLine(_center, v3, innerEdges);
  canvas.drawLine(_center, v5, innerEdges);

  // Reflet spéculaire sur la facette du haut, façon surface polie.
  final highlight = Path()
    ..moveTo(v5.dx, v5.dy)
    ..lineTo(v0.dx, v0.dy)
    ..lineTo(
      v0.dx + (_center.dx - v0.dx) * .35,
      v0.dy + (_center.dy - v0.dy) * .35,
    )
    ..lineTo(
      v5.dx + (_center.dx - v5.dx) * .55,
      v5.dy + (_center.dy - v5.dy) * .55,
    )
    ..close();
  canvas.drawPath(
    highlight,
    Paint()..color = Colors.white.withValues(alpha: highlightOpacity),
  );
}

Future<void> _renderAndSave(String path, {required bool withBackground}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, _size, _size));

  if (withBackground) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, _size, _size),
      Paint()..color = _background,
    );
    final glowPaint = Paint()
      ..color = _glow.withValues(alpha: .35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 140);
    canvas.drawCircle(_center, 300, glowPaint);
    _drawHex(canvas, 340);
  } else {
    // Rayon réduit pour la couche foreground adaptative Android, qui doit
    // rester dans la zone de sécurité centrale (~66% du canevas) sous
    // peine d'être rognée par le masque du launcher.
    _drawHex(canvas, 300, highlightOpacity: .18);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(_size.toInt(), _size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path);
  file.parent.createSync(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate app icon sources', () async {
    await _renderAndSave('assets/icon/icon.png', withBackground: true);
    await _renderAndSave(
      'assets/icon/icon_foreground.png',
      withBackground: false,
    );
  });
}
