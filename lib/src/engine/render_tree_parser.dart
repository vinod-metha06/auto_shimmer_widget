import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'skeleton_kind.dart';
import 'skeleton_render_node.dart';

class RenderTreeParser {
  static List<SkeletonRenderNode> parse(RenderObject root) {
    final nodes = <SkeletonRenderNode>[];

    _walk(
      root,
      Offset.zero,
      nodes,
      0,
      'root',
    );

    return nodes;
  }

  static void _walk(
    RenderObject renderObject,
    Offset parentOffset,
    List<SkeletonRenderNode> nodes,
    int depth,
    String path,
  ) {
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }

    final parentData = renderObject.parentData;

    Offset localOffset = Offset.zero;

    if (parentData is BoxParentData) {
      localOffset = parentData.offset;
    }

    final globalOffset = parentOffset + localOffset;
    final rect = globalOffset & renderObject.size;

    final kind = _resolveKind(
      renderObject,
      rect,
    );

    if (kind != null && rect.width > 4 && rect.height > 4) {
      nodes.add(
        SkeletonRenderNode(
          rect: rect,
          depth: depth,
          id: path,
          kind: kind,
        ),
      );
    }

    int index = 0;

    renderObject.visitChildren((child) {
      _walk(
        child,
        globalOffset,
        nodes,
        depth + 1,
        '$path/$index',
      );

      index++;
    });
  }

  static SkeletonKind? _resolveKind(
    RenderObject object,
    Rect rect,
  ) {
    final type = object.runtimeType.toString();

    if (type.contains('RenderParagraph')) {
      return SkeletonKind.text;
    }

    if (type.contains('RenderImage')) {
      return SkeletonKind.rect;
    }

    if (type.contains('RenderClipOval') ||
        type.contains('RenderPhysicalShape')) {
      return SkeletonKind.circle;
    }

    /// Icon usually becomes RenderSemanticsAnnotations / RenderParagraph / RenderConstrainedBox chain.
    /// We keep small square render boxes as possible icons.
    if (_looksLikeIcon(rect)) {
      return SkeletonKind.icon;
    }

    /// CircleAvatar is often RenderDecoratedBox.
    if (type.contains('RenderDecoratedBox') && !_hasChildren(object)) {
      if (_looksLikeCircle(rect)) {
        return SkeletonKind.circle;
      }

      return SkeletonKind.rect;
    }

    return null;
  }

  static bool _looksLikeCircle(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    if (width <= 0 || height <= 0) return false;

    final ratio = width / height;

    final isSquareLike = ratio >= 0.85 && ratio <= 1.15;

    final isAvatarSize =
        width >= 24 && width <= 110 && height >= 24 && height <= 110;

    return isSquareLike && isAvatarSize;
  }

  static bool _looksLikeIcon(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    if (width <= 0 || height <= 0) return false;

    final ratio = width / height;

    final isSquareLike = ratio >= 0.75 && ratio <= 1.25;

    final isIconSize =
        width >= 16 && width <= 32 && height >= 16 && height <= 32;

    return isSquareLike && isIconSize;
  }

  static bool _hasChildren(RenderObject object) {
    bool hasChildren = false;

    object.visitChildren((child) {
      hasChildren = true;
    });

    return hasChildren;
  }
}
