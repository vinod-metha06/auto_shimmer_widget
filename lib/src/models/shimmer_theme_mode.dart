enum ShimmerThemeMode {
  /// Uses Theme.of(context).brightness.
  system,

  /// Always uses light shimmer colors unless base/highlight are provided.
  light,

  /// Always uses dark shimmer colors unless base/highlight are provided.
  dark,
}
