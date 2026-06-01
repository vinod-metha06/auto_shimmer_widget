// import 'package:flutter/material.dart';

// import '../engine/skeleton_blueprint.dart';
// import '../models/skeleton_shape.dart';

// class WidgetParser {
//   static List<SkeletonBlueprint> parse(
//     Widget widget,
//   ) {
//     final nodes = <SkeletonBlueprint>[];

//     if (widget is ListTile) {
//       nodes.addAll([
//         const SkeletonBlueprint(
//           shape: SkeletonShape.circle,
//           widthFactor: 0.15,
//           height:20,
//         ),
//         const SkeletonBlueprint(
//           shape: SkeletonShape.text,
//           widthFactor: 0.65,
//           height: 16,
//         ),
//         const SkeletonBlueprint(
//           shape: SkeletonShape.text,
//           widthFactor: 0.45,
//           height: 14,
//         ),
//       ]);
//     } else if (widget is CircleAvatar) {
//       nodes.add(
//         const SkeletonBlueprint(
//           shape: SkeletonShape.circle,
//           widthFactor: 0.2,
//           height: 20,
//         ),
//       );
//     } else if (widget is Text) {
//       nodes.add(
//         const SkeletonBlueprint(
//           shape: SkeletonShape.text,
//           widthFactor: 0.7,
//           height: 14,
//         ),
//       );
//     } else {
//       nodes.add(
//         const SkeletonBlueprint(
//           shape: SkeletonShape.rect,
//           widthFactor: 1,
//           height: 120,
//         ),
//       );
//     }

//     return nodes;
//   }
// }
