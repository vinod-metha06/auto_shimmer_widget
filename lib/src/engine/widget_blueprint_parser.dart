import 'package:flutter/material.dart';

import 'skeleton_blueprint.dart';
import 'skeleton_kind.dart';

class WidgetBlueprintParser {
  static List<SkeletonBlueprint> parse(Widget widget) {
    final result = <SkeletonBlueprint>[];
    _walk(widget, result, 0, 'root');
    return result;
  }

  static void _walk(
    Widget widget,
    List<SkeletonBlueprint> result,
    int depth,
    String path,
  ) {
    if (widget is Text) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.text,
          depth: depth,
          id: '$path/text',
        ),
      );
      return;
    }

    if (widget is Icon) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.icon,
          depth: depth,
          id: '$path/icon',
        ),
      );
      return;
    }

    if (widget is CircleAvatar || widget is ClipOval) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.circle,
          depth: depth,
          id: '$path/circle',
        ),
      );
      return;
    }

    if (widget is ListTile) {
      if (widget.leading != null) {
        _walk(
          widget.leading!,
          result,
          depth + 1,
          '$path/listTile/leading',
        );
      }

      if (widget.title != null) {
        _walk(
          widget.title!,
          result,
          depth + 1,
          '$path/listTile/title',
        );
      }

      if (widget.subtitle != null) {
        _walk(
          widget.subtitle!,
          result,
          depth + 1,
          '$path/listTile/subtitle',
        );
      }

      if (widget.trailing != null) {
        _walk(
          widget.trailing!,
          result,
          depth + 1,
          '$path/listTile/trailing',
        );
      }

      return;
    }

    if (widget is Row) {
      for (int i = 0; i < widget.children.length; i++) {
        _walk(
          widget.children[i],
          result,
          depth + 1,
          '$path/row/$i',
        );
      }
      return;
    }

    if (widget is Column) {
      for (int i = 0; i < widget.children.length; i++) {
        _walk(
          widget.children[i],
          result,
          depth + 1,
          '$path/column/$i',
        );
      }
      return;
    }

 if (widget is Container) {
  final constraints = widget.constraints;

  final hasDecoration =
      widget.decoration != null ||
      widget.color != null;

  final hasFixedSize = constraints != null &&
      (
        constraints.hasBoundedWidth ||
        constraints.hasBoundedHeight ||
        constraints.minWidth > 0 ||
        constraints.minHeight > 0
      );

  /// Paint button/card-like containers.
  if (hasDecoration || hasFixedSize) {
    result.add(
      SkeletonBlueprint(
        kind: SkeletonKind.rect,
        depth: depth,
        id: '$path/container',
      ),
    );
  }

  if (widget.child != null) {
    _walk(
      widget.child!,
      result,
      depth + 1,
      '$path/container/child',
    );
  }

  return;
}

    if (widget is Padding && widget.child != null) {
      _walk(
        widget.child!,
        result,
        depth + 1,
        '$path/padding',
      );
      return;
    }

    if (widget is Center && widget.child != null) {
      _walk(
        widget.child!,
        result,
        depth + 1,
        '$path/center',
      );
      return;
    }

    if (widget is Align && widget.child != null) {
      _walk(
        widget.child!,
        result,
        depth + 1,
        '$path/align',
      );
      return;
    }

    if (widget is Expanded) {
      _walk(
        widget.child,
        result,
        depth + 1,
        '$path/expanded',
      );
      return;
    }

    if (widget is Flexible) {
      _walk(
        widget.child,
        result,
        depth + 1,
        '$path/flexible',
      );
      return;
    }

    if (widget is SizedBox) {
      if (widget.child != null) {
        _walk(
          widget.child!,
          result,
          depth + 1,
          '$path/sizedBox',
        );
      }
      return;
    }
  }
}
