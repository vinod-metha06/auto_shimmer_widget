part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerFormPainters on RenderAutoShimmer {
  void _paintCheckbox(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final boxSize = size.shortestSide.clamp(18.0, 24.0);
    final rect = Rect.fromLTWH(
      offset.dx + (size.width - boxSize) / 2,
      offset.dy + (size.height - boxSize) / 2,
      boxSize,
      boxSize,
    );

    final paint = _buildDepthPaint(depth);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      paint,
    );
  }

  void _paintSwitch(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final trackWidth = min(size.width, 46.0).clamp(36.0, 48.0);
    final trackHeight = min(size.height, 26.0).clamp(20.0, 28.0);
    final trackX = offset.dx + (size.width - trackWidth) / 2;
    final trackY = offset.dy + (size.height - trackHeight) / 2;
    final trackRect = Rect.fromLTWH(trackX, trackY, trackWidth, trackHeight);

    final trackPaint = _buildDepthPaint(depth);
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackHeight / 2)),
      trackPaint,
    );

    final thumbSize = trackHeight - 6.0;
    final thumbRect = Rect.fromLTWH(
      trackX + 3.0,
      trackY + 3.0,
      thumbSize,
      thumbSize,
    );
    canvas.drawOval(thumbRect, _buildDepthPaint(depth + 1));
  }

  void _paintRadio(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final radioSize = size.shortestSide.clamp(18.0, 24.0);
    final x = offset.dx + (size.width - radioSize) / 2;
    final y = offset.dy + (size.height - radioSize) / 2;
    final outerRect = Rect.fromLTWH(x, y, radioSize, radioSize);

    canvas.drawOval(outerRect, _buildDepthPaint(depth));

    final innerSize = radioSize * 0.45;
    final innerRect = Rect.fromLTWH(
      x + (radioSize - innerSize) / 2,
      y + (radioSize - innerSize) / 2,
      innerSize,
      innerSize,
    );
    canvas.drawOval(innerRect, _buildDepthPaint(depth + 1));
  }

  void _paintSlider(
    Canvas canvas,
    Slider slider,
    Offset offset,
    Size size,
    int depth,
  ) {
    const horizontalPadding = 16.0;
    final centerY = offset.dy + size.height / 2;
    final trackLeft = offset.dx + horizontalPadding;
    final trackWidth = max(0.0, size.width - horizontalPadding * 2);

    final trackRect = Rect.fromLTWH(
      trackLeft,
      centerY - 2.5,
      trackWidth,
      5.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(2.5)),
      _buildDepthPaint(depth),
    );

    double fraction = 0.4;
    final range = slider.max - slider.min;
    if (range > 0) {
      fraction = ((slider.value - slider.min) / range).clamp(0.0, 1.0);
    }
    if (textDirection == TextDirection.rtl) {
      fraction = 1.0 - fraction;
    }

    final activeWidth = trackWidth * fraction;
    if (activeWidth > 0) {
      final activeLeft = textDirection == TextDirection.rtl
          ? trackLeft + trackWidth - activeWidth
          : trackLeft;
      final activeRect = Rect.fromLTWH(
        activeLeft,
        centerY - 2.5,
        activeWidth,
        5.0,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, const Radius.circular(2.5)),
        _buildDepthPaint(depth + 1),
      );
    }

    const thumbSize = 18.0;
    final thumbX = trackLeft + trackWidth * fraction - (thumbSize / 2);
    final thumbRect = Rect.fromLTWH(
      thumbX,
      centerY - (thumbSize / 2),
      thumbSize,
      thumbSize,
    );
    canvas.drawOval(thumbRect, _buildDepthPaint(depth + 1));
  }

  void _paintRangeSlider(
    Canvas canvas,
    RangeSlider slider,
    Offset offset,
    Size size,
    int depth,
  ) {
    const horizontalPadding = 16.0;
    final centerY = offset.dy + size.height / 2;
    final trackLeft = offset.dx + horizontalPadding;
    final trackWidth = max(0.0, size.width - horizontalPadding * 2);

    final trackRect = Rect.fromLTWH(
      trackLeft,
      centerY - 2.5,
      trackWidth,
      5.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(2.5)),
      _buildDepthPaint(depth),
    );

    final range = slider.max - slider.min;
    double startFraction = 0.25;
    double endFraction = 0.75;
    if (range > 0) {
      startFraction =
          ((slider.values.start - slider.min) / range).clamp(0.0, 1.0);
      endFraction = ((slider.values.end - slider.min) / range).clamp(0.0, 1.0);
    }
    if (textDirection == TextDirection.rtl) {
      final tmp = 1.0 - endFraction;
      endFraction = 1.0 - startFraction;
      startFraction = tmp;
    }

    final activeLeft = trackLeft + trackWidth * startFraction;
    final activeWidth = max(0.0, trackWidth * (endFraction - startFraction));
    if (activeWidth > 0) {
      final activeRect = Rect.fromLTWH(
        activeLeft,
        centerY - 2.5,
        activeWidth,
        5.0,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, const Radius.circular(2.5)),
        _buildDepthPaint(depth + 1),
      );
    }

    const thumbSize = 18.0;
    final thumb1X = trackLeft + trackWidth * startFraction - (thumbSize / 2);
    canvas.drawOval(
      Rect.fromLTWH(thumb1X, centerY - (thumbSize / 2), thumbSize, thumbSize),
      _buildDepthPaint(depth + 1),
    );

    final thumb2X = trackLeft + trackWidth * endFraction - (thumbSize / 2);
    canvas.drawOval(
      Rect.fromLTWH(thumb2X, centerY - (thumbSize / 2), thumbSize, thumbSize),
      _buildDepthPaint(depth + 1),
    );
  }

  void _paintDropdownButton(
    Canvas canvas,
    DropdownButton dropdown,
    Offset offset,
    Size size,
    int depth,
  ) {
    final height = min(size.height, 48.0);
    final width = size.width;
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + (size.height - height) / 2,
      width,
      height,
    );

    _paintRect(
      canvas,
      rect.topLeft,
      rect.size,
      depth,
      radius: BorderRadius.circular(8),
    );

    final textWidth = max(0.0, width - 60.0) * 0.55;
    const textHeight = 14.0;
    final textY = rect.top + (height - textHeight) / 2;

    if (textDirection == TextDirection.rtl) {
      final textX = rect.right - 14.0 - textWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(textX, textY, textWidth, textHeight),
          const Radius.circular(4),
        ),
        _buildDepthPaint(depth + 1),
      );
      _paintDropdownChevron(
        canvas,
        Offset(rect.left + 22.0, rect.top + height / 2),
        depth + 1,
      );
    } else {
      final textX = rect.left + 14.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(textX, textY, textWidth, textHeight),
          const Radius.circular(4),
        ),
        _buildDepthPaint(depth + 1),
      );
      _paintDropdownChevron(
        canvas,
        Offset(rect.right - 22.0, rect.top + height / 2),
        depth + 1,
      );
    }
  }

  void _paintDropdownMenu(
    Canvas canvas,
    DropdownMenu menu,
    Offset offset,
    Size size,
    int depth,
  ) {
    final height = min(size.height, 56.0);
    final width = size.width;
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + (size.height - height) / 2,
      width,
      height,
    );

    _paintRect(
      canvas,
      rect.topLeft,
      rect.size,
      depth,
      radius: BorderRadius.circular(8),
    );

    double leadingSpace = 16.0;
    if (menu.leadingIcon != null) {
      final iconX = textDirection == TextDirection.rtl
          ? rect.right - 36.0
          : rect.left + 12.0;
      _paintWidget(
        canvas,
        menu.leadingIcon!,
        Offset(iconX, rect.top + (height - 24.0) / 2),
        const Size(24.0, 24.0),
        depth: depth + 1,
      );
      leadingSpace = 44.0;
    }

    final textWidth = max(0.0, width - leadingSpace - 48.0) * 0.55;
    const textHeight = 14.0;
    final textY = rect.top + (height - textHeight) / 2;

    if (textDirection == TextDirection.rtl) {
      final textX = rect.right - leadingSpace - textWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(textX, textY, textWidth, textHeight),
          const Radius.circular(4),
        ),
        _buildDepthPaint(depth + 1),
      );
      _paintDropdownChevron(
        canvas,
        Offset(rect.left + 22.0, rect.top + height / 2),
        depth + 1,
      );
    } else {
      final textX = rect.left + leadingSpace;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(textX, textY, textWidth, textHeight),
          const Radius.circular(4),
        ),
        _buildDepthPaint(depth + 1),
      );
      _paintDropdownChevron(
        canvas,
        Offset(rect.right - 22.0, rect.top + height / 2),
        depth + 1,
      );
    }
  }

  void _paintDropdownChevron(Canvas canvas, Offset center, int depth) {
    const chevronSize = 8.0;
    final path = Path()
      ..moveTo(center.dx - chevronSize / 2, center.dy - chevronSize / 4)
      ..lineTo(center.dx, center.dy + chevronSize / 4)
      ..lineTo(center.dx + chevronSize / 2, center.dy - chevronSize / 4);

    final strokePaint = _buildDepthPaint(depth)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);
  }

  void _paintCheckboxListTile(
    Canvas canvas,
    CheckboxListTile tile,
    Offset offset,
    Size size,
    int depth,
  ) {
    final isLeading = tile.controlAffinity == ListTileControlAffinity.leading;
    _paintSelectionListTile(
      canvas,
      title: tile.title,
      subtitle: tile.subtitle,
      secondary: tile.secondary,
      isControlLeading: isLeading,
      controlType: _SelectionControlType.checkbox,
      controlSize: const Size(22.0, 22.0),
      contentPadding: tile.contentPadding,
      offset: offset,
      size: size,
      depth: depth,
    );
  }

  void _paintSwitchListTile(
    Canvas canvas,
    SwitchListTile tile,
    Offset offset,
    Size size,
    int depth,
  ) {
    final isLeading = tile.controlAffinity == ListTileControlAffinity.leading;
    _paintSelectionListTile(
      canvas,
      title: tile.title,
      subtitle: tile.subtitle,
      secondary: tile.secondary,
      isControlLeading: isLeading,
      controlType: _SelectionControlType.switchControl,
      controlSize: const Size(44.0, 24.0),
      contentPadding: tile.contentPadding,
      offset: offset,
      size: size,
      depth: depth,
    );
  }

  void _paintRadioListTile(
    Canvas canvas,
    RadioListTile tile,
    Offset offset,
    Size size,
    int depth,
  ) {
    final isLeading = tile.controlAffinity != ListTileControlAffinity.trailing;
    _paintSelectionListTile(
      canvas,
      title: tile.title,
      subtitle: tile.subtitle,
      secondary: tile.secondary,
      isControlLeading: isLeading,
      controlType: _SelectionControlType.radio,
      controlSize: const Size(22.0, 22.0),
      contentPadding: tile.contentPadding,
      offset: offset,
      size: size,
      depth: depth,
    );
  }

  void _paintSelectionListTile(
    Canvas canvas, {
    required Widget? title,
    required Widget? subtitle,
    required Widget? secondary,
    required bool isControlLeading,
    required _SelectionControlType controlType,
    required Size controlSize,
    required EdgeInsetsGeometry? contentPadding,
    required Offset offset,
    required Size size,
    required int depth,
  }) {
    final padding = contentPadding != null
        ? _resolveEdgeInsets(contentPadding)
        : const EdgeInsets.symmetric(horizontal: 16.0);
    const gap = 16.0;

    double secondaryWidth = 0.0;
    double secondaryHeight = 0.0;
    final hasSecondary = secondary != null && !_isZeroSizeChild(secondary);
    if (hasSecondary) {
      if (secondary is CircleAvatar) {
        final radius = secondary.radius ?? 20.0;
        secondaryWidth = radius * 2;
        secondaryHeight = radius * 2;
      } else {
        secondaryWidth = 24.0;
        secondaryHeight = 24.0;
      }
    }

    final leadingWidth = isControlLeading ? controlSize.width : secondaryWidth;
    final leadingHeight = isControlLeading ? controlSize.height : secondaryHeight;
    final hasLeading = isControlLeading || hasSecondary;

    final trailingWidth = isControlLeading ? secondaryWidth : controlSize.width;
    final trailingHeight =
        isControlLeading ? secondaryHeight : controlSize.height;
    final hasTrailing = !isControlLeading || hasSecondary;

    final centerY = offset.dy + size.height / 2;

    void paintControl(Offset controlOffset) {
      switch (controlType) {
        case _SelectionControlType.checkbox:
          _paintCheckbox(canvas, controlOffset, controlSize, depth + 1);
          break;
        case _SelectionControlType.switchControl:
          _paintSwitch(canvas, controlOffset, controlSize, depth + 1);
          break;
        case _SelectionControlType.radio:
          _paintRadio(canvas, controlOffset, controlSize, depth + 1);
          break;
      }
    }

    if (textDirection == TextDirection.rtl) {
      final leadingX =
          offset.dx + size.width - padding.right - leadingWidth;
      final trailingX = offset.dx + padding.left;

      if (hasLeading) {
        final leadingOffset = Offset(
          leadingX,
          offset.dy + (size.height - leadingHeight) / 2,
        );
        if (isControlLeading) {
          paintControl(leadingOffset);
        } else if (secondary != null) {
          _paintWidget(
            canvas,
            secondary,
            leadingOffset,
            Size(leadingWidth, leadingHeight),
            depth: depth + 1,
          );
        }
      }

      if (hasTrailing) {
        final trailingOffset = Offset(
          trailingX,
          offset.dy + (size.height - trailingHeight) / 2,
        );
        if (!isControlLeading) {
          paintControl(trailingOffset);
        } else if (secondary != null) {
          _paintWidget(
            canvas,
            secondary,
            trailingOffset,
            Size(trailingWidth, trailingHeight),
            depth: depth + 1,
          );
        }
      }

      final contentRight =
          hasLeading ? leadingX - gap : offset.dx + size.width - padding.right;
      final contentLeft =
          hasTrailing ? trailingX + trailingWidth + gap : offset.dx + padding.left;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final hasSubtitle = subtitle != null;
      final titleY = hasSubtitle ? centerY - 20.0 : centerY - 10.0;
      final titleHeight = hasSubtitle ? 18.0 : 20.0;

      if (title != null) {
        _paintWidget(
          canvas,
          title,
          Offset(contentLeft, titleY),
          Size(contentWidth, titleHeight),
          depth: depth + 1,
        );
      } else {
        _paintText(
          canvas,
          Offset(contentLeft, titleY),
          Size(contentWidth, titleHeight),
          depth + 1,
        );
      }

      if (hasSubtitle) {
        _paintWidget(
          canvas,
          subtitle,
          Offset(contentLeft, centerY + 3.0),
          Size(contentWidth * 0.75, 16.0),
          depth: depth + 1,
        );
      }

      return;
    }

    // LTR layout
    final leadingX = offset.dx + padding.left;
    final trailingX =
        offset.dx + size.width - padding.right - trailingWidth;

    if (hasLeading) {
      final leadingOffset = Offset(
        leadingX,
        offset.dy + (size.height - leadingHeight) / 2,
      );
      if (isControlLeading) {
        paintControl(leadingOffset);
      } else if (secondary != null) {
        _paintWidget(
          canvas,
          secondary,
          leadingOffset,
          Size(leadingWidth, leadingHeight),
          depth: depth + 1,
        );
      }
    }

    if (hasTrailing) {
      final trailingOffset = Offset(
        trailingX,
        offset.dy + (size.height - trailingHeight) / 2,
      );
      if (!isControlLeading) {
        paintControl(trailingOffset);
      } else if (secondary != null) {
        _paintWidget(
          canvas,
          secondary,
          trailingOffset,
          Size(trailingWidth, trailingHeight),
          depth: depth + 1,
        );
      }
    }

    final contentLeft =
        hasLeading ? leadingX + leadingWidth + gap : offset.dx + padding.left;
    final contentRight =
        hasTrailing ? trailingX - gap : offset.dx + size.width - padding.right;
    final contentWidth = max(0.0, contentRight - contentLeft);

    final hasSubtitle = subtitle != null;
    final titleY = hasSubtitle ? centerY - 20.0 : centerY - 10.0;
    final titleHeight = hasSubtitle ? 18.0 : 20.0;

    if (title != null) {
      _paintWidget(
        canvas,
        title,
        Offset(contentLeft, titleY),
        Size(contentWidth, titleHeight),
        depth: depth + 1,
      );
    } else {
      _paintText(
        canvas,
        Offset(contentLeft, titleY),
        Size(contentWidth, titleHeight),
        depth + 1,
      );
    }

    if (hasSubtitle) {
      _paintWidget(
        canvas,
        subtitle,
        Offset(contentLeft, centerY + 3.0),
        Size(contentWidth * 0.75, 16.0),
        depth: depth + 1,
      );
    }
  }
}

enum _SelectionControlType {
  checkbox,
  switchControl,
  radio,
}
