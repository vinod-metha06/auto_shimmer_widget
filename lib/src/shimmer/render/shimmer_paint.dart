part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerShimmerPaint on RenderAutoShimmer {
  Paint _buildDepthPaint(int depth) {
    final base = _depthColor(baseColor, depth);
    final highlight = _depthColor(highlightColor, depth);

    switch (animationType) {
      case ShimmerAnimationType.none:
        return Paint()..color = base;

      case ShimmerAnimationType.pulse:
        return _buildPulsePaint(
          base: base,
          highlight: highlight,
          minMix: 0.0,
          maxMix: 1.0,
        );

      case ShimmerAnimationType.breathe:
        return _buildPulsePaint(
          base: base,
          highlight: highlight,
          minMix: 0.18,
          maxMix: 0.55,
        );

      case ShimmerAnimationType.glow:
        return _buildGlowPaint(
          base: base,
          highlight: highlight,
        );

      case ShimmerAnimationType.slide:
        return _buildMovingGradientPaint(
          base: base,
          highlight: highlight,
          progress: _animationValue,
          colors: [base, highlight, base],
          stops: const [0.1, 0.3, 0.4],
        );

      case ShimmerAnimationType.wave:
        return _buildMovingGradientPaint(
          base: base,
          highlight: highlight,
          progress: _animationValue,
          colors: [
            base,
            highlight
                .withAlpha((highlight.a * 255.0 * 0.80).round().clamp(0, 255)),
            base,
            highlight,
            base,
          ],
          stops: const [0.0, 0.22, 0.45, 0.68, 1.0],
        );

      case ShimmerAnimationType.bounce:
        final bounceProgress = _triangleWave(_animationValue);

        return _buildMovingGradientPaint(
          base: base,
          highlight: highlight,
          progress: bounceProgress,
          colors: [base, highlight, base],
          stops: const [0.1, 0.3, 0.4],
        );
    }
  }

  Paint _buildPulsePaint({
    required Color base,
    required Color highlight,
    required double minMix,
    required double maxMix,
  }) {
    final pulse = 0.5 + 0.5 * sin(_animationValue * pi * 2);
    final mix = minMix + ((maxMix - minMix) * pulse);

    return Paint()
      ..color = Color.lerp(
        base,
        highlight,
        mix,
      )!;
  }

  Paint _buildMovingGradientPaint({
    required Color base,
    required Color highlight,
    required double progress,
    required List<Color> colors,
    required List<double> stops,
  }) {
    final beginEnd = _resolveGradientDirection();
    final offset = _resolveSlideOffset(progress);

    final gradient = LinearGradient(
      begin: beginEnd.$1,
      end: beginEnd.$2,
      colors: colors,
      stops: stops,
      transform: _SlidingTransform(
        dx: offset.dx,
        dy: offset.dy,
      ),
    );

    return Paint()
      ..shader = gradient.createShader(
        Offset.zero & size,
      );
  }

  Paint _buildGlowPaint({
    required Color base,
    required Color highlight,
  }) {
    final center = _resolveMovingAlignment(_animationValue);

    final gradient = RadialGradient(
      center: center,
      radius: 0.85,
      colors: [
        highlight,
        Color.lerp(highlight, base, 0.45)!,
        base,
      ],
      stops: const [0.0, 0.35, 1.0],
    );

    return Paint()
      ..shader = gradient.createShader(
        Offset.zero & size,
      );
  }

  Color _depthColor(
    Color color,
    int depth,
  ) {
    final reduce = depth * 8;

    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      (color.r * 255.0 - reduce).round().clamp(0, 255),
      (color.g * 255.0 - reduce).round().clamp(0, 255),
      (color.b * 255.0 - reduce).round().clamp(0, 255),
    );
  }

  double _triangleWave(double value) {
    return value < 0.5 ? value * 2 : (1 - value) * 2;
  }

  Offset _resolveSlideOffset(double progress) {
    final shimmerWidth = size.width * 0.35;
    final shimmerHeight = size.height * 0.35;

    final horizontalOffset =
        (size.width + shimmerWidth * 2) * progress - shimmerWidth;

    final verticalOffset =
        (size.height + shimmerHeight * 2) * progress - shimmerHeight;

    switch (direction) {
      case ShimmerDirection.leftToRight:
        return Offset(horizontalOffset, 0);

      case ShimmerDirection.rightToLeft:
        return Offset(-horizontalOffset, 0);

      case ShimmerDirection.startToEnd:
        return textDirection == TextDirection.rtl
            ? Offset(-horizontalOffset, 0)
            : Offset(horizontalOffset, 0);

      case ShimmerDirection.endToStart:
        return textDirection == TextDirection.rtl
            ? Offset(horizontalOffset, 0)
            : Offset(-horizontalOffset, 0);

      case ShimmerDirection.topToBottom:
        return Offset(0, verticalOffset);

      case ShimmerDirection.bottomToTop:
        return Offset(0, -verticalOffset);

      case ShimmerDirection.topLeftToBottomRight:
        return Offset(horizontalOffset, verticalOffset);

      case ShimmerDirection.topRightToBottomLeft:
        return Offset(-horizontalOffset, verticalOffset);

      case ShimmerDirection.bottomLeftToTopRight:
        return Offset(horizontalOffset, -verticalOffset);

      case ShimmerDirection.bottomRightToTopLeft:
        return Offset(-horizontalOffset, -verticalOffset);
    }
  }

  Alignment _resolveMovingAlignment(double progress) {
    final value = (progress * 2) - 1;

    switch (direction) {
      case ShimmerDirection.leftToRight:
        return Alignment(value, 0);

      case ShimmerDirection.rightToLeft:
        return Alignment(-value, 0);

      case ShimmerDirection.startToEnd:
        return textDirection == TextDirection.rtl
            ? Alignment(-value, 0)
            : Alignment(value, 0);

      case ShimmerDirection.endToStart:
        return textDirection == TextDirection.rtl
            ? Alignment(value, 0)
            : Alignment(-value, 0);

      case ShimmerDirection.topToBottom:
        return Alignment(0, value);

      case ShimmerDirection.bottomToTop:
        return Alignment(0, -value);

      case ShimmerDirection.topLeftToBottomRight:
        return Alignment(value, value);

      case ShimmerDirection.topRightToBottomLeft:
        return Alignment(-value, value);

      case ShimmerDirection.bottomLeftToTopRight:
        return Alignment(value, -value);

      case ShimmerDirection.bottomRightToTopLeft:
        return Alignment(-value, -value);
    }
  }

  (Alignment, Alignment) _resolveGradientDirection() {
    switch (direction) {
      case ShimmerDirection.leftToRight:
        return (
          Alignment.centerLeft,
          Alignment.centerRight,
        );

      case ShimmerDirection.rightToLeft:
        return (
          Alignment.centerRight,
          Alignment.centerLeft,
        );

      case ShimmerDirection.startToEnd:
        return textDirection == TextDirection.rtl
            ? (
                Alignment.centerRight,
                Alignment.centerLeft,
              )
            : (
                Alignment.centerLeft,
                Alignment.centerRight,
              );

      case ShimmerDirection.endToStart:
        return textDirection == TextDirection.rtl
            ? (
                Alignment.centerLeft,
                Alignment.centerRight,
              )
            : (
                Alignment.centerRight,
                Alignment.centerLeft,
              );

      case ShimmerDirection.topToBottom:
        return (
          Alignment.topCenter,
          Alignment.bottomCenter,
        );

      case ShimmerDirection.bottomToTop:
        return (
          Alignment.bottomCenter,
          Alignment.topCenter,
        );

      case ShimmerDirection.topLeftToBottomRight:
        return (
          Alignment.topLeft,
          Alignment.bottomRight,
        );

      case ShimmerDirection.topRightToBottomLeft:
        return (
          Alignment.topRight,
          Alignment.bottomLeft,
        );

      case ShimmerDirection.bottomLeftToTopRight:
        return (
          Alignment.bottomLeft,
          Alignment.topRight,
        );

      case ShimmerDirection.bottomRightToTopLeft:
        return (
          Alignment.bottomRight,
          Alignment.topLeft,
        );
    }
  }
}

class _SlidingTransform extends GradientTransform {
  final double dx;
  final double dy;

  const _SlidingTransform({
    this.dx = 0,
    this.dy = 0,
  });

  @override
  Matrix4 transform(
    Rect bounds, {
    TextDirection? textDirection,
  }) {
    return Matrix4.translationValues(
      dx,
      dy,
      0,
    );
  }
}
