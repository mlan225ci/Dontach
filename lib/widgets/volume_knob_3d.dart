import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Skeuomorphic 3D rotary volume knob — raised metal dial on a recessed panel.
class VolumeKnob3D extends StatefulWidget {
  const VolumeKnob3D({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 220,
    this.minLabel = '0',
    this.maxLabel = '100',
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double size;
  final String minLabel;
  final String maxLabel;

  static const _startAngle = -2.356;
  static const _sweepAngle = 4.712;

  @override
  State<VolumeKnob3D> createState() => _VolumeKnob3DState();
}

class _VolumeKnob3DState extends State<VolumeKnob3D> {
  double? _dragStartValue;
  double? _dragStartAngle;

  void _onDragStart(DragStartDetails details, Size size) {
    _dragStartValue = widget.value;
    final center = Offset(size.width / 2, size.height / 2);
    _dragStartAngle = math.atan2(
      details.localPosition.dy - center.dy,
      details.localPosition.dx - center.dx,
    );
    HapticFeedback.selectionClick();
  }

  void _onDragUpdate(DragUpdateDetails details, Size size) {
    if (_dragStartValue == null || _dragStartAngle == null) return;
    final center = Offset(size.width / 2, size.height / 2);
    final angle = math.atan2(
      details.localPosition.dy - center.dy,
      details.localPosition.dx - center.dx,
    );
    final delta = angle - _dragStartAngle!;
    final next = (_dragStartValue! + delta / VolumeKnob3D._sweepAngle).clamp(0.0, 1.0);
    if ((next - widget.value).abs() >= 0.008) {
      widget.onChanged(next);
    }
  }

  void _onTapUp(TapUpDetails details, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final delta = details.localPosition - center;
    var angle = math.atan2(delta.dy, delta.dx);
    angle = angle.clamp(
      VolumeKnob3D._startAngle,
      VolumeKnob3D._startAngle + VolumeKnob3D._sweepAngle,
    );
    widget.onChanged(
      ((angle - VolumeKnob3D._startAngle) / VolumeKnob3D._sweepAngle).clamp(0.0, 1.0),
    );
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final knobAngle = VolumeKnob3D._startAngle + widget.value * VolumeKnob3D._sweepAngle;
    final percent = (widget.value * 100).round();
    final lift = lerpDouble(0.0, 6.0, widget.value)!;

    return SizedBox(
      width: size + 24,
      height: size + 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Recessed panel base
          Positioned(
            bottom: 0,
            child: Container(
              width: size * 0.92,
              height: size * 0.38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF080808),
                    const Color(0xFF151515),
                    const Color(0xFF0A0A0A),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.04),
                    blurRadius: 0,
                    offset: const Offset(0, -2),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
          ),
          // Knob assembly with perspective lift
          Transform.translate(
            offset: Offset(0, -lift),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(-0.18),
              child: SizedBox(
                width: size,
                height: size,
                child: GestureDetector(
                  onTapUp: (d) => _onTapUp(d, Size(size, size)),
                  onPanStart: (d) => _onDragStart(d, Size(size, size)),
                  onPanUpdate: (d) => _onDragUpdate(d, Size(size, size)),
                  onPanEnd: (_) {
                    _dragStartValue = null;
                    _dragStartAngle = null;
                  },
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: _VolumeKnobPainter(
                      value: widget.value,
                      knobAngle: knobAngle,
                      minLabel: widget.minLabel,
                      maxLabel: widget.maxLabel,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$percent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.19,
                              fontWeight: FontWeight.w900,
                              height: 1,
                              shadows: const [
                                Shadow(
                                  color: Color(0xAA000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                                Shadow(
                                  color: Color(0x44FFFFFF),
                                  offset: Offset(0, -1),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: size * 0.075,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeKnobPainter extends CustomPainter {
  _VolumeKnobPainter({
    required this.value,
    required this.knobAngle,
    required this.minLabel,
    required this.maxLabel,
  });

  final double value;
  final double knobAngle;
  final String minLabel;
  final String maxLabel;

  static const _accent = Color(0xFF00775B);
  static const _accentLight = Color(0xFF4CAF50);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.47;
    final trackRadius = size.width * 0.41;
    final knobRadius = size.width * 0.29;

    _drawOuterHousing(canvas, center, outerRadius);
    _drawRecessedTrack(canvas, center, trackRadius);
    _drawActiveArc(canvas, center, trackRadius);
    _drawLevelTicks(canvas, center, trackRadius);
    _drawEndLabels(canvas, center, trackRadius);
    _drawKnobBody(canvas, center, knobRadius);
    _drawPointer(canvas, center, knobRadius * 0.68);
  }

  void _drawOuterHousing(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center.translate(0, 8),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF3D3D3D),
            const Color(0xFF222222),
            const Color(0xFF101010),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..shader = SweepGradient(
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.04),
            Colors.black.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.12),
          ],
        ).createShader(rect),
    );
  }

  void _drawRecessedTrack(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    for (final (w, c) in [(16.0, 0xFF050505), (11.0, 0xFF1C1C1C)]) {
      canvas.drawArc(
        rect,
        VolumeKnob3D._startAngle,
        VolumeKnob3D._sweepAngle,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w
          ..strokeCap = StrokeCap.round
          ..color = Color(c),
      );
    }
  }

  void _drawActiveArc(Canvas canvas, Offset center, double radius) {
    if (value <= 0) return;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = value * VolumeKnob3D._sweepAngle;

    canvas.drawArc(
      rect,
      VolumeKnob3D._startAngle,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          colors: [_accent, _accentLight, Color(0xFF81C784)],
        ).createShader(rect),
    );

    canvas.drawArc(
      rect,
      VolumeKnob3D._startAngle,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..color = _accentLight.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _drawLevelTicks(Canvas canvas, Offset center, double radius) {
    for (var i = 0; i <= 10; i++) {
      final t = i / 10;
      final angle = VolumeKnob3D._startAngle + t * VolumeKnob3D._sweepAngle;
      final active = t <= value + 0.001;
      final inner = radius + 20;
      final outer = radius + (i % 5 == 0 ? 30 : 25);
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle), center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle), center.dy + outer * math.sin(angle)),
        Paint()
          ..strokeWidth = i % 5 == 0 ? 2.5 : 1.4
          ..strokeCap = StrokeCap.round
          ..color = active
              ? _accentLight.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.14),
      );
    }
  }

  void _drawEndLabels(Canvas canvas, Offset center, double radius) {
    for (final (angle, label) in [
      (VolumeKnob3D._startAngle, minLabel),
      (VolumeKnob3D._startAngle + VolumeKnob3D._sweepAngle, maxLabel),
    ]) {
      final pos = Offset(
        center.dx + (radius + 38) * math.cos(angle),
        center.dy + (radius + 38) * math.sin(angle),
      );
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, pos - Offset(painter.width / 2, painter.height / 2));
    }
  }

  void _drawKnobBody(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center.translate(0, 7),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.38, -0.48),
          radius: 1.0,
          colors: [
            const Color(0xFF686868),
            const Color(0xFF3A3A3A),
            const Color(0xFF1C1C1C),
            const Color(0xFF0C0C0C),
          ],
          stops: const [0.0, 0.3, 0.72, 1.0],
        ).createShader(rect),
    );

    canvas.drawCircle(
      center.translate(-radius * 0.22, -radius * 0.28),
      radius * 0.28,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(
          center: center.translate(-radius * 0.22, -radius * 0.28),
          radius: radius * 0.28,
        )),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.14),
    );

    canvas.drawCircle(
      center,
      radius * 0.78,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.black.withValues(alpha: 0.45),
    );
  }

  void _drawPointer(Canvas canvas, Offset center, double dist) {
    final tip = Offset(
      center.dx + dist * math.cos(knobAngle),
      center.dy + dist * math.sin(knobAngle),
    );
    canvas.drawLine(
      Offset(center.dx + dist * 0.3 * math.cos(knobAngle),
          center.dy + dist * 0.3 * math.sin(knobAngle)),
      tip,
      Paint()
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = value > 0.04 ? _accentLight : Colors.white.withValues(alpha: 0.25),
    );
    canvas.drawCircle(
      tip,
      5.5,
      Paint()..color = value > 0.04 ? Colors.white : Colors.white.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      tip,
      5.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = _accent,
    );
  }

  @override
  bool shouldRepaint(covariant _VolumeKnobPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.knobAngle != knobAngle;
  }
}
