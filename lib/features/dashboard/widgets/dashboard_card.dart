import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool hovering = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() {
        hovering = false;
        pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) {
          setState(() => pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          scale: pressed
              ? 0.98
              : hovering
                  ? 1.02
                  : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: hovering
                    ? Colors.deepPurpleAccent.withValues(alpha: .6)
                    : Colors.white10,
                width: hovering ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: hovering
                      ? Colors.deepPurpleAccent.withValues(alpha: .40)
                      : Colors.black26,
                  blurRadius: hovering ? 30 : 12,
                  spreadRadius: hovering ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    offset: hovering
                        ? const Offset(-0.02, 0)
                        : Offset.zero,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      scale: hovering ? 1.06 : 1,
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(190, 5, 5, 12),
                          Color.fromARGB(110, 5, 5, 12),
                          Color.fromARGB(0, 5, 5, 12),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: hovering ? 36 : 34,
                              fontWeight: FontWeight.bold,
                            ),
                            child: Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 10),

                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .90),
                              fontSize: hovering ? 18 : 17,
                            ),
                            child: Text(
                              widget.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 180),
                      alignment: hovering
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: hovering
                              ? Colors.deepPurpleAccent.withValues(alpha: .20)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 42,
                          color: hovering
                              ? Colors.deepPurpleAccent
                              : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}