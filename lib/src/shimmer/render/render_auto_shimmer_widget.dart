part of '../render_auto_shimmer.dart';

class RenderAutoShimmerWidget extends SingleChildRenderObjectWidget {
  final Widget originalWidget;
  final TickerProvider vsync;

  final int shimmerItemCount;
  final int gridCrossAxisCount;

  final ShimmerAnimationType animationType;
  final Duration speed;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;
  final TextDirection textDirection;
  final double borderRadius;

  const RenderAutoShimmerWidget({
    super.key,
    required this.originalWidget,
    required this.vsync,
    this.shimmerItemCount = 6,
    this.gridCrossAxisCount = 2,
    this.animationType = ShimmerAnimationType.slide,
    this.speed = const Duration(milliseconds: 1200),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.startToEnd,
    this.textDirection = TextDirection.ltr,
    this.borderRadius = 18,
    required super.child,
  });

  @override
  RenderAutoShimmer createRenderObject(BuildContext context) {
    return RenderAutoShimmer(
      originalWidget: originalWidget,
      vsync: vsync,
      shimmerItemCount: shimmerItemCount,
      gridCrossAxisCount: gridCrossAxisCount,
      animationType: animationType,
      speed: speed,
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      textDirection: textDirection,
      borderRadius: borderRadius,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAutoShimmer renderObject,
  ) {
    renderObject
      ..originalWidget = originalWidget
      ..shimmerItemCount = shimmerItemCount
      ..gridCrossAxisCount = gridCrossAxisCount
      ..animationType = animationType
      ..speed = speed
      ..baseColor = baseColor
      ..highlightColor = highlightColor
      ..direction = direction
      ..textDirection = textDirection
      ..borderRadius = borderRadius;
  }
}
