import 'package:flutter/material.dart';

/// Sélecteur de couleur classique : un carré saturation/valeur (glisser
/// pour choisir la teinte exacte) sous un dégradé de teintes (glisser pour
/// changer de couleur de base) — pas de dépendance externe, construit avec
/// deux dégradés superposés (blanc→teinte, transparent→noir) plutôt qu'un
/// CustomPainter, plus simple à maintenir pour ce résultat.
class HsvColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onChanged;

  const HsvColorPicker({
    super.key,
    required this.initialColor,
    required this.onChanged,
  });

  @override
  State<HsvColorPicker> createState() => _HsvColorPickerState();
}

class _HsvColorPickerState extends State<HsvColorPicker> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
  }

  @override
  void didUpdateWidget(covariant HsvColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _hsv = HSVColor.fromColor(widget.initialColor);
    }
  }

  void _updateSaturationValue(Offset localPosition, Size size) {
    final dx = localPosition.dx.clamp(0.0, size.width);
    final dy = localPosition.dy.clamp(0.0, size.height);
    setState(() {
      _hsv = _hsv
          .withSaturation(dx / size.width)
          .withValue(1 - dy / size.height);
    });
    widget.onChanged(_hsv.toColor());
  }

  void _updateHue(double dx, double width) {
    final hue = ((dx.clamp(0.0, width) / width) * 360).clamp(0.0, 359.9);
    setState(() => _hsv = _hsv.withHue(hue));
    widget.onChanged(_hsv.toColor());
  }

  @override
  Widget build(BuildContext context) {
    final hueColor = HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, 150);
              return GestureDetector(
                onPanDown: (d) => _updateSaturationValue(d.localPosition, size),
                onPanUpdate: (d) =>
                    _updateSaturationValue(d.localPosition, size),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      Positioned.fill(child: ColoredBox(color: hueColor)),
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: (_hsv.saturation * size.width - 9).clamp(
                          -9,
                          size.width - 9,
                        ),
                        top: ((1 - _hsv.value) * size.height - 9).clamp(
                          -9,
                          size.height - 9,
                        ),
                        child: _Thumb(color: _hsv.toColor()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              onPanDown: (d) => _updateHue(d.localPosition.dx, width),
              onPanUpdate: (d) => _updateHue(d.localPosition.dx, width),
              child: SizedBox(
                height: 24,
                width: width,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0000),
                            Color(0xFFFFFF00),
                            Color(0xFF00FF00),
                            Color(0xFF00FFFF),
                            Color(0xFF0000FF),
                            Color(0xFFFF00FF),
                            Color(0xFFFF0000),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: ((_hsv.hue / 360) * width - 3).clamp(-3, width - 3),
                      child: Container(
                        width: 6,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: .3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  final Color color;

  const _Thumb({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: .5),
        ],
      ),
    );
  }
}
