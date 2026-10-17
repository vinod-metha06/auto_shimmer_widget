part of '../render_auto_shimmer.dart';

extension RenderAutoShimmerSliverTablePainters on RenderAutoShimmer {
  void _paintCustomScrollView(
    Canvas canvas,
    CustomScrollView scrollView,
    Offset offset,
    Size size,
    int depth,
  ) {
    double dy = offset.dy;
    final bottom = offset.dy + size.height;

    for (final sliver in scrollView.slivers) {
      if (dy >= bottom) break;

      final remainingHeight = max(0.0, bottom - dy);
      final sliverHeight =
          _estimateWidgetHeight(sliver, remainingHeight) ??
              min(remainingHeight, 140.0);

      if (sliverHeight <= 0) continue;

      _paintWidget(
        canvas,
        sliver,
        Offset(offset.dx, dy),
        Size(size.width, min(remainingHeight, sliverHeight)),
        depth: depth + 1,
      );

      dy += sliverHeight;
    }
  }

  void _paintSliverList(
    Canvas canvas,
    SliverList sliverList,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = _extractSliverChildren(sliverList.delegate);
    final fallbackCount = _resolveBuilderItemCount(sliverList.delegate);

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

      final itemHeight = _estimateWidgetHeight(child, size.height) ?? 72.0;
      if (itemHeight <= 0) continue;

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

  void _paintSliverGrid(
    Canvas canvas,
    SliverGrid sliverGrid,
    Offset offset,
    Size size,
    int depth,
  ) {
    final children = _extractSliverChildren(sliverGrid.delegate);
    final delegate = sliverGrid.gridDelegate;

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

    final itemWidth =
        (size.width - ((crossAxisCount - 1) * crossAxisSpacing)) /
            crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;

    final itemCount = children.isEmpty
        ? _resolveBuilderItemCount(sliverGrid.delegate)
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

  void _paintSliverToBoxAdapter(
    Canvas canvas,
    SliverToBoxAdapter adapter,
    Offset offset,
    Size size,
    int depth,
  ) {
    if (adapter.child != null) {
      _paintWidget(
        canvas,
        adapter.child!,
        offset,
        size,
        depth: depth + 1,
      );
    }
  }

  void _paintSliverPadding(
    Canvas canvas,
    SliverPadding sliverPadding,
    Offset offset,
    Size size,
    int depth,
  ) {
    final padding = _resolveEdgeInsets(sliverPadding.padding);
    if (sliverPadding.child != null) {
      _paintWidget(
        canvas,
        sliverPadding.child!,
        Offset(offset.dx + padding.left, offset.dy + padding.top),
        Size(
          max(0, size.width - padding.horizontal),
          max(0, size.height - padding.vertical),
        ),
        depth: depth + 1,
      );
    }
  }

  void _paintSliverFillRemaining(
    Canvas canvas,
    SliverFillRemaining sliver,
    Offset offset,
    Size size,
    int depth,
  ) {
    if (sliver.child != null) {
      _paintWidget(
        canvas,
        sliver.child!,
        offset,
        size,
        depth: depth + 1,
      );
    }
  }

  void _paintTable(
    Canvas canvas,
    Table table,
    Offset offset,
    Size size,
    int depth,
  ) {
    final rows = table.children;
    if (rows.isEmpty) return;

    int maxCols = 0;
    for (final row in rows) {
      if (row.children.length > maxCols) {
        maxCols = row.children.length;
      }
    }

    if (maxCols == 0) return;

    final colWidth = size.width / maxCols;
    double dy = offset.dy;
    final bottom = offset.dy + size.height;

    for (int r = 0; r < rows.length; r++) {
      if (dy >= bottom) break;

      final row = rows[r];

      // Estimate row height from cells
      double rowHeight = 36.0;
      for (final cell in row.children) {
        final h = _estimateWidgetHeight(cell, size.height);
        if (h != null && h > rowHeight) {
          rowHeight = h;
        }
      }

      for (int c = 0; c < row.children.length; c++) {
        final cell = row.children[c];
        final cellX = textDirection == TextDirection.rtl
            ? offset.dx + (maxCols - 1 - c) * colWidth
            : offset.dx + c * colWidth;

        _paintWidget(
          canvas,
          cell,
          Offset(cellX + 4.0, dy + 4.0),
          Size(max(0.0, colWidth - 8.0), max(0.0, rowHeight - 8.0)),
          depth: depth + 1,
        );
      }

      // Draw subtle row divider if borders exist
      if (table.border != null && r < rows.length - 1) {
        final dividerPaint = _buildDepthPaint(depth)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawLine(
          Offset(offset.dx, dy + rowHeight),
          Offset(offset.dx + size.width, dy + rowHeight),
          dividerPaint,
        );
      }

      dy += rowHeight;
    }
  }
}
