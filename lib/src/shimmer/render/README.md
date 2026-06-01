# Render shimmer split

This folder splits the large `render_auto_shimmer.dart` into focused `part` files.

- `render_auto_shimmer_widget.dart` - RenderObjectWidget bridge.
- `widget_dispatcher.dart` - widget type routing.
- `basic_painters.dart` - primitive painting: rect, text, icon, circle, image, divider.
- `layout_painters.dart` - layout/widget-specific painters: row, column, list, grid, stack, card, wrap, buttons.
- `size_resolver.dart` - widget size estimation and detection helpers.
- `shimmer_paint.dart` - shimmer color, direction, and animation paint.
