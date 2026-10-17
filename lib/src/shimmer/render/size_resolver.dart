part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerSizeResolver on RenderAutoShimmer {
  EdgeInsets _resolveEdgeInsets(EdgeInsetsGeometry? geometry) {
    if (geometry == null) return EdgeInsets.zero;
    return geometry.resolve(textDirection);
  }

  Widget? _extractImageLikeChild(Widget? widget) {
    if (widget == null) return null;

    if (_isImageLikeWidget(widget)) return widget;

    if (widget is Visibility) {
      if (widget.visible) {
        return _extractImageLikeChild(widget.child);
      } else if (!widget.maintainSize) {
        return _extractImageLikeChild(widget.replacement);
      }
      return null;
    }

    if (widget is Center) return _extractImageLikeChild(widget.child);
    if (widget is Align) return _extractImageLikeChild(widget.child);
    if (widget is SizedBox) return _extractImageLikeChild(widget.child);
    if (widget is Padding) return _extractImageLikeChild(widget.child);
    if (widget is FittedBox) return _extractImageLikeChild(widget.child);
    if (widget is ClipRRect) return _extractImageLikeChild(widget.child);
    if (widget is ClipRect) return _extractImageLikeChild(widget.child);
    if (widget is SafeArea) return _extractImageLikeChild(widget.child);
    if (widget is Opacity) {
      return widget.opacity > 0 ? _extractImageLikeChild(widget.child) : null;
    }
    if (widget is AnimatedOpacity) {
      return widget.opacity > 0 ? _extractImageLikeChild(widget.child) : null;
    }
    if (widget is Offstage) {
      return !widget.offstage ? _extractImageLikeChild(widget.child) : null;
    }
    if (widget is ConstrainedBox) return _extractImageLikeChild(widget.child);
    if (widget is FractionallySizedBox) {
      return _extractImageLikeChild(widget.child);
    }
    if (widget is LimitedBox) return _extractImageLikeChild(widget.child);
    if (widget is DecoratedBox) {
      return _extractImageLikeChild(widget.child);
    }
    if (widget is Badge) {
      return _extractImageLikeChild(widget.child);
    }

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
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _estimatePositionedChildSize(
          child.child,
          stackSize,
        );
      } else {
        return _estimatePositionedChildSize(
          child.replacement,
          stackSize,
        );
      }
    }

    if (child is SafeArea) {
      return _estimatePositionedChildSize(child.child, stackSize);
    }
    if (child is Opacity) {
      if (child.opacity <= 0 || child.child == null) return Size.zero;
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is AnimatedOpacity) {
      if (child.opacity <= 0 || child.child == null) return Size.zero;
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is Offstage) {
      if (child.offstage || child.child == null) return Size.zero;
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is Spacer) {
      return Size.zero;
    }
    if (child is ConstrainedBox && child.child != null) {
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is FractionallySizedBox && child.child != null) {
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is LimitedBox && child.child != null) {
      return _estimatePositionedChildSize(child.child!, stackSize);
    }
    if (child is ClipRect && child.child != null) {
      return _estimatePositionedChildSize(child.child!, stackSize);
    }

    if (child is SizedBox) {
      if (child.width == 0 && child.height == 0) {
        return Size.zero;
      }
      return Size(
        child.width ??
            (child.child != null
                ? _estimatePositionedChildSize(child.child!, stackSize).width
                : stackSize.width * 0.4),
        child.height ??
            (child.child != null
                ? _estimatePositionedChildSize(child.child!, stackSize).height
                : 40),
      );
    }

    if (_isButtonLikeWidget(child)) {
      return const Size(110, 48);
    }

    if (child is Checkbox) {
      return const Size(24, 24);
    }

    if (child is Switch) {
      return const Size(48, 28);
    }

    if (child is Radio) {
      return const Size(24, 24);
    }

    if (child is Slider || child is RangeSlider) {
      return Size(
        min(stackSize.width * 0.6, 200),
        40,
      );
    }

    if (child is DropdownButton) {
      return Size(
        min(stackSize.width * 0.45, 140),
        48,
      );
    }

    if (child is DropdownMenu) {
      return Size(
        min(stackSize.width * 0.55, 180),
        56,
      );
    }

    if (child is AppBar) {
      return Size(stackSize.width, child.preferredSize.height);
    }

    if (child is TabBar) {
      return Size(stackSize.width, child.preferredSize.height);
    }

    if (child is Tab) {
      return const Size(80, 48);
    }

    if (child is Badge) {
      return child.child != null
          ? _estimatePositionedChildSize(child.child!, stackSize)
          : const Size(24, 24);
    }

    if (child is ExpansionTile) {
      return Size(stackSize.width, child.subtitle != null ? 72 : 56);
    }

    if (child is Placeholder) {
      return Size(
        min(stackSize.width, child.fallbackWidth),
        min(stackSize.height, child.fallbackHeight),
      );
    }

    if (child is Text) {
      return Size(
        min(stackSize.width * 0.45, 180),
        24,
      );
    }

    if (child is Directionality) {
      return _estimatePositionedChildSize(
        child.child,
        stackSize,
      );
    }

    if (child is Icon) {
      final size = child.size ?? 24;
      return Size.square(size);
    }

    if (child is Column) {
      final height = _estimateColumnHeight(
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
        _estimateRowHeight(child),
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
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _estimateWrapChildSize(child.child, parentSize);
      } else {
        return _estimateWrapChildSize(child.replacement, parentSize);
      }
    }

    if (child is SafeArea) {
      return _estimateWrapChildSize(child.child, parentSize);
    }
    if (child is Opacity) {
      if (child.opacity <= 0 || child.child == null) return Size.zero;
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is AnimatedOpacity) {
      if (child.opacity <= 0 || child.child == null) return Size.zero;
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is Offstage) {
      if (child.offstage || child.child == null) return Size.zero;
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is Spacer) {
      return Size.zero;
    }
    if (child is ConstrainedBox && child.child != null) {
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is FractionallySizedBox && child.child != null) {
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is LimitedBox && child.child != null) {
      return _estimateWrapChildSize(child.child!, parentSize);
    }
    if (child is ClipRect && child.child != null) {
      return _estimateWrapChildSize(child.child!, parentSize);
    }

    if (_isChipLikeWidget(child)) {
      return const Size(90, 36);
    }

    if (child is Checkbox) {
      return const Size(36, 36);
    }

    if (child is Switch) {
      return const Size(54, 36);
    }

    if (child is Radio) {
      return const Size(36, 36);
    }

    if (child is Slider || child is RangeSlider) {
      return Size(min(parentSize.width * 0.6, 180), 40);
    }

    if (child is DropdownButton) {
      return Size(min(parentSize.width * 0.45, 140), 48);
    }

    if (child is DropdownMenu) {
      return Size(min(parentSize.width * 0.55, 180), 56);
    }

    if (child is Tab) {
      return const Size(80, 48);
    }

    if (child is Badge) {
      return child.child != null
          ? _estimateWrapChildSize(child.child!, parentSize)
          : const Size(24, 24);
    }

    if (child is Placeholder) {
      return Size(min(parentSize.width * 0.4, child.fallbackWidth), 40);
    }

    if (child is SizedBox) {
      if (child.width == 0 && child.height == 0) {
        return Size.zero;
      }
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
      final childSize = _estimateWrapChildSize(child, parentSize);

      if (childSize.width <= 0 && childSize.height <= 0) {
        continue;
      }

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
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _resolveChildWidthInRow(child.child, parentWidth, fallback);
      } else {
        return _resolveChildWidthInRow(child.replacement, parentWidth, 0.0);
      }
    }

    if (child is SafeArea) {
      return _resolveChildWidthInRow(child.child, parentWidth, fallback);
    }
    if (child is Opacity) {
      if (child.opacity <= 0 || child.child == null) return 0.0;
      return _resolveChildWidthInRow(child.child!, parentWidth, fallback);
    }
    if (child is AnimatedOpacity) {
      if (child.opacity <= 0 || child.child == null) return 0.0;
      return _resolveChildWidthInRow(child.child!, parentWidth, fallback);
    }
    if (child is Offstage) {
      if (child.offstage || child.child == null) return 0.0;
      return _resolveChildWidthInRow(child.child!, parentWidth, fallback);
    }
    if (child is Spacer) {
      return fallback * child.flex;
    }
    if (child is Expanded) {
      return fallback * child.flex;
    }
    if (child is Flexible) {
      return fallback * child.flex;
    }
    if (child is FractionallySizedBox && child.child != null) {
      final widthFactor = child.widthFactor ?? 1.0;
      return parentWidth * widthFactor;
    }
    if (child is ConstrainedBox && child.child != null) {
      final constraints = child.constraints;
      final innerWidth =
          _resolveChildWidthInRow(child.child!, parentWidth, fallback);
      if (constraints.hasTightWidth) return constraints.minWidth;
      return innerWidth
          .clamp(constraints.minWidth, constraints.maxWidth)
          .toDouble();
    }
    if (child is LimitedBox && child.child != null) {
      return _resolveChildWidthInRow(child.child!, parentWidth, fallback);
    }
    if (child is ClipRect && child.child != null) {
      return _resolveChildWidthInRow(child.child!, parentWidth, fallback);
    }

    if (child is SizedBox && child.width != null) {
      return child.width!;
    }

    if (child is Container) {
      return _containerWidth(child, parentWidth) ?? fallback;
    }

    if (child is CircleAvatar) {
      return (child.radius ?? 20) * 2;
    }

    if (child is Icon) {
      return child.size ?? 24;
    }

    if (child is Checkbox) {
      return 24.0;
    }

    if (child is Switch) {
      return 48.0;
    }

    if (child is Radio) {
      return 24.0;
    }

    if (child is DropdownButton) {
      return min(parentWidth * 0.45, 140.0);
    }

    if (child is DropdownMenu) {
      return min(parentWidth * 0.55, 180.0);
    }

    if (child is Tab) {
      return 60.0;
    }

    if (child is Badge) {
      return child.child != null
          ? _resolveChildWidthInRow(child.child!, parentWidth, fallback)
          : 24.0;
    }

    if (child is Placeholder) {
      return min(parentWidth, child.fallbackWidth);
    }

    return fallback;
  }

  double? _knownColumnChildHeight(
    Widget child,
    double parentHeight,
  ) {
    return _estimateWidgetHeight(child, parentHeight);
  }

  double? _estimateWidgetHeight(
    Widget widget,
    double parentHeight,
  ) {
    if (widget is Visibility) {
      if (widget.visible || widget.maintainSize) {
        return _estimateWidgetHeight(
          widget.child,
          parentHeight,
        );
      } else {
        return _estimateWidgetHeight(
          widget.replacement,
          parentHeight,
        );
      }
    }

    if (widget is SafeArea) {
      return _estimateWidgetHeight(widget.child, parentHeight);
    }
    if (widget is Opacity) {
      if (widget.opacity <= 0 || widget.child == null) return 0.0;
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }
    if (widget is AnimatedOpacity) {
      if (widget.opacity <= 0 || widget.child == null) return 0.0;
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }
    if (widget is Offstage) {
      if (widget.offstage || widget.child == null) return 0.0;
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }
    if (widget is Spacer) {
      return null;
    }
    if (widget is FractionallySizedBox && widget.child != null) {
      if (widget.heightFactor != null && parentHeight.isFinite) {
        return parentHeight * widget.heightFactor!;
      }
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }
    if (widget is ConstrainedBox && widget.child != null) {
      final constraints = widget.constraints;
      final inner = _estimateWidgetHeight(widget.child!, parentHeight);
      if (constraints.hasTightHeight) return constraints.minHeight;
      if (inner != null) {
        return inner
            .clamp(constraints.minHeight, constraints.maxHeight)
            .toDouble();
      }
      return constraints.minHeight > 0 ? constraints.minHeight : null;
    }
    if (widget is LimitedBox && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }
    if (widget is ClipRect && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is Directionality) {
      return _estimateWidgetHeight(
        widget.child,
        parentHeight,
      );
    }
    if (widget is SizedBox && widget.height != null) {
      return widget.height!;
    }

    if (widget is Container) {
      final margin = _resolveEdgeInsets(widget.margin);
      final height = _containerHeight(widget, parentHeight);

      if (height != null) {
        return height + margin.vertical;
      }

      if (widget.child != null) {
        final childHeight = _estimateWidgetHeight(widget.child!, parentHeight);

        if (childHeight != null) {
          final padding = _resolveEdgeInsets(widget.padding);
          return childHeight + padding.vertical + margin.vertical;
        }
      }

      return null;
    }

    if (widget is Card) {
      final margin = _resolveEdgeInsets(widget.margin);

      if (widget.child != null) {
        final childHeight = _estimateWidgetHeight(
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

    if (widget is Checkbox) {
      return 40;
    }

    if (widget is CheckboxListTile) {
      return widget.subtitle != null ? 72 : 56;
    }

    if (widget is Switch) {
      return 40;
    }

    if (widget is SwitchListTile) {
      return widget.subtitle != null ? 72 : 56;
    }

    if (widget is Radio) {
      return 40;
    }

    if (widget is RadioListTile) {
      return widget.subtitle != null ? 72 : 56;
    }

    if (widget is Slider || widget is RangeSlider) {
      return 44;
    }

    if (widget is DropdownButton) {
      return 48;
    }

    if (widget is DropdownMenu) {
      return 56;
    }

    if (widget is AppBar) {
      return widget.preferredSize.height;
    }

    if (widget is SliverAppBar) {
      return widget.expandedHeight ??
          (widget.toolbarHeight +
              (widget.bottom?.preferredSize.height ?? 0.0));
    }

    if (widget is TabBar) {
      return widget.preferredSize.height;
    }

    if (widget is Tab) {
      return 48;
    }

    if (widget is Badge) {
      return widget.child != null
          ? _estimateWidgetHeight(widget.child!, parentHeight)
          : 24;
    }

    if (widget is ExpansionTile) {
      return widget.subtitle != null ? 72 : 56;
    }

    if (widget is Placeholder) {
      return parentHeight.isFinite
          ? min(parentHeight, widget.fallbackHeight)
          : widget.fallbackHeight;
    }

    if (_isChipLikeWidget(widget)) {
      return 36;
    }

    if (_isButtonLikeWidget(widget)) {
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
      return _estimateWrapHeight(
        widget,
        Size(size.width, parentHeight),
      );
    }

    if (widget is Row) {
      return _estimateRowHeight(widget);
    }

    if (widget is Column) {
      return _estimateColumnHeight(widget, parentHeight);
    }

    if (widget is Padding) {
      final padding = _resolveEdgeInsets(widget.padding);

      if (widget.child == null) {
        return padding.vertical;
      }

      final childHeight = _estimateWidgetHeight(
        widget.child!,
        max(0, parentHeight - padding.vertical),
      );

      if (childHeight == null) return null;

      return childHeight + padding.vertical;
    }

    if (widget is Expanded) {
      return _estimateWidgetHeight(widget.child, parentHeight);
    }

    if (widget is Flexible) {
      return _estimateWidgetHeight(widget.child, parentHeight);
    }

    if (widget is Center && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is Align && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is Material && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is InkWell && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    if (widget is GestureDetector && widget.child != null) {
      return _estimateWidgetHeight(widget.child!, parentHeight);
    }

    return null;
  }

  double? _estimateColumnHeight(
    Column column,
    double parentHeight,
  ) {
    double total = 0;

    for (final child in column.children) {
      final childHeight = _estimateWidgetHeight(
            child,
            parentHeight,
          ) ??
          _estimateRowChildHeight(child) ??
          48.0;

      total += childHeight;
    }

    return total;
  }

  double _estimateRowHeight(Row row) {
    double maxHeight = 0;

    for (final child in row.children) {
      final height = _estimateRowChildHeight(child);

      if (height != null) {
        maxHeight = max(maxHeight, height);
      }
    }

    return maxHeight == 0 ? 48 : maxHeight;
  }

  double? _estimateRowChildHeight(Widget child) {
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _estimateRowChildHeight(child.child);
      } else {
        return _estimateRowChildHeight(child.replacement);
      }
    }

    if (child is SafeArea) {
      return _estimateRowChildHeight(child.child);
    }
    if (child is Opacity) {
      if (child.opacity <= 0 || child.child == null) return 0.0;
      return _estimateRowChildHeight(child.child!);
    }
    if (child is AnimatedOpacity) {
      if (child.opacity <= 0 || child.child == null) return 0.0;
      return _estimateRowChildHeight(child.child!);
    }
    if (child is Offstage) {
      if (child.offstage || child.child == null) return 0.0;
      return _estimateRowChildHeight(child.child!);
    }
    if (child is Spacer) {
      return 0.0;
    }
    if (child is FractionallySizedBox && child.child != null) {
      return _estimateRowChildHeight(child.child!);
    }
    if (child is ConstrainedBox && child.child != null) {
      final constraints = child.constraints;
      final inner = _estimateRowChildHeight(child.child!);
      if (constraints.hasTightHeight) return constraints.minHeight;
      if (inner != null) {
        return inner
            .clamp(constraints.minHeight, constraints.maxHeight)
            .toDouble();
      }
      return constraints.minHeight > 0 ? constraints.minHeight : null;
    }
    if (child is LimitedBox && child.child != null) {
      return _estimateRowChildHeight(child.child!);
    }
    if (child is ClipRect && child.child != null) {
      return _estimateRowChildHeight(child.child!);
    }

    if (child is Directionality) {
      return _estimateRowChildHeight(
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
      final margin = _resolveEdgeInsets(child.margin);
      final height = _containerHeight(child, double.infinity);

      if (height != null) {
        return height + margin.vertical;
      }

      if (child.child != null) {
        final childHeight = _estimateWidgetHeight(
          child.child!,
          double.infinity,
        );

        if (childHeight != null) {
          final padding = _resolveEdgeInsets(child.padding);
          return childHeight + padding.vertical + margin.vertical;
        }
      }

      return null;
    }

    if (child is Column) {
      return _estimateColumnHeight(child, double.infinity);
    }

    if (child is Wrap) {
      return _estimateWrapHeight(child, Size(size.width, double.infinity));
    }

    if (child is RichText) {
      final lines = child.maxLines ?? 1;
      return (lines * 16) + ((lines - 1) * 6);
    }

    if (_isChipLikeWidget(child)) {
      return 36;
    }

    if (_isButtonLikeWidget(child)) {
      return 48;
    }

    if (child is Checkbox) {
      return 24;
    }

    if (child is Switch) {
      return 32;
    }

    if (child is Radio) {
      return 24;
    }

    if (child is Slider || child is RangeSlider) {
      return 40;
    }

    if (child is DropdownButton) {
      return 48;
    }

    if (child is DropdownMenu) {
      return 56;
    }

    if (child is Tab) {
      return 48;
    }

    if (child is Badge) {
      return child.child != null ? _estimateRowChildHeight(child.child!) : 24;
    }

    if (child is Placeholder) {
      return min(48.0, child.fallbackHeight);
    }

    if (child is Padding) {
      final padding = _resolveEdgeInsets(child.padding);

      if (child.child == null) {
        return padding.vertical;
      }

      final inner = _estimateRowChildHeight(child.child!);

      if (inner == null) return null;

      return inner + padding.vertical;
    }

    if (child is Expanded) {
      return _estimateRowChildHeight(child.child);
    }

    if (child is Flexible) {
      return _estimateRowChildHeight(child.child);
    }

    if (child is Center && child.child != null) {
      return _estimateRowChildHeight(child.child!);
    }

    if (child is Align && child.child != null) {
      return _estimateRowChildHeight(child.child!);
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

  Widget _resolveVisibility(Widget widget) {
    if (widget is Visibility) {
      if (widget.visible || widget.maintainSize) {
        return _resolveVisibility(widget.child);
      } else {
        return _resolveVisibility(widget.replacement);
      }
    }
    if (widget is Offstage) {
      if (!widget.offstage && widget.child != null) {
        return _resolveVisibility(widget.child!);
      }
      return const SizedBox.shrink();
    }
    if (widget is Opacity) {
      if (widget.opacity > 0 && widget.child != null) {
        return _resolveVisibility(widget.child!);
      }
      return const SizedBox.shrink();
    }
    if (widget is AnimatedOpacity) {
      if (widget.opacity > 0 && widget.child != null) {
        return _resolveVisibility(widget.child!);
      }
      return const SizedBox.shrink();
    }
    if (widget is SafeArea) {
      return _resolveVisibility(widget.child);
    }
    if (widget is ClipRect && widget.child != null) {
      return _resolveVisibility(widget.child!);
    }
    if (widget is ConstrainedBox && widget.child != null) {
      return _resolveVisibility(widget.child!);
    }
    if (widget is LimitedBox && widget.child != null) {
      return _resolveVisibility(widget.child!);
    }
    return widget;
  }

  bool _isZeroSizeChild(Widget child) {
    if (child is Visibility) {
      if (child.visible || child.maintainSize) {
        return _isZeroSizeChild(child.child);
      } else {
        return _isZeroSizeChild(child.replacement);
      }
    }
    if (child is Offstage) {
      return child.offstage ||
          child.child == null ||
          _isZeroSizeChild(child.child!);
    }
    if (child is Opacity) {
      return child.opacity <= 0.0 ||
          child.child == null ||
          _isZeroSizeChild(child.child!);
    }
    if (child is AnimatedOpacity) {
      return child.opacity <= 0.0 ||
          child.child == null ||
          _isZeroSizeChild(child.child!);
    }
    if (child is SafeArea) {
      return _isZeroSizeChild(child.child);
    }
    if (child is ClipRect && child.child != null) {
      return _isZeroSizeChild(child.child!);
    }
    if (child is SizedBox) {
      return (child.width == 0.0 || child.height == 0.0) && child.child == null;
    }
    return false;
  }
}
