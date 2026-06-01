import 'package:flutter/material.dart';

import 'skeleton_kind.dart';

class SkeletonRenderNode {
  final Rect rect;
  final int depth;
  final String id;
  final SkeletonKind kind;

  const SkeletonRenderNode({
    required this.rect,
    required this.depth,
    required this.id,
    required this.kind,
  });
}
