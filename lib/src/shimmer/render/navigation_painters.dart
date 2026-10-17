part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerNavigationPainters on RenderAutoShimmer {
  void _paintAppBar(
    Canvas canvas,
    AppBar appBar,
    Offset offset,
    Size size,
    int depth,
  ) {
    final toolbarHeight = appBar.toolbarHeight ?? kToolbarHeight;
    final bottomHeight = appBar.bottom?.preferredSize.height ?? 0.0;
    final totalHeight = toolbarHeight + bottomHeight;

    _paintRect(
      canvas,
      offset,
      Size(size.width, totalHeight),
      depth,
      radius: BorderRadius.zero,
    );

    const horizontalPadding = 16.0;
    const gap = 12.0;

    double leadingWidth = 0.0;
    final hasLeading =
        appBar.leading != null || appBar.automaticallyImplyLeading;

    double actionsWidth = 0.0;
    final hasActions =
        appBar.actions != null && appBar.actions!.isNotEmpty;

    if (hasActions) {
      actionsWidth = appBar.actions!.length * 40.0 + gap;
    }

    if (hasLeading) {
      leadingWidth = 36.0;
    }

    final centerY = offset.dy + toolbarHeight / 2;

    if (textDirection == TextDirection.rtl) {
      // RTL: Leading on right, actions on left
      if (hasLeading) {
        final leadingX = offset.dx + size.width - horizontalPadding - 24.0;
        final leadingOffset = Offset(leadingX, centerY - 12.0);
        if (appBar.leading != null) {
          _paintWidget(
            canvas,
            appBar.leading!,
            leadingOffset,
            const Size(24.0, 24.0),
            depth: depth + 1,
          );
        } else {
          _paintIcon(canvas, leadingOffset, const Size(24.0, 24.0), depth + 1);
        }
      }

      if (hasActions) {
        double actionX = offset.dx + horizontalPadding;
        for (final action in appBar.actions!) {
          _paintWidget(
            canvas,
            action,
            Offset(actionX, centerY - 16.0),
            const Size(32.0, 32.0),
            depth: depth + 1,
          );
          actionX += 40.0;
        }
      }

      final contentRight = hasLeading
          ? offset.dx + size.width - horizontalPadding - leadingWidth - gap
          : offset.dx + size.width - horizontalPadding;
      final contentLeft = hasActions
          ? offset.dx + horizontalPadding + actionsWidth
          : offset.dx + horizontalPadding;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final titleWidth = min(contentWidth, 160.0);
      final isCentered = appBar.centerTitle ?? false;
      final titleX = isCentered
          ? offset.dx + (size.width - titleWidth) / 2
          : contentRight - titleWidth;

      if (appBar.title != null) {
        _paintWidget(
          canvas,
          appBar.title!,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth: depth + 1,
        );
      } else {
        _paintText(
          canvas,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth + 1,
        );
      }
    } else {
      // LTR: Leading on left, actions on right
      if (hasLeading) {
        final leadingOffset = Offset(
          offset.dx + horizontalPadding,
          centerY - 12.0,
        );
        if (appBar.leading != null) {
          _paintWidget(
            canvas,
            appBar.leading!,
            leadingOffset,
            const Size(24.0, 24.0),
            depth: depth + 1,
          );
        } else {
          _paintIcon(canvas, leadingOffset, const Size(24.0, 24.0), depth + 1);
        }
      }

      if (hasActions) {
        double actionX =
            offset.dx + size.width - horizontalPadding - 32.0;
        for (final action in appBar.actions!.reversed) {
          _paintWidget(
            canvas,
            action,
            Offset(actionX, centerY - 16.0),
            const Size(32.0, 32.0),
            depth: depth + 1,
          );
          actionX -= 40.0;
        }
      }

      final contentLeft = hasLeading
          ? offset.dx + horizontalPadding + leadingWidth + gap
          : offset.dx + horizontalPadding;
      final contentRight = hasActions
          ? offset.dx + size.width - horizontalPadding - actionsWidth
          : offset.dx + size.width - horizontalPadding;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final titleWidth = min(contentWidth, 160.0);
      final isCentered = appBar.centerTitle ?? false;
      final titleX = isCentered
          ? offset.dx + (size.width - titleWidth) / 2
          : contentLeft;

      if (appBar.title != null) {
        _paintWidget(
          canvas,
          appBar.title!,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth: depth + 1,
        );
      } else {
        _paintText(
          canvas,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth + 1,
        );
      }
    }

    if (appBar.bottom != null) {
      _paintWidget(
        canvas,
        appBar.bottom!,
        Offset(offset.dx, offset.dy + toolbarHeight),
        Size(size.width, bottomHeight),
        depth: depth + 1,
      );
    }
  }

  void _paintSliverAppBar(
    Canvas canvas,
    SliverAppBar appBar,
    Offset offset,
    Size size,
    int depth,
  ) {
    final toolbarHeight = appBar.toolbarHeight;
    final totalHeight = appBar.expandedHeight ?? toolbarHeight;

    _paintRect(
      canvas,
      offset,
      Size(size.width, totalHeight),
      depth,
      radius: BorderRadius.zero,
    );

    const horizontalPadding = 16.0;
    const gap = 12.0;

    double leadingWidth = 0.0;
    final hasLeading =
        appBar.leading != null || appBar.automaticallyImplyLeading;

    double actionsWidth = 0.0;
    final hasActions =
        appBar.actions != null && appBar.actions!.isNotEmpty;

    if (hasActions) {
      actionsWidth = appBar.actions!.length * 40.0 + gap;
    }

    if (hasLeading) {
      leadingWidth = 36.0;
    }

    final centerY = offset.dy + toolbarHeight / 2;

    if (textDirection == TextDirection.rtl) {
      if (hasLeading) {
        final leadingX = offset.dx + size.width - horizontalPadding - 24.0;
        final leadingOffset = Offset(leadingX, centerY - 12.0);
        if (appBar.leading != null) {
          _paintWidget(
            canvas,
            appBar.leading!,
            leadingOffset,
            const Size(24.0, 24.0),
            depth: depth + 1,
          );
        } else {
          _paintIcon(canvas, leadingOffset, const Size(24.0, 24.0), depth + 1);
        }
      }

      if (hasActions) {
        double actionX = offset.dx + horizontalPadding;
        for (final action in appBar.actions!) {
          _paintWidget(
            canvas,
            action,
            Offset(actionX, centerY - 16.0),
            const Size(32.0, 32.0),
            depth: depth + 1,
          );
          actionX += 40.0;
        }
      }

      final contentRight = hasLeading
          ? offset.dx + size.width - horizontalPadding - leadingWidth - gap
          : offset.dx + size.width - horizontalPadding;
      final contentLeft = hasActions
          ? offset.dx + horizontalPadding + actionsWidth
          : offset.dx + horizontalPadding;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final titleWidth = min(contentWidth, 160.0);
      final isCentered = appBar.centerTitle ?? false;
      final titleX = isCentered
          ? offset.dx + (size.width - titleWidth) / 2
          : contentRight - titleWidth;

      if (appBar.title != null) {
        _paintWidget(
          canvas,
          appBar.title!,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth: depth + 1,
        );
      }
    } else {
      if (hasLeading) {
        final leadingOffset = Offset(
          offset.dx + horizontalPadding,
          centerY - 12.0,
        );
        if (appBar.leading != null) {
          _paintWidget(
            canvas,
            appBar.leading!,
            leadingOffset,
            const Size(24.0, 24.0),
            depth: depth + 1,
          );
        } else {
          _paintIcon(canvas, leadingOffset, const Size(24.0, 24.0), depth + 1);
        }
      }

      if (hasActions) {
        double actionX =
            offset.dx + size.width - horizontalPadding - 32.0;
        for (final action in appBar.actions!.reversed) {
          _paintWidget(
            canvas,
            action,
            Offset(actionX, centerY - 16.0),
            const Size(32.0, 32.0),
            depth: depth + 1,
          );
          actionX -= 40.0;
        }
      }

      final contentLeft = hasLeading
          ? offset.dx + horizontalPadding + leadingWidth + gap
          : offset.dx + horizontalPadding;
      final contentRight = hasActions
          ? offset.dx + size.width - horizontalPadding - actionsWidth
          : offset.dx + size.width - horizontalPadding;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final titleWidth = min(contentWidth, 160.0);
      final isCentered = appBar.centerTitle ?? false;
      final titleX = isCentered
          ? offset.dx + (size.width - titleWidth) / 2
          : contentLeft;

      if (appBar.title != null) {
        _paintWidget(
          canvas,
          appBar.title!,
          Offset(titleX, centerY - 10.0),
          Size(titleWidth, 20.0),
          depth: depth + 1,
        );
      }
    }

    if (appBar.bottom != null) {
      final bottomHeight = appBar.bottom!.preferredSize.height;
      _paintWidget(
        canvas,
        appBar.bottom!,
        Offset(offset.dx, offset.dy + totalHeight - bottomHeight),
        Size(size.width, bottomHeight),
        depth: depth + 1,
      );
    }
  }

  void _paintTabBar(
    Canvas canvas,
    TabBar tabBar,
    Offset offset,
    Size size,
    int depth,
  ) {
    final tabs = tabBar.tabs;
    if (tabs.isEmpty) return;

    final tabHeight = min(size.height, tabBar.preferredSize.height);
    final slotWidth = size.width / tabs.length;

    for (int i = 0; i < tabs.length; i++) {
      final slotLeft = offset.dx + i * slotWidth;
      final tabWidth = max(0.0, slotWidth - 24.0);
      _paintWidget(
        canvas,
        tabs[i],
        Offset(slotLeft + 12.0, offset.dy + (tabHeight - 24.0) / 2),
        Size(tabWidth, 24.0),
        depth: depth + 1,
      );
    }

    // Active indicator line
    final indicatorWidth = max(24.0, slotWidth * 0.6);
    final indicatorLeft = offset.dx + (slotWidth - indicatorWidth) / 2;
    final indicatorRect = Rect.fromLTWH(
      indicatorLeft,
      offset.dy + tabHeight - 3.0,
      indicatorWidth,
      3.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(indicatorRect, const Radius.circular(2.0)),
      _buildDepthPaint(depth + 2),
    );
  }

  void _paintTab(
    Canvas canvas,
    Tab tab,
    Offset offset,
    Size size,
    int depth,
  ) {
    if (tab.child != null) {
      _paintWidget(canvas, tab.child!, offset, size, depth: depth);
      return;
    }

    if (tab.icon != null && tab.text != null) {
      _paintWidget(
        canvas,
        tab.icon!,
        Offset(offset.dx + (size.width - 18.0) / 2, offset.dy),
        const Size(18.0, 18.0),
        depth: depth + 1,
      );
      final textWidth = min(size.width * 0.75, 60.0);
      _paintText(
        canvas,
        Offset(offset.dx + (size.width - textWidth) / 2, offset.dy + 20.0),
        Size(textWidth, 12.0),
        depth + 1,
      );
      return;
    }

    if (tab.icon != null) {
      final iconSize = min(size.shortestSide, 24.0);
      _paintWidget(
        canvas,
        tab.icon!,
        Offset(
          offset.dx + (size.width - iconSize) / 2,
          offset.dy + (size.height - iconSize) / 2,
        ),
        Size(iconSize, iconSize),
        depth: depth + 1,
      );
      return;
    }

    // Text tab
    final textWidth = min(size.width * 0.75, 70.0);
    _paintText(
      canvas,
      Offset(
        offset.dx + (size.width - textWidth) / 2,
        offset.dy + (size.height - 14.0) / 2,
      ),
      Size(textWidth, 14.0),
      depth + 1,
    );
  }

  void _paintBadge(
    Canvas canvas,
    Badge badge,
    Offset offset,
    Size size,
    int depth,
  ) {
    if (badge.child != null) {
      _paintWidget(canvas, badge.child!, offset, size, depth: depth);
    }

    if (!badge.isLabelVisible) return;

    final badgeOffset = textDirection == TextDirection.rtl
        ? Offset(offset.dx - 2.0, offset.dy - 2.0)
        : Offset(offset.dx + size.width - 10.0, offset.dy - 2.0);

    if (badge.label != null) {
      const badgeWidth = 20.0;
      const badgeHeight = 14.0;
      final rect = Rect.fromLTWH(
        textDirection == TextDirection.rtl
            ? offset.dx - 4.0
            : offset.dx + size.width - badgeWidth + 4.0,
        offset.dy - 4.0,
        badgeWidth,
        badgeHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(badgeHeight / 2)),
        _buildDepthPaint(depth + 2),
      );
    } else {
      // Small badge dot
      const dotSize = 8.0;
      final rect = Rect.fromLTWH(
        badgeOffset.dx,
        badgeOffset.dy,
        dotSize,
        dotSize,
      );
      canvas.drawOval(rect, _buildDepthPaint(depth + 2));
    }
  }

  void _paintExpansionTile(
    Canvas canvas,
    ExpansionTile tile,
    Offset offset,
    Size size,
    int depth,
  ) {
    final headerHeight = tile.subtitle != null ? 72.0 : 56.0;
    const horizontalPadding = 16.0;
    const gap = 16.0;

    double leadingSize = 24.0;
    final hasLeading =
        tile.leading != null && !_isZeroSizeChild(tile.leading!);
    if (hasLeading && tile.leading is CircleAvatar) {
      final avatar = tile.leading as CircleAvatar;
      leadingSize = (avatar.radius ?? 20.0) * 2;
    }

    final centerY = offset.dy + headerHeight / 2;

    if (textDirection == TextDirection.rtl) {
      final leadingX =
          offset.dx + size.width - horizontalPadding - leadingSize;
      if (hasLeading) {
        _paintWidget(
          canvas,
          tile.leading!,
          Offset(leadingX, centerY - leadingSize / 2),
          Size(leadingSize, leadingSize),
          depth: depth + 1,
        );
      }

      if (tile.trailing != null) {
        _paintWidget(
          canvas,
          tile.trailing!,
          Offset(offset.dx + horizontalPadding, centerY - 12.0),
          const Size(24.0, 24.0),
          depth: depth + 1,
        );
      } else {
        _paintDropdownChevron(
          canvas,
          Offset(offset.dx + horizontalPadding + 12.0, centerY),
          depth + 1,
        );
      }

      final contentRight = hasLeading
          ? leadingX - gap
          : offset.dx + size.width - horizontalPadding;
      final contentLeft = offset.dx + horizontalPadding + 36.0;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final hasSubtitle = tile.subtitle != null;
      final titleY = hasSubtitle ? centerY - 18.0 : centerY - 10.0;
      final titleHeight = hasSubtitle ? 18.0 : 20.0;

      _paintWidget(
        canvas,
        tile.title,
        Offset(contentLeft, titleY),
        Size(contentWidth, titleHeight),
        depth: depth + 1,
      );

      if (hasSubtitle) {
        _paintWidget(
          canvas,
          tile.subtitle!,
          Offset(contentLeft, centerY + 3.0),
          Size(contentWidth * 0.75, 16.0),
          depth: depth + 1,
        );
      }
    } else {
      if (hasLeading) {
        _paintWidget(
          canvas,
          tile.leading!,
          Offset(offset.dx + horizontalPadding, centerY - leadingSize / 2),
          Size(leadingSize, leadingSize),
          depth: depth + 1,
        );
      }

      if (tile.trailing != null) {
        _paintWidget(
          canvas,
          tile.trailing!,
          Offset(offset.dx + size.width - horizontalPadding - 24.0, centerY - 12.0),
          const Size(24.0, 24.0),
          depth: depth + 1,
        );
      } else {
        _paintDropdownChevron(
          canvas,
          Offset(offset.dx + size.width - horizontalPadding - 12.0, centerY),
          depth + 1,
        );
      }

      final contentLeft = hasLeading
          ? offset.dx + horizontalPadding + leadingSize + gap
          : offset.dx + horizontalPadding;
      final contentRight =
          offset.dx + size.width - horizontalPadding - 36.0;
      final contentWidth = max(0.0, contentRight - contentLeft);

      final hasSubtitle = tile.subtitle != null;
      final titleY = hasSubtitle ? centerY - 18.0 : centerY - 10.0;
      final titleHeight = hasSubtitle ? 18.0 : 20.0;

      _paintWidget(
        canvas,
        tile.title,
        Offset(contentLeft, titleY),
        Size(contentWidth, titleHeight),
        depth: depth + 1,
      );

      if (hasSubtitle) {
        _paintWidget(
          canvas,
          tile.subtitle!,
          Offset(contentLeft, centerY + 3.0),
          Size(contentWidth * 0.75, 16.0),
          depth: depth + 1,
        );
      }
    }

    if (tile.initiallyExpanded && tile.children.isNotEmpty) {
      double childY = offset.dy + headerHeight;
      for (final child in tile.children) {
        final childHeight = _estimateWidgetHeight(child, size.height) ?? 48.0;
        _paintWidget(
          canvas,
          child,
          Offset(offset.dx + horizontalPadding, childY),
          Size(size.width - horizontalPadding * 2, childHeight),
          depth: depth + 1,
        );
        childY += childHeight;
      }
    }
  }

  void _paintPlaceholder(
    Canvas canvas,
    Placeholder placeholder,
    Offset offset,
    Size size,
    int depth,
  ) {
    final rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    _paintRect(
      canvas,
      offset,
      size,
      depth,
      radius: BorderRadius.circular(8.0),
    );

    // Diagonal crossed lines
    final strokePaint = _buildDepthPaint(depth + 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = placeholder.strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rect.left + 6.0, rect.top + 6.0),
      Offset(rect.right - 6.0, rect.bottom - 6.0),
      strokePaint,
    );

    canvas.drawLine(
      Offset(rect.right - 6.0, rect.top + 6.0),
      Offset(rect.left + 6.0, rect.bottom - 6.0),
      strokePaint,
    );
  }
}
