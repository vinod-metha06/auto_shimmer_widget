part of auto_shimmer_render;

extension RenderAutoShimmerSizeResolver on RenderAutoShimmer {
  EdgeInsets _resolveEdgeInsets(EdgeInsetsGeometry? geometry) {
    if (geometry == null) return EdgeInsets.zero;
    return geometry.resolve(textDirection);
  }

  Widget? _extractImageLikeChild(Widget? widget) {
    if (widget == null) return null;

    if (this._isImageLikeWidget(widget)) return widget;

    if (widget is Center) return this._extractImageLikeChild(widget.child);
    if (widget is Align) return this._extractImageLikeChild(widget.child);
    if (widget is SizedBox) return this._extractImageLikeChild(widget.child);
    if (widget is Padding) return this._extractImageLikeChild(widget.child);
    if (widget is FittedBox) return this._extractImageLikeChild(widget.child);
    if (widget is ClipRRect) return this._extractImageLikeChild(widget.child);
    if (widget is DecoratedBox)
      return this._extractImageLikeChild(widget.child);

    return null;
  }

  bool _isImageLikeWidget(Widget widget) {
    if (widget is Image) return true;
    if (widget is FadeInImage) return true;
    if (widget is RawImage) return true;
    if (widget is ImageIcon) return true;

    if (widget is Icon) {
      final icon = widget.icon;

      return icon == Icons.image ||
          icon == Icons.image_outlined ||
          icon == Icons.photo ||
          icon == Icons.photo_outlined ||
          icon == Icons.insert_photo ||
          icon == Icons.insert_photo_outlined ||
          icon == Icons.broken_image ||
          icon == Icons.broken_image_outlined ||
          icon == Icons.landscape ||
          icon == Icons.landscape_outlined ||
          icon == Icons.collections ||
          icon == Icons.collections_outlined ||
          icon == Icons.photo_library ||
          icon == Icons.photo_library_outlined ||
          icon == Icons.image_search ||
          icon == Icons.image_search_outlined;
    }

    return false;
  }

  bool _hasDecorationImage(Container container) {
    final decoration = container.decoration;

    if (decoration is BoxDecoration) {
      return decoration.image != null;
    }

    return false;
  }

  bool _isChipLikeWidget(Widget widget) {
    return widget is Chip ||
        widget is ActionChip ||
        widget is FilterChip ||
        widget is ChoiceChip ||
        widget is InputChip;
  }

  bool _isButtonLikeWidget(Widget widget) {
    return widget is ElevatedButton ||
        widget is OutlinedButton ||
        widget is TextButton ||
        widget is IconButton ||
        widget is FloatingActionButton;
  }

  Size _estimatePositionedChildSize(
    Widget child,
    Size stackSize,
  ) {
    if (this._isButtonLikeWidget(child)) {
      return const Size(110, 48);
    }

    if (child is Text) {
      return Size(
        min(stackSize.width * 0.45, 180),
        24,
      );
    }

    if (child is Directionality) {
      return this._estimatePositionedChildSize(
        child.child,
        stackSize,
      );
    }

    if (child is Icon) {
      final size = child.size ?? 24;
      return Size.square(size);
    }

    if (child is Column) {
      final height = this._estimateColumnHeight(
        child,
        stackSize.height,
      );

      return Size(
        min(stackSize.width * 0.55, 220),
        height ?? 60,
      );
    }

    if (child is Row) {
      return Size(
        min(stackSize.width * 0.6, 240),
        this._estimateRowHeight(child),
      );
    }

    return Size(
      stackSize.width * 0.4,
      40,
    );
  }

  Size _estimateWrapChildSize(
    Widget child,
    Size parentSize,
  ) {
    if (this._isChipLikeWidget(child)) {
      return const Size(90, 36);
    }

    if (child is SizedBox) {
      return Size(
        child.width ?? 80,
        child.height ?? 36,
      );
    }

    if (child is Text) {
      return Size(
        min(parentSize.width * 0.35, 120),
        28,
      );
    }

    return const Size(80, 36);
  }

  double _estimateWrapHeight(
    Wrap wrap,
    Size parentSize,
  ) {
    double dx = 0;
    double height = 0;
    double rowHeight = 0;

    for (final child in wrap.children) {
      final childSize = this._estimateWrapChildSize(child, parentSize);

      if (dx + childSize.width > parentSize.width && dx > 0) {
        height += rowHeight + wrap.runSpacing;
        dx = 0;
        rowHeight = 0;
      }

      dx += childSize.width + wrap.spacing;
      rowHeight = max(rowHeight, childSize.height);
    }

    height += rowHeight;

    return height;
  }

  List<Widget> _extractSliverChildren(
    SliverChildDelegate delegate,
  ) {
    if (delegate is SliverChildListDelegate) {
      return delegate.children;
    }

    return const [];
  }

  int _resolveBuilderItemCount(
    SliverChildDelegate delegate,
  ) {
    if (delegate is SliverChildBuilderDelegate) {
      return delegate.estimatedChildCount ?? shimmerItemCount;
    }

    return shimmerItemCount;
  }

  Size _resolveContainerSize(
    Container container,
    Size availableSize,
  ) {
    final constraints = container.constraints;

    double width = availableSize.width;
    double height = availableSize.height;

    if (constraints != null) {
      if (constraints.hasTightWidth && constraints.minWidth.isFinite) {
        width = constraints.minWidth;
      } else if (constraints.hasBoundedWidth && constraints.maxWidth.isFinite) {
        width = min(width, constraints.maxWidth);
      }

      if (constraints.minWidth.isFinite && constraints.minWidth > 0) {
        width = max(width, constraints.minWidth);
      }

      if (constraints.hasTightHeight && constraints.minHeight.isFinite) {
        height = constraints.minHeight;
      } else if (constraints.hasBoundedHeight &&
          constraints.maxHeight.isFinite) {
        height = min(height, constraints.maxHeight);
      }

      if (constraints.minHeight.isFinite && constraints.minHeight > 0) {
        height = max(height, constraints.minHeight);
      }
    }

    if (!width.isFinite || width <= 0) {
      width = availableSize.width;
    }

    if (!height.isFinite || height <= 0) {
      height = availableSize.height;
    }

    return Size(width, height);
  }

  double? _containerWidth(
    Container container,
    double maxWidth,
  ) {
    final constraints = container.constraints;

    if (constraints == null) return null;

    if (constraints.hasTightWidth && constraints.minWidth.isFinite) {
      return constraints.minWidth;
    }

    if (constraints.hasBoundedWidth && constraints.maxWidth.isFinite) {
      return constraints.maxWidth;
    }

    if (constraints.minWidth.isFinite && constraints.minWidth > 0) {
      return constraints.minWidth;
    }

    return null;
  }

  double? _containerHeight(
    Container container,
    double maxHeight,
  ) {
    final constraints = container.constraints;

    if (constraints == null) return null;

    if (constraints.hasTightHeight && constraints.minHeight.isFinite) {
      return constraints.minHeight;
    }

    if (constraints.hasBoundedHeight && constraints.maxHeight.isFinite) {
      return constraints.maxHeight;
    }

    if (constraints.minHeight.isFinite && constraints.minHeight > 0) {
      return constraints.minHeight;
    }

    return null;
  }

  double _resolveChildWidthInRow(
    Widget child,
    double parentWidth,
    double fallback,
  ) {
    if (child is SizedBox && child.width != null) {
      return child.width!;
    }

    if (child is Container) {
      return this._containerWidth(child, parentWidth) ?? fallback;
    }

    if (child is CircleAvatar) {
      return (child.radius ?? 20) * 2;
    }

    if (child is Icon) {
      return child.size ?? 24;
    }

    if (child is Expanded || child is Flexible) {
      return fallback;
    }

    return fallback;
  }

  double? _knownColumnChildHeight(
    Widget child,
    double parentHeight,
  ) {
    return this._estimateWidgetHeight(child, parentHeight);
  }

  double? _estimateWidgetHeight(
    Widget widget,
    double parentHeight,
  ) {
    if (widget is Directionality) {
      return this._estimateWidgetHeight(
        widget.child,
        parentHeight,
      );
    }
    if (widget is SizedBox && widget.height != null) {
      return widget.height!;
    }

    if (widget is Container) {
      final margin = this._resolveEdgeInsets(widget.margin);
      final height = this._containerHeight(widget, parentHeight);

      if (height != null) {
        return height + margin.vertical;
      }

      if (widget.child != null) {
        final childHeight =
            this._estimateWidgetHeight(widget.child!, parentHeight);

        if (childHeight != null) {
          final padding = this._resolveEdgeInsets(widget.padding);
          return childHeight + padding.vertical + margin.vertical;
        }
      }

      return null;
    }

    if (widget is Card) {
      final margin = this._resolveEdgeInsets(widget.margin);

      if (widget.child != null) {
        final childHeight = this._estimateWidgetHeight(
          widget.child!,
          parentHeight,
        );

        if (childHeight != null) {
          return childHeight + margin.vertical;
        }
      }

      return null;
    }

    if (widget is Divider) {
      return widget.height ?? 16;
    }

    if (widget is TextField || widget is TextFormField) {
      return 56;
    }

    if (this._isChipLikeWidget(widget)) {
      return 36;
    }

    if (this._isButtonLikeWidget(widget)) {
      return 48;
    }

    if (widget is RichText) {
      final lines = widget.maxLines ?? 1;
      return (lines * 16) + ((lines - 1) * 6);
    }

    if (widget is Text) {
      return 24;
    }

    if (widget is Icon) {
      return widget.size ?? 24;
    }

    if (widget is AspectRatio) {
      final height = parentHeight.isFinite ? min(parentHeight, 220.0) : 180.0;
      return height;
    }

    if (widget is Wrap) {
      return this._estimateWrapHeight(
        widget,
        Size(size.width, parentHeight),
      );
    }

    if (widget is Row) {
      return this._estimateRowHeight(widget);
    }

    if (widget is Column) {
      return this._estimateColumnHeight(widget, parentHeight);
    }

    if (widget is Padding) {
      final padding = this._resolveEdgeInsets(widget.padding);

      if (widget.child == null) {
        return padding.vertical;
      }

      final childHeight = this._estimateWidgetHeight(
        widget.child!,
        max(0, parentHeight - padding.vertical),
      );

      if (childHeight == null) return null;

      return childHeight + padding.vertical;
    }

    if (widget is Expanded) {
      return this._estimateWidgetHeight(widget.child, parentHeight);
    }

    if (widget is Flexible) {
      return this._estimateWidgetHeight(widget.child, parentHeight);
    }

    if (widget is Center && widget.child != null) {
      return this._estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is Align && widget.child != null) {
      return this._estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is Material && widget.child != null) {
      return this._estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is InkWell && widget.child != null) {
      return this._estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is GestureDetector && widget.child != null) {
      return this._estimateWidgetHeight(widget.child!, parentHeight);
    }

    return null;
  }

  double? _estimateColumnHeight(
    Column column,
    double parentHeight,
  ) {
    double total = 0;

    for (final child in column.children) {
      final childHeight = this._estimateWidgetHeight(
            child,
            parentHeight,
          ) ??
          this._estimateRowChildHeight(child) ??
          48.0;

      total += childHeight;
    }

    return total;
  }

  double _estimateRowHeight(Row row) {
    double maxHeight = 0;

    for (final child in row.children) {
      final height = this._estimateRowChildHeight(child);

      if (height != null) {
        maxHeight = max(maxHeight, height);
      }
    }

    return maxHeight == 0 ? 48 : maxHeight;
  }

  double? _estimateRowChildHeight(Widget child) {
    if (child is Directionality) {
      return this._estimateRowChildHeight(
        child.child,
      );
    }
    if (child is CircleAvatar) {
      return (child.radius ?? 20) * 2;
    }

    if (child is Icon) {
      return child.size ?? 24;
    }

    if (child is SizedBox && child.height != null) {
      return child.height!;
    }

    if (child is Container) {
      final margin = this._resolveEdgeInsets(child.margin);
      final height = this._containerHeight(child, double.infinity);

      if (height != null) {
        return height + margin.vertical;
      }

      if (child.child != null) {
        final childHeight = this._estimateWidgetHeight(
          child.child!,
          double.infinity,
        );

        if (childHeight != null) {
          final padding = this._resolveEdgeInsets(child.padding);
          return childHeight + padding.vertical + margin.vertical;
        }
      }

      return null;
    }

    if (child is Column) {
      return this._estimateColumnHeight(child, double.infinity);
    }

    if (child is Wrap) {
      return this._estimateWrapHeight(child, Size(size.width, double.infinity));
    }

    if (child is RichText) {
      final lines = child.maxLines ?? 1;
      return (lines * 16) + ((lines - 1) * 6);
    }

    if (this._isChipLikeWidget(child)) {
      return 36;
    }

    if (this._isButtonLikeWidget(child)) {
      return 48;
    }

    if (child is Padding) {
      final padding = this._resolveEdgeInsets(child.padding);

      if (child.child == null) {
        return padding.vertical;
      }

      final inner = this._estimateRowChildHeight(child.child!);

      if (inner == null) return null;

      return inner + padding.vertical;
    }

    if (child is Expanded) {
      return this._estimateRowChildHeight(child.child);
    }

    if (child is Flexible) {
      return this._estimateRowChildHeight(child.child);
    }

    if (child is Center && child.child != null) {
      return this._estimateRowChildHeight(child.child!);
    }

    if (child is Align && child.child != null) {
      return this._estimateRowChildHeight(child.child!);
    }

    return null;
  }

  BorderRadius _extractContainerRadius(Container container) {
    final decoration = container.decoration;

    if (decoration is BoxDecoration) {
      final borderRadius = decoration.borderRadius;

      if (borderRadius is BorderRadius) {
        return borderRadius;
      }
    }

    return BorderRadius.circular(12);
  }
}
