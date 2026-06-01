enum ShimmerAnimationType {
  /// A single highlight band moves across the skeleton.
  slide,

  /// Full skeleton smoothly fades between base and highlight color.
  pulse,

  /// Multiple highlight bands move across the skeleton.
  wave,

  /// Like slide, but moves forward and backward instead of looping hard.
  bounce,

  /// Very soft pulse. Good for calm loading states.
  breathe,

  /// Radial moving highlight. Good for cards and image-heavy UI.
  glow,

  /// Static skeleton with no animation.
  none,
}
