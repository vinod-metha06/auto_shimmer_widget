enum ShimmerDirection {
  /// Physical directions.
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,

  /// Directionality-aware directions.
  /// In LTR, startToEnd means leftToRight.
  /// In RTL, startToEnd means rightToLeft.
  startToEnd,
  endToStart,

  /// Diagonal physical directions.
  topLeftToBottomRight,
  topRightToBottomLeft,
  bottomLeftToTopRight,
  bottomRightToTopLeft,
}
