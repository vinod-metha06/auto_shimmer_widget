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
    if (widget is Visibility) {
      if (widget.visible) {
        _walk(
          widget.child,
          result,
          depth + 1,
          '$path/visibility/child',
        );
      } else if (!widget.maintainSize) {
        _walk(
          widget.replacement,
          result,
          depth + 1,
          '$path/visibility/replacement',
        );
      }
      return;
    }

    if (widget is SafeArea) {
      _walk(widget.child, result, depth + 1, '$path/safeArea');
      return;
    }

    if (widget is Opacity) {
      if (widget.opacity > 0 && widget.child != null) {
        _walk(widget.child!, result, depth + 1, '$path/opacity');
      }
      return;
    }

    if (widget is AnimatedOpacity) {
      if (widget.opacity > 0 && widget.child != null) {
        _walk(widget.child!, result, depth + 1, '$path/animatedOpacity');
      }
      return;
    }

    if (widget is Offstage) {
      if (!widget.offstage && widget.child != null) {
        _walk(widget.child!, result, depth + 1, '$path/offstage');
      }
      return;
    }

    if (widget is Spacer) {
      return;
    }

    if (widget is ConstrainedBox && widget.child != null) {
      _walk(widget.child!, result, depth + 1, '$path/constrainedBox');
      return;
    }

    if (widget is FractionallySizedBox && widget.child != null) {
      _walk(widget.child!, result, depth + 1, '$path/fractionallySizedBox');
      return;
    }

    if (widget is LimitedBox && widget.child != null) {
      _walk(widget.child!, result, depth + 1, '$path/limitedBox');
      return;
    }

    if (widget is ClipRect && widget.child != null) {
      _walk(widget.child!, result, depth + 1, '$path/clipRect');
      return;
    }

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

    if (widget is Checkbox) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/checkbox',
        ),
      );
      return;
    }

    if (widget is CheckboxListTile) {
      if (widget.secondary != null) {
        _walk(
          widget.secondary!,
          result,
          depth + 1,
          '$path/checkboxListTile/secondary',
        );
      }
      if (widget.title != null) {
        _walk(
          widget.title!,
          result,
          depth + 1,
          '$path/checkboxListTile/title',
        );
      }
      if (widget.subtitle != null) {
        _walk(
          widget.subtitle!,
          result,
          depth + 1,
          '$path/checkboxListTile/subtitle',
        );
      }
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth + 1,
          id: '$path/checkboxListTile/checkbox',
        ),
      );
      return;
    }

    if (widget is Switch) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/switch',
        ),
      );
      return;
    }

    if (widget is SwitchListTile) {
      if (widget.secondary != null) {
        _walk(
          widget.secondary!,
          result,
          depth + 1,
          '$path/switchListTile/secondary',
        );
      }
      if (widget.title != null) {
        _walk(
          widget.title!,
          result,
          depth + 1,
          '$path/switchListTile/title',
        );
      }
      if (widget.subtitle != null) {
        _walk(
          widget.subtitle!,
          result,
          depth + 1,
          '$path/switchListTile/subtitle',
        );
      }
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth + 1,
          id: '$path/switchListTile/switch',
        ),
      );
      return;
    }

    if (widget is Radio) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.circle,
          depth: depth,
          id: '$path/radio',
        ),
      );
      return;
    }

    if (widget is RadioListTile) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.circle,
          depth: depth + 1,
          id: '$path/radioListTile/radio',
        ),
      );
      if (widget.title != null) {
        _walk(
          widget.title!,
          result,
          depth + 1,
          '$path/radioListTile/title',
        );
      }
      if (widget.subtitle != null) {
        _walk(
          widget.subtitle!,
          result,
          depth + 1,
          '$path/radioListTile/subtitle',
        );
      }
      if (widget.secondary != null) {
        _walk(
          widget.secondary!,
          result,
          depth + 1,
          '$path/radioListTile/secondary',
        );
      }
      return;
    }

    if (widget is Slider) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/slider',
        ),
      );
      return;
    }

    if (widget is RangeSlider) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/rangeSlider',
        ),
      );
      return;
    }

    if (widget is DropdownButton) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/dropdownButton',
        ),
      );
      return;
    }

    if (widget is DropdownMenu) {
      result.add(
        SkeletonBlueprint(
          kind: SkeletonKind.rect,
          depth: depth,
          id: '$path/dropdownMenu',
        ),
      );
      if (widget.leadingIcon != null) {
        _walk(
          widget.leadingIcon!,
          result,
          depth + 1,
          '$path/dropdownMenu/leadingIcon',
        );
      }
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

      final hasDecoration = widget.decoration != null || widget.color != null;

      final hasFixedSize = constraints != null &&
          (constraints.hasBoundedWidth ||
              constraints.hasBoundedHeight ||
              constraints.minWidth > 0 ||
              constraints.minHeight > 0);

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
