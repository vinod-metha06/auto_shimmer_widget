part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerLayoutPainters on RenderAutoShimmer {
  void _paintCard(
    Canvas canvas,
    Card card,
    Offset offset,
    Size size,
    int depth,
  ) {
    final margin = _resolveEdgeInsets(card.margin);

    final cardOffset = Offset(
      offset.dx + margin.left,
      offset.dy + margin.top,
    );

    final cardSize = Size(
      max(0, size.width - margin.horizontal),
      max(0, size.height - margin.vertical),
    );

    _paintRect(
      canvas,
      cardOffset,
      cardSize,
      depth,
      radius: _extractCardRadius(card),
    );

    if (card.child != null) {
      _paintWidget(
        canvas,
        card.child!,
        cardOffset,
        cardSize,
        depth: depth + 1,
      );
    }
  }

  BorderRadius _extractCardRadius(Card card) {
    final shape = card.shape;

    if (shape is RoundedRectangleBorder) {
      final borderRadius = shape.borderRadius;

      if (borderRadius is BorderRadius) {
        return borderRadius;
      }
    }

    return BorderRadius.circular(12);
  }

  void _paintStack(
    Canvas canvas,
    Stack stack,
    Offset offset,
    Size size,
    int depth,
  ) {
    for (final child in stack.children) {
      if (child is Positioned) {
        _paintPositioned(
          canvas,
          child,
          offset,
          size,
          depth,
        );
      } else {
        _paintWidget(
          canvas,
          child,
          offset,
          size,
          depth: depth + 1,
        );
      }
    }
  }

  void _paintPositioned(
    Canvas canvas,
    Positioned positioned,
    Offset stackOffset,
    Size stackSize,
    int depth,
  ) {
    final estimatedChildSize = _estimatePositionedChildSize(
      positioned.child,
      stackSize,
    );

    double width;
    if (positioned.width != null) {
      width = positioned.width!;
    } else if (positioned.left != null && positioned.right != null) {
      width = stackSize.width - positioned.left! - positioned.right!;
    } else {
      width = estimatedChildSize.width;
    }

    double height;
    if (positioned.height != null) {
      height = positioned.height!;
    } else if (positioned.top != null && positioned.bottom != null) {
      height = stackSize.height - positioned.top! - positioned.bottom!;
    } else {
      height = estimatedChildSize.height;
    }

    width = width.clamp(0.0, stackSize.width);
    height = height.clamp(0.0, stackSize.height);

    final dx = positioned.left != null
        ? positioned.left!
        : positioned.right != null
            ? stackSize.width - positioned.right! - width
            : 0.0;

    final dy = positioned.top != null
        ? positioned.top!
        : positioned.bottom != null
            ? stackSize.height - positioned.bottom! - height
            : 0.0;

    _paintWidget(
      canvas,
      positioned.child,
      Offset(
        stackOffset.dx + dx,
        stackOffset.dy + dy,
      ),
      Size(width, height),
      depth: depth + 1,
    );
  }

  void _paintWrap(
    Canvas canvas,
    Wrap wrap,
    Offset offset,
    Size size,
    int depth,
  ) {
    double dx = offset.dx;
    double dy = offset.dy;

    final maxX = offset.dx + size.width;
    final bottom = offset.dy + size.height;

    for (final child in wrap.children) {
      if (dy >= bottom) break;

      final childSize = _estimateWrapChildSize(child, size);

      if (childSize.width <= 0 && childSize.height <= 0) {
        continue;
      }

      if (dx + childSize.width > maxX) {
        dx = offset.dx;
        dy += childSize.height + wrap.runSpacing;
      }

      if (dy >= bottom) break;

      _paintWidget(
        canvas,
        child,
        Offset(dx, dy),
        childSize,
        depth: depth + 1,
      );

      dx += childSize.width + wrap.spacing;
    }
  }

  void _paintChipLike(
    Canvas canvas,
    Widget widget,
    Offset offset,
    Size size,
    int depth,
  ) {
    final chipSize = Size(
      size.width.clamp(60.0, 140.0),
      size.height.clamp(30.0, 40.0),
    );

    _paintRect(
      canvas,
      offset,
      chipSize,
      depth,
      radius: BorderRadius.circular(40),
    );

    _paintText(
      canvas,
      Offset(offset.dx + 12, offset.dy + 8),
      Size(chipSize.width - 24, 16),
      depth + 1,
    );
  }

  void _paintAspectRatio(
    Canvas canvas,
    AspectRatio aspectRatio,
    Offset offset,
    Size size,
    int depth,
  ) {
    final ratio = aspectRatio.aspectRatio;

    double width = size.width;
    double height = width / ratio;

    if (height > size.height) {
      height = size.height;
      width = height * ratio;
    }

    final childSize = Size(width, height);

    if (aspectRatio.child != null) {
      _paintWidget(
        canvas,
        aspectRatio.child!,
        offset,
        childSize,
        depth: depth + 1,
      );
    } else {
      _paintRect(canvas, offset, childSize, depth);
    }
  }

  void _paintButtonLike(
    Canvas canvas,
    Widget widget,
    Offset offset,
    Size size,
    int depth,
  ) {
    if (widget is IconButton) {
      final buttonSize = Size.square(
        (widget.iconSize ?? 24) + 20,
      );

      _paintRect(
        canvas,
        offset,
        buttonSize,
        depth,
        radius: BorderRadius.circular(12),
      );

      return;
    }

    if (widget is FloatingActionButton) {
      _paintCircle(
        canvas,
        offset,
        const Size(56, 56),
        depth,
      );
      return;
    }

    final buttonSize = Size(
      size.width.clamp(80.0, 180.0),
      size.height.clamp(40.0, 52.0),
    );

    _paintRect(
      canvas,
      offset,
      buttonSize,
      depth,
      radius: BorderRadius.circular(40),
    );

    _paintText(
      canvas,
      Offset(
        offset.dx + 20,
        offset.dy + (buttonSize.height - 16) / 2,
      ),
      Size(buttonSize.width - 40, 16),
      depth + 1,
    );
  }

  void _paintRichText(
    Canvas canvas,
    RichText richText,
    Offset offset,
    Size size,
    int depth,
  ) {
    final maxLines = richText.maxLines ?? 1;
    const lineHeight = 16.0;
    const gap = 6.0;

    for (int i = 0; i < maxLines; i++) {
      final dy = offset.dy + i * (lineHeight + gap);

      if (dy + lineHeight > offset.dy + size.height) {
        break;
      }

      _paintText(
        canvas,
        Offset(offset.dx, dy),
        Size(
          i == maxLines - 1 ? size.width * 0.65 : size.width,
          lineHeight,
        ),
        depth,
      );
    }
  }

  void _paintTextField(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    final fieldHeight = size.height.clamp(48.0, 56.0);

    final fieldSize = Size(
      size.width,
      fieldHeight,
    );

    _paintRect(
      canvas,
      offset,
      fieldSize,
      depth,
      radius: BorderRadius.circular(12),
    );

    _paintText(
      canvas,
      Offset(
        offset.dx + 16,
        offset.dy + (fieldHeight - 16) / 2,
      ),
      Size(size.width * 0.5, 16),
      depth + 1,
    );
  }

  void _paintListView(
    Canvas canvas,
    ListView listView,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = _extractSliverChildren(listView.childrenDelegate);

    final fallbackCount = _resolveBuilderItemCount(listView.childrenDelegate);

    if (children.isEmpty) {
      _paintRepeatedListItems(
        canvas,
        offset,
        size,
        depth,
        fallbackCount,
      );
      return;
    }

    double dy = offset.dy;
    final bottom = offset.dy + size.height;

    for (final child in children) {
      if (dy >= bottom) break;

      final itemHeight = _estimateWidgetHeight(child, size.height) ?? 90.0;

      if (itemHeight <= 0) {
        continue;
      }

      _paintWidget(
        canvas,
        child,
        Offset(offset.dx, dy),
        Size(size.width, itemHeight),
        depth: depth + 1,
      );

      dy += itemHeight;
    }
  }

  void _paintRepeatedListItems(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
    int count,
  ) {
    const itemHeight = 90.0;
    const spacing = 12.0;

    double dy = offset.dy;
    final bottom = offset.dy + size.height;

    for (int index = 0; index < count; index++) {
      if (dy >= bottom) break;

      _paintRect(
        canvas,
        Offset(offset.dx, dy),
        Size(size.width, itemHeight),
        depth + 1,
        radius: BorderRadius.circular(16),
      );

      const avatarSize = 48.0;

      _paintCircle(
        canvas,
        Offset(
          offset.dx + 16,
          dy + (itemHeight - avatarSize) / 2,
        ),
        const Size(avatarSize, avatarSize),
        depth + 2,
      );

      _paintText(
        canvas,
        Offset(offset.dx + 80, dy + 22),
        Size(size.width - 120, 20),
        depth + 2,
      );

      _paintText(
        canvas,
        Offset(offset.dx + 80, dy + 50),
        Size(size.width - 140, 18),
        depth + 2,
      );

      dy += itemHeight + spacing;
    }
  }

  void _paintGridView(
    Canvas canvas,
    GridView gridView,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = _extractSliverChildren(gridView.childrenDelegate);

    final delegate = gridView.gridDelegate;

    int crossAxisCount = gridCrossAxisCount;
    double crossAxisSpacing = 12;
    double mainAxisSpacing = 12;
    double childAspectRatio = 1;

    if (delegate is SliverGridDelegateWithFixedCrossAxisCount) {
      crossAxisCount = delegate.crossAxisCount;
      crossAxisSpacing = delegate.crossAxisSpacing;
      mainAxisSpacing = delegate.mainAxisSpacing;
      childAspectRatio = delegate.childAspectRatio;
    }

    final itemWidth = (size.width - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;

    final itemHeight = itemWidth / childAspectRatio;

    final itemCount = children.isEmpty
        ? _resolveBuilderItemCount(gridView.childrenDelegate)
        : children.length;

    final bottom = offset.dy + size.height;

    for (int index = 0; index < itemCount; index++) {
      final row = index ~/ crossAxisCount;
      final column = index % crossAxisCount;

      final dx = offset.dx + column * (itemWidth + crossAxisSpacing);
      final dy = offset.dy + row * (itemHeight + mainAxisSpacing);

      if (dy >= bottom) break;

      if (children.isEmpty) {
        _paintDefaultGridItem(
          canvas,
          Offset(dx, dy),
          Size(itemWidth, itemHeight),
          depth + 1,
        );
      } else {
        _paintWidget(
          canvas,
          children[index],
          Offset(dx, dy),
          Size(itemWidth, itemHeight),
          depth: depth + 1,
        );
      }
    }
  }

  void _paintDefaultGridItem(
    Canvas canvas,
    Offset offset,
    Size size,
    int depth,
  ) {
    _paintRect(
      canvas,
      offset,
      size,
      depth,
      radius: BorderRadius.circular(18),
    );

    _paintImagePlaceholder(
      canvas,
      offset,
      Size(size.width, size.height * 0.55),
      depth + 1,
      radius: const BorderRadius.vertical(
        top: Radius.circular(18),
      ),
    );

    _paintText(
      canvas,
      Offset(offset.dx + 10, offset.dy + size.height * 0.62),
      Size(size.width - 20, 18),
      depth + 2,
    );

    _paintText(
      canvas,
      Offset(offset.dx + 10, offset.dy + size.height * 0.78),
      Size(size.width * 0.55, 16),
      depth + 2,
    );
  }

  void _paintRow(
    Canvas canvas,
    Row row,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = row.children;

    if (children.isEmpty) return;

    double fixedWidth = 0;
    int flexCount = 0;
    int activeChildCount = 0;

    for (final rawChild in children) {
      if (!_isZeroSizeChild(rawChild)) {
        activeChildCount++;
      }
      final child = _resolveVisibility(rawChild);
      if (child is SizedBox && child.width != null) {
        fixedWidth += child.width!;
      } else if (child is Container) {
        fixedWidth += _containerWidth(child, size.width) ?? 0;
      } else if (child is CircleAvatar) {
        fixedWidth += (child.radius ?? 20) * 2;
      } else if (child is Icon) {
        fixedWidth += child.size ?? 24;
      } else if (child is Expanded) {
        flexCount += child.flex;
      } else if (child is Flexible) {
        flexCount += child.flex;
      } else if (child is Spacer) {
        flexCount += child.flex;
      }
    }

    final remainingWidth = max(
      0.0,
      size.width - fixedWidth,
    );

    final divisor = activeChildCount > 0 ? activeChildCount : children.length;
    final defaultChildWidth = flexCount > 0
        ? remainingWidth / flexCount
        : size.width / divisor;

    if (textDirection == TextDirection.rtl) {
      double dx = offset.dx + size.width;

      for (final child in children) {
        final childWidth = _resolveChildWidthInRow(
          child,
          size.width,
          defaultChildWidth,
        );

        dx -= childWidth;

        final childHeight = _resolveChildHeightInRow(
          child,
          size.height,
        );

        final childDy = _resolveRowChildDy(
          row,
          offset.dy,
          size.height,
          childHeight,
        );

        _paintWidget(
          canvas,
          child,
          Offset(dx, childDy),
          Size(childWidth, childHeight),
          depth: depth + 1,
        );
      }

      return;
    }

    double dx = offset.dx;

    for (final child in children) {
      final childWidth = _resolveChildWidthInRow(
        child,
        size.width,
        defaultChildWidth,
      );

      final childHeight = _resolveChildHeightInRow(
        child,
        size.height,
      );

      final childDy = _resolveRowChildDy(
        row,
        offset.dy,
        size.height,
        childHeight,
      );

      _paintWidget(
        canvas,
        child,
        Offset(dx, childDy),
        Size(childWidth, childHeight),
        depth: depth + 1,
      );

      dx += childWidth;
    }
  }

  double _resolveChildHeightInRow(
    Widget child,
    double parentHeight,
  ) {
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _resolveChildHeightInRow(child.child, parentHeight);
      } else {
        return _resolveChildHeightInRow(child.replacement, parentHeight);
      }
    }

    if (child is CircleAvatar) {
      return ((child.radius ?? 20) * 2).clamp(32.0, parentHeight);
    }

    if (child is Icon) {
      return (child.size ?? 24).clamp(18.0, parentHeight);
    }

    if (child is SizedBox && child.height != null) {
      return child.height!.clamp(0.0, parentHeight);
    }

    if (child is Container) {
      final height = _containerHeight(child, parentHeight);

      if (height != null) {
        return height.clamp(0.0, parentHeight);
      }
    }

    if (child is Expanded || child is Flexible) {
      return parentHeight;
    }

    return parentHeight;
  }

  double _resolveRowChildDy(
    Row row,
    double rowTop,
    double rowHeight,
    double childHeight,
  ) {
    switch (row.crossAxisAlignment) {
      case CrossAxisAlignment.start:
        return rowTop;

      case CrossAxisAlignment.end:
        return rowTop + rowHeight - childHeight;

      case CrossAxisAlignment.center:
        return rowTop + (rowHeight - childHeight) / 2;

      case CrossAxisAlignment.stretch:
        return rowTop;

      case CrossAxisAlignment.baseline:
        return rowTop + (rowHeight - childHeight) / 2;
    }
  }

  void _paintColumn(
    Canvas canvas,
    Column column,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = column.children;

    if (children.isEmpty) return;

    double fixedHeight = 0;
    int flexibleCount = 0;

    for (final child in children) {
      final knownHeight = _knownColumnChildHeight(child, size.height);

      if (knownHeight != null) {
        fixedHeight += knownHeight;
      } else if (child is Expanded) {
        flexibleCount += child.flex;
      } else if (child is Flexible) {
        flexibleCount += child.flex;
      } else if (child is Spacer) {
        flexibleCount += child.flex;
      } else {
        flexibleCount++;
      }
    }

    final remainingHeight = max(0.0, size.height - fixedHeight);

    final fallbackHeight =
        flexibleCount > 0 ? remainingHeight / flexibleCount : 0.0;

    double dy = offset.dy;

    for (final child in children) {
      if (dy >= offset.dy + size.height) break;

      final flex = child is Expanded
          ? child.flex
          : child is Flexible
              ? child.flex
              : child is Spacer
                  ? child.flex
                  : 1;

      final childHeight =
          _knownColumnChildHeight(child, size.height) ?? (fallbackHeight * flex);

      _paintWidget(
        canvas,
        child,
        Offset(offset.dx, dy),
        Size(size.width, childHeight),
        depth: depth + 1,
      );

      dy += childHeight;
    }
  }

  void _paintListTile(
    Canvas canvas,
    ListTile tile,
    Offset offset,
    Size size,
    int depth,
  ) {
    const horizontalPadding = 16.0;
    const gap = 16.0;

    double leadingSize = 40.0;

    final effectiveLeading =
        tile.leading != null ? _resolveVisibility(tile.leading!) : null;

    if (effectiveLeading is CircleAvatar) {
      leadingSize = (effectiveLeading.radius ?? 20) * 2;
    }

    leadingSize = leadingSize.clamp(36.0, 56.0);

    final centerY = offset.dy + size.height / 2;

    final hasLeading = tile.leading != null && !_isZeroSizeChild(tile.leading!);
    final leadingOffset = hasLeading ? leadingSize + gap : 0.0;

    if (textDirection == TextDirection.rtl) {
      final leadingX = offset.dx + size.width - horizontalPadding - leadingSize;

      if (tile.leading != null) {
        _paintWidget(
          canvas,
          tile.leading!,
          Offset(
            leadingX,
            offset.dy + (size.height - leadingSize) / 2,
          ),
          Size(leadingSize, leadingSize),
          depth: depth + 1,
        );
      }

      if (tile.trailing != null) {
        _paintWidget(
          canvas,
          tile.trailing!,
          Offset(
            offset.dx + horizontalPadding,
            offset.dy + (size.height - 24) / 2,
          ),
          const Size(24, 24),
          depth: depth + 1,
        );
      }

      final contentRight =
          hasLeading ? leadingX - gap : offset.dx + size.width - horizontalPadding;
      final contentLeft =
          tile.trailing != null && !_isZeroSizeChild(tile.trailing!)
              ? offset.dx + horizontalPadding + 32
              : offset.dx + horizontalPadding;

      final contentWidth = max(
        0.0,
        contentRight - contentLeft,
      );

      if (tile.title != null) {
        _paintWidget(
          canvas,
          tile.title!,
          Offset(
            contentLeft,
            centerY - 22,
          ),
          Size(contentWidth, 22),
          depth: depth + 1,
        );
      }

      if (tile.subtitle != null) {
        _paintWidget(
          canvas,
          tile.subtitle!,
          Offset(
            contentLeft,
            centerY + 4,
          ),
          Size(contentWidth, 20),
          depth: depth + 1,
        );
      }

      return;
    }

    if (tile.leading != null) {
      _paintWidget(
        canvas,
        tile.leading!,
        Offset(
          offset.dx + horizontalPadding,
          offset.dy + (size.height - leadingSize) / 2,
        ),
        Size(leadingSize, leadingSize),
        depth: depth + 1,
      );
    }

    final contentX = offset.dx + horizontalPadding + leadingOffset;

    final hasTrailing =
        tile.trailing != null && !_isZeroSizeChild(tile.trailing!);
    final trailingSpace = hasTrailing ? 40.0 : 0.0;

    final contentWidth = max(
      0.0,
      size.width - contentX - horizontalPadding - trailingSpace,
    );

    if (tile.title != null) {
      _paintWidget(
        canvas,
        tile.title!,
        Offset(
          contentX,
          centerY - 22,
        ),
        Size(contentWidth, 22),
        depth: depth + 1,
      );
    }

    if (tile.subtitle != null) {
      _paintWidget(
        canvas,
        tile.subtitle!,
        Offset(
          contentX,
          centerY + 4,
        ),
        Size(contentWidth, 20),
        depth: depth + 1,
      );
    }

    if (tile.trailing != null) {
      _paintWidget(
        canvas,
        tile.trailing!,
        Offset(
          offset.dx + size.width - 40,
          offset.dy + (size.height - 24) / 2,
        ),
        const Size(24, 24),
        depth: depth + 1,
      );
    }
  }
}
