import 'package:flutter/material.dart';

import '../models/shimmer_animation_type.dart';
import '../models/shimmer_direction.dart';
import '../models/shimmer_theme_mode.dart';
import 'render_auto_shimmer.dart';

class AutoShimmer extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  /// Used for ListView.builder / GridView.builder fallback skeleton count.
  final int shimmerItemCount;

  /// Used for GridView.builder fallback when grid count is not detectable.
  final int gridCrossAxisCount;

  /// Animation style.
  final ShimmerAnimationType animationType;

  /// Animation speed.
  final Duration speed;

  /// Optional custom skeleton base color.
  /// If null, color is selected from [themeMode].
  final Color? baseColor;

  /// Optional custom moving highlight color.
  /// If null, color is selected from [themeMode].
  final Color? highlightColor;

  /// Light theme fallback colors.
  final Color lightBaseColor;
  final Color lightHighlightColor;

  /// Dark theme fallback colors.
  final Color darkBaseColor;
  final Color darkHighlightColor;

  /// System/light/dark shimmer color resolving.
  final ShimmerThemeMode themeMode;

  /// Shimmer movement direction. [ShimmerDirection.startToEnd]
  /// and [ShimmerDirection.endToStart] respect [textDirection].
  final ShimmerDirection direction;

  /// Optional manual direction. If null, Directionality.of(context) is used.
  final TextDirection? textDirection;

  /// Main background radius.
  final double borderRadius;

  const AutoShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
    this.shimmerItemCount = 6,
    this.gridCrossAxisCount = 2,
    this.animationType = ShimmerAnimationType.slide,
    this.speed = const Duration(milliseconds: 1200),
    this.baseColor,
    this.highlightColor,
    this.lightBaseColor = const Color(0xFFE0E0E0),
    this.lightHighlightColor = const Color(0xFFF5F5F5),
    this.darkBaseColor = const Color(0xFF2A2A2A),
    this.darkHighlightColor = const Color(0xFF3A3A3A),
    this.themeMode = ShimmerThemeMode.system,
    this.direction = ShimmerDirection.startToEnd,
    this.textDirection,
    this.borderRadius = 18,
  });

  @override
  State<AutoShimmer> createState() => _AutoShimmerState();
}

class _AutoShimmerState extends State<AutoShimmer>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final effectiveTextDirection = widget.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;

    final brightness = Theme.of(context).brightness;

    final useDark = switch (widget.themeMode) {
      ShimmerThemeMode.dark => true,
      ShimmerThemeMode.light => false,
      ShimmerThemeMode.system => brightness == Brightness.dark,
    };

    final effectiveBaseColor = widget.baseColor ??
        (useDark ? widget.darkBaseColor : widget.lightBaseColor);

    final effectiveHighlightColor = widget.highlightColor ??
        (useDark ? widget.darkHighlightColor : widget.lightHighlightColor);

    return RenderAutoShimmerWidget(
      originalWidget: widget.child,
      vsync: this,
      shimmerItemCount: widget.shimmerItemCount,
      gridCrossAxisCount: widget.gridCrossAxisCount,
      animationType: widget.animationType,
      speed: widget.speed,
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      direction: widget.direction,
      textDirection: effectiveTextDirection,
      borderRadius: widget.borderRadius,
      child: widget.child,
    );
  }
}
