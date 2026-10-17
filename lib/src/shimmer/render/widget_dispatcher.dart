part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerWidgetDispatcher on RenderAutoShimmer {
  void _paintWidget(
    Canvas canvas,
    Widget widget,
    Offset offset,
    Size availableSize, {
    required int depth,
  }) {
    if (!availableSize.width.isFinite ||
        !availableSize.height.isFinite ||
        availableSize.width <= 0 ||
        availableSize.height <= 0) {
      return;
    }

    if (widget is Directionality) {
      final oldTextDirection = textDirection;

      textDirection = widget.textDirection;

      _paintWidget(
        canvas,
        widget.child,
        offset,
        availableSize,
        depth: depth + 1,
      );

      textDirection = oldTextDirection;

      return;
    }

    if (widget is Visibility) {
      if (widget.visible) {
        _paintWidget(
          canvas,
          widget.child,
          offset,
          availableSize,
          depth: depth + 1,
        );
      } else if (!widget.maintainSize) {
        _paintWidget(
          canvas,
          widget.replacement,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is SafeArea) {
      final insets = widget.minimum.resolve(textDirection);
      _paintWidget(
        canvas,
        widget.child,
        Offset(offset.dx + insets.left, offset.dy + insets.top),
        Size(
          max(0, availableSize.width - insets.horizontal),
          max(0, availableSize.height - insets.vertical),
        ),
        depth: depth + 1,
      );
      return;
    }

    if (widget is Opacity) {
      if (widget.opacity <= 0.0) return;
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is AnimatedOpacity) {
      if (widget.opacity <= 0.0) return;
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is Offstage) {
      if (widget.offstage) return;
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is Spacer) {
      return;
    }

    if (widget is ConstrainedBox) {
      if (widget.child != null) {
        final constraints = widget.constraints;
        double width = availableSize.width;
        double height = availableSize.height;

        if (constraints.hasTightWidth) {
          width = constraints.minWidth;
        } else if (constraints.hasBoundedWidth) {
          width = width
              .clamp(constraints.minWidth, constraints.maxWidth)
              .toDouble();
        }

        if (constraints.hasTightHeight) {
          height = constraints.minHeight;
        } else if (constraints.hasBoundedHeight) {
          height = height
              .clamp(constraints.minHeight, constraints.maxHeight)
              .toDouble();
        }

        _paintWidget(
          canvas,
          widget.child!,
          offset,
          Size(width, height),
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is FractionallySizedBox) {
      if (widget.child != null) {
        final widthFactor = widget.widthFactor ?? 1.0;
        final heightFactor = widget.heightFactor ?? 1.0;
        final childWidth = availableSize.width * widthFactor;
        final childHeight = availableSize.height * heightFactor;

        final alignment = widget.alignment.resolve(textDirection);
        final dx = offset.dx +
            (availableSize.width - childWidth) * ((alignment.x + 1) / 2);
        final dy = offset.dy +
            (availableSize.height - childHeight) * ((alignment.y + 1) / 2);

        _paintWidget(
          canvas,
          widget.child!,
          Offset(dx, dy),
          Size(childWidth, childHeight),
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is LimitedBox) {
      if (widget.child != null) {
        double width = availableSize.width;
        double height = availableSize.height;

        if (!width.isFinite || width > widget.maxWidth) {
          width = widget.maxWidth;
        }
        if (!height.isFinite || height > widget.maxHeight) {
          height = widget.maxHeight;
        }

        _paintWidget(
          canvas,
          widget.child!,
          offset,
          Size(width, height),
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is ClipRect) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is Text) {
      _paintText(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is RichText) {
      _paintRichText(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is TextField || widget is TextFormField) {
      _paintTextField(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is Checkbox) {
      _paintCheckbox(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is CheckboxListTile) {
      _paintCheckboxListTile(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Switch) {
      _paintSwitch(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is SwitchListTile) {
      _paintSwitchListTile(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Radio) {
      _paintRadio(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is RadioListTile) {
      _paintRadioListTile(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Slider) {
      _paintSlider(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is RangeSlider) {
      _paintRangeSlider(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is DropdownButton) {
      _paintDropdownButton(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is DropdownMenu) {
      _paintDropdownMenu(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (_isImageLikeWidget(widget)) {
      _paintImagePlaceholder(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is Icon) {
      _paintIcon(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is CircleAvatar || widget is ClipOval) {
      _paintCircle(canvas, offset, availableSize, depth);
      return;
    }

    if (widget is Divider) {
      _paintDivider(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is VerticalDivider) {
      _paintVerticalDivider(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (_isButtonLikeWidget(widget)) {
      _paintButtonLike(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (_isChipLikeWidget(widget)) {
      _paintChipLike(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is ListTile) {
      _paintListTile(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is ExpansionTile) {
      _paintExpansionTile(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is AppBar) {
      _paintAppBar(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverAppBar) {
      _paintSliverAppBar(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is TabBar) {
      _paintTabBar(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Tab) {
      _paintTab(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Badge) {
      _paintBadge(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Placeholder) {
      _paintPlaceholder(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Padding) {
      final padding = _resolveEdgeInsets(widget.padding);

      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          Offset(offset.dx + padding.left, offset.dy + padding.top),
          Size(
            max(0, availableSize.width - padding.horizontal),
            max(0, availableSize.height - padding.vertical),
          ),
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is Container) {
      final margin = _resolveEdgeInsets(widget.margin);

      final outerSize = _resolveContainerSize(
        widget,
        availableSize,
      );

      final containerSize = Size(
        max(0, outerSize.width - margin.horizontal),
        max(0, outerSize.height - margin.vertical),
      );

      final containerOffset = Offset(
        offset.dx + margin.left,
        offset.dy + margin.top,
      );

      final hasVisualDecoration =
          widget.color != null || widget.decoration != null;

      final shouldPaintContainer = hasVisualDecoration || widget.child == null;

      final imageChild = _extractImageLikeChild(widget.child);
      final hasDecorationImage = _hasDecorationImage(widget);

      final isImagePlaceholderContainer =
          (imageChild != null || hasDecorationImage) &&
              containerSize.width.isFinite &&
              containerSize.height.isFinite &&
              containerSize.width >= 40;

      if (isImagePlaceholderContainer) {
        final safeSize = Size(
          containerSize.width,
          containerSize.height < 80 ? 140 : containerSize.height,
        );

        _paintImagePlaceholder(
          canvas,
          containerOffset,
          safeSize,
          depth + 2,
          radius: _extractContainerRadius(widget),
        );

        return;
      }

      if (shouldPaintContainer) {
        _paintRect(
          canvas,
          containerOffset,
          containerSize,
          depth,
          radius: _extractContainerRadius(widget),
        );
      }

      if (widget.child != null) {
        final padding = _resolveEdgeInsets(widget.padding);

        _paintWidget(
          canvas,
          widget.child!,
          Offset(
            containerOffset.dx + padding.left,
            containerOffset.dy + padding.top,
          ),
          Size(
            max(0, containerSize.width - padding.horizontal),
            max(0, containerSize.height - padding.vertical),
          ),
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is SizedBox) {
      final childSize = Size(
        widget.width ?? availableSize.width,
        widget.height ?? availableSize.height,
      );

      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          childSize,
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is Center) {
      if (widget.child != null) {
        final childSize = Size(
          availableSize.width * 0.7,
          availableSize.height * 0.7,
        );

        final childOffset = Offset(
          offset.dx + (availableSize.width - childSize.width) / 2,
          offset.dy + (availableSize.height - childSize.height) / 2,
        );

        _paintWidget(
          canvas,
          widget.child!,
          childOffset,
          childSize,
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is Align) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is FittedBox) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is ClipRRect) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }

      return;
    }

    if (widget is DecoratedBox) {
      _paintRect(canvas, offset, availableSize, depth);

      _paintWidget(
        canvas,
        widget.child!,
        offset,
        availableSize,
        depth: depth + 1,
      );

      return;
    }

    if (widget is Card) {
      _paintCard(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Material) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is InkWell) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is GestureDetector) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is SingleChildScrollView) {
      if (widget.child != null) {
        _paintWidget(
          canvas,
          widget.child!,
          offset,
          availableSize,
          depth: depth + 1,
        );
      }
      return;
    }

    if (widget is AspectRatio) {
      _paintAspectRatio(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Stack) {
      _paintStack(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Wrap) {
      _paintWrap(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Expanded) {
      _paintWidget(
        canvas,
        widget.child,
        offset,
        availableSize,
        depth: depth + 1,
      );
      return;
    }

    if (widget is Flexible) {
      _paintWidget(
        canvas,
        widget.child,
        offset,
        availableSize,
        depth: depth + 1,
      );
      return;
    }

    if (widget is Row) {
      _paintRow(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Column) {
      _paintColumn(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is ListView) {
      _paintListView(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is GridView) {
      _paintGridView(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is CustomScrollView) {
      _paintCustomScrollView(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverList) {
      _paintSliverList(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverGrid) {
      _paintSliverGrid(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverToBoxAdapter) {
      _paintSliverToBoxAdapter(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverPadding) {
      _paintSliverPadding(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is SliverFillRemaining) {
      _paintSliverFillRemaining(canvas, widget, offset, availableSize, depth);
      return;
    }

    if (widget is Table) {
      _paintTable(canvas, widget, offset, availableSize, depth);
      return;
    }

    _paintRect(canvas, offset, availableSize, depth);
  }
}
