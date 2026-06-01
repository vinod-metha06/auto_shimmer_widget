import '../engine/skeleton_blueprint.dart';

class SkeletonCache {
  static final Map<Type, List<SkeletonBlueprint>> _cache = {};

  static List<SkeletonBlueprint>? get(Type type) {
    return _cache[type];
  }

  static void set(
    Type type,
    List<SkeletonBlueprint> blueprints,
  ) {
    _cache[type] = blueprints;
  }
}
