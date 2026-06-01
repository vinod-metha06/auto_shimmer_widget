import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../models/shimmer_animation_type.dart';
import '../models/shimmer_direction.dart';

part 'render/render_auto_shimmer_widget.dart';
part 'render/widget_dispatcher.dart';
part 'render/basic_painters.dart';
part 'render/layout_painters.dart';
part 'render/size_resolver.dart';
part 'render/shimmer_paint.dart';

class RenderAutoShimmer extends RenderProxyBox {
  Widget originalWidget;

  int shimmerItemCount;
  int gridCrossAxisCount;

  ShimmerAnimationType animationType;
  Duration speed;
  Color baseColor;
  Color highlightColor;
  ShimmerDirection direction;
  TextDirection textDirection;
  double borderRadius;

  late final Ticker _ticker;

  double _animationValue = 0;

  RenderAutoShimmer({
    required this.originalWidget,
    required TickerProvider vsync,
    this.shimmerItemCount = 6,
    this.gridCrossAxisCount = 2,
    this.animationType = ShimmerAnimationType.slide,
    this.speed = const Duration(milliseconds: 1200),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.startToEnd,
    this.textDirection = TextDirection.ltr,
    this.borderRadius = 18,
  }) {
    _ticker = vsync.createTicker(_tick)..start();
  }

  @override
  bool get isRepaintBoundary => true;

  void _tick(Duration elapsed) {
    final totalMilliseconds =
        speed.inMilliseconds <= 0 ? 1200 : speed.inMilliseconds;

    _animationValue =
        (elapsed.inMilliseconds % totalMilliseconds) / totalMilliseconds;

    markNeedsPaint();
  }

  @override
  void performLayout() {
    child?.layout(
      constraints,
      parentUsesSize: true,
    );

    size = child?.size ?? constraints.smallest;
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset,
  ) {
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    canvas.clipRect(
      Offset.zero & size,
    );

    _paintBackground(canvas);

    _paintWidget(
      canvas,
      originalWidget,
      Offset.zero,
      size,
      depth: 1,
    );

    canvas.restore();
  }

  void _paintBackground(Canvas canvas) {
    final paint = _buildDepthPaint(0);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }

  @override
  void detach() {
    _ticker.dispose();
    super.detach();
  }
}
