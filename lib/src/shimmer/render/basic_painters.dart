part of auto_shimmer_render;

extension RenderAutoShimmerBasicPainters on RenderAutoShimmer {
  void _paintImagePlaceholder(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth, {
    BorderRadius? radius,
  }) {
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );

    final imageBlockPaint = Paint()..color = const Color(0xFFD0D0D0);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: radius?.topLeft ?? const Radius.circular(12),
        topRight: radius?.topRight ?? const Radius.circular(12),
        bottomLeft: radius?.bottomLeft ?? const Radius.circular(12),
        bottomRight: radius?.bottomRight ?? const Radius.circular(12),
      ),
      imageBlockPaint,
    );

    final iconSize = size.shortestSide.clamp(42.0, 60.0);

    final iconRect = Rect.fromLTWH(
      offset.dx + (size.width - iconSize) / 2,
      offset.dy + (size.height - iconSize) / 2,
      iconSize,
      iconSize,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        iconRect,
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFAFAFAF),
    );

    final lineRect = Rect.fromLTWH(
      iconRect.left + 10,
      iconRect.bottom - 16,
      iconRect.width - 20,
      6,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        lineRect,
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFE2E2E2),
    );
  }

  void _paintDivider(
    Canvas canvas,
    Divider divider,
    Offset offset,
    Size size,
    int depth,
  ) {
    final thickness = divider.thickness ?? 1.0;
    final indent = divider.indent ?? 0.0;
    final endIndent = divider.endIndent ?? 0.0;

    final paint = this._buildDepthPaint(depth);

    final y = offset.dy + size.height / 2;

    final rect = Rect.fromLTWH(
      offset.dx + indent,
      y,
      max(0, size.width - indent - endIndent),
      thickness,
    );

    canvas.drawRect(rect, paint);
  }

  void _paintVerticalDivider(
    Canvas canvas,
    VerticalDivider divider,
    Offset offset,
    Size size,
    int depth,
  ) {
    final thickness = divider.thickness ?? 1.0;
    final indent = divider.indent ?? 0.0;
    final endIndent = divider.endIndent ?? 0.0;

    final paint = this._buildDepthPaint(depth);

    final x = offset.dx + size.width / 2;

    final rect = Rect.fromLTWH(
      x,
      offset.dy + indent,
      thickness,
      max(0, size.height - indent - endIndent),
    );

    canvas.drawRect(rect, paint);
  }

 void _paintText(
  Canvas canvas,
  Offset offset,
  Size size,
  int depth,
) {
  final paint = _buildDepthPaint(depth);

  final height = size.height.clamp(12.0, 18.0);
  final width = size.width * 0.7;

  final dx = textDirection == TextDirection.rtl
      ? offset.dx + size.width - width
      : offset.dx;

  final rect = Rect.fromLTWH(
    dx,
    offset.dy + (size.height - height) / 2,
    width,
    height,
  );

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      rect,
      const Radius.circular(4),
    ),
    paint,
  );
}

  void _paintIcon(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final paint = this._buildDepthPaint(depth);

    final dimension = size.shortestSide.clamp(18.0, 28.0);

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + (size.height - dimension) / 2,
      dimension,
      dimension,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(6),
      ),
      paint,
    );
  }

  void _paintCircle(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final paint = this._buildDepthPaint(depth);

    final dimension = size.shortestSide.clamp(32.0, 64.0);

    final rect = Rect.fromLTWH(
      offset.dx + (size.width - dimension) / 2,
      offset.dy + (size.height - dimension) / 2,
      dimension,
      dimension,
    );

    canvas.drawOval(rect, paint);
  }

  void _paintRect(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth, {
    BorderRadius? radius,
  }) {
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final paint = this._buildDepthPaint(depth);

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: radius?.topLeft ?? const Radius.circular(12),
        topRight: radius?.topRight ?? const Radius.circular(12),
        bottomLeft: radius?.bottomLeft ?? const Radius.circular(12),
        bottomRight: radius?.bottomRight ?? const Radius.circular(12),
      ),
      paint,
    );
  }
}
