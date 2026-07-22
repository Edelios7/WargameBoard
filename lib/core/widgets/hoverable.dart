import 'package:flutter/material.dart';

/// Enrobe un widget cliquable ("ouvre" une page/vue) d'un effet de survol
/// commun à toute l'app : léger agrandissement + éclaircissement, pour
/// signaler clairement qu'il est interactif. Voir aussi [AppCard], qui a
/// ce comportement intégré quand `onTap` est fourni.
class Hoverable extends StatefulWidget {
  final Widget child;
  final double scale;
  final Alignment scaleAlignment;
  final BorderRadius? borderRadius;

  const Hoverable({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.scaleAlignment = Alignment.center,
    this.borderRadius,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1,
        alignment: widget.scaleAlignment,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 140),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
