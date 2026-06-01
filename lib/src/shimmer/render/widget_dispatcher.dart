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

    _paintRect(canvas, offset, availableSize, depth);
  }
}
