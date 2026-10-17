import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_shimmer_widget/auto_shimmer_widget.dart';
import 'package:auto_shimmer_widget/src/engine/skeleton_kind.dart';
import 'package:auto_shimmer_widget/src/engine/widget_blueprint_parser.dart';

bool _isRenderAutoShimmerWidget(Widget widget) {
  return widget.runtimeType.toString() == 'RenderAutoShimmerWidget';
}

void main() {
  testWidgets('returns original child when isLoading is false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AutoShimmer(
          isLoading: false,
          child: Text('Loaded'),
        ),
      ),
    );

    expect(find.text('Loaded'), findsOneWidget);
    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsNothing);
  });

  testWidgets('wraps child in shimmer widget when isLoading is true',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AutoShimmer(
          isLoading: true,
          child: Text('Loading'),
        ),
      ),
    );

    expect(find.text('Loading'), findsOneWidget);
    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
  });

  testWidgets('renders shimmer with Visibility widget when visible is true',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AutoShimmer(
          isLoading: true,
          child: Visibility(
            visible: true,
            child: Text('Visible Content'),
          ),
        ),
      ),
    );

    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
  });

  testWidgets('renders shimmer with Visibility widget when visible is false',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AutoShimmer(
          isLoading: true,
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: Text('Hidden Content'),
              ),
              Text('Shown Content'),
            ],
          ),
        ),
      ),
    );

    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
  });

  testWidgets(
      'renders shimmer with Visibility maintainSize is true when visible is false',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AutoShimmer(
          isLoading: true,
          child: Column(
            children: [
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text('Hidden But Maintained'),
              ),
              Text('Visible Text'),
            ],
          ),
        ),
      ),
    );

    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
  });

  testWidgets(
      'renders shimmer with Visibility in Row, Wrap, and ListTile',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AutoShimmer(
            isLoading: true,
            child: Column(
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: false,
                      child: CircleAvatar(radius: 20),
                    ),
                    Expanded(child: Text('Name')),
                  ],
                ),
                Wrap(
                  children: [
                    Visibility(
                      visible: false,
                      child: Chip(label: Text('Tag 1')),
                    ),
                    Chip(label: Text('Tag 2')),
                  ],
                ),
                ListTile(
                  leading: Visibility(
                    visible: false,
                    child: CircleAvatar(radius: 20),
                  ),
                  title: Text('Title'),
                  subtitle: Visibility(
                    visible: false,
                    child: Text('Subtitle'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
  });

  group('WidgetBlueprintParser Visibility tests', () {
    test('parses child when visible is true', () {
      final blueprints = WidgetBlueprintParser.parse(
        const Visibility(
          visible: true,
          child: Text('Hello'),
        ),
      );

      expect(blueprints.length, 1);
      expect(blueprints.first.kind, SkeletonKind.text);
    });

    test('ignores child when visible is false and maintainSize is false', () {
      final blueprints = WidgetBlueprintParser.parse(
        const Visibility(
          visible: false,
          child: Text('Hello'),
        ),
      );

      expect(blueprints, isEmpty);
    });

    test('ignores child when visible is false and maintainSize is true', () {
      final blueprints = WidgetBlueprintParser.parse(
        const Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Text('Hello'),
        ),
      );

      expect(blueprints, isEmpty);
    });

    test('parses replacement when visible is false and replacement is provided',
        () {
      final blueprints = WidgetBlueprintParser.parse(
        const Visibility(
          visible: false,
          replacement: Icon(Icons.person),
          child: Text('Hello'),
        ),
      );

      expect(blueprints.length, 1);
      expect(blueprints.first.kind, SkeletonKind.icon);
    });
  });

  group('v0.0.4 layout wrappers and spacing tests', () {
    testWidgets('renders shimmer with SafeArea, Opacity, Offstage, and ClipRect',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: SafeArea(
                minimum: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Text('Visible with Opacity'),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: Text('Hidden with Zero Opacity'),
                    ),
                    AnimatedOpacity(
                      opacity: 0.7,
                      duration: Duration(milliseconds: 200),
                      child: Text('Animated Opacity Content'),
                    ),
                    Offstage(
                      offstage: false,
                      child: Text('Onstage Content'),
                    ),
                    Offstage(
                      offstage: true,
                      child: Text('Offstage Content'),
                    ),
                    ClipRect(
                      child: Text('Clipped Content'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with Spacer in Row and Column',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Row(
                children: [
                  CircleAvatar(radius: 20),
                  Spacer(flex: 2),
                  Text('Spaced Item'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets(
        'renders shimmer with ConstrainedBox, FractionallySizedBox, and LimitedBox',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 150, maxHeight: 40),
                    child: const Text('Constrained'),
                  ),
                  const SizedBox(
                    height: 60,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: Text('Fractional'),
                    ),
                  ),
                  const LimitedBox(
                    maxHeight: 50,
                    maxWidth: 100,
                    child: Text('Limited'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    test('WidgetBlueprintParser parses layout wrappers correctly', () {
      final safeAreaBlueprints = WidgetBlueprintParser.parse(
        const SafeArea(child: Text('Safe')),
      );
      expect(safeAreaBlueprints.length, 1);
      expect(safeAreaBlueprints.first.kind, SkeletonKind.text);

      final zeroOpacityBlueprints = WidgetBlueprintParser.parse(
        const Opacity(opacity: 0.0, child: Text('Zero')),
      );
      expect(zeroOpacityBlueprints, isEmpty);

      final positiveOpacityBlueprints = WidgetBlueprintParser.parse(
        const Opacity(opacity: 0.5, child: Icon(Icons.star)),
      );
      expect(positiveOpacityBlueprints.length, 1);
      expect(positiveOpacityBlueprints.first.kind, SkeletonKind.icon);

      final offstageBlueprints = WidgetBlueprintParser.parse(
        const Offstage(offstage: true, child: Text('Off')),
      );
      expect(offstageBlueprints, isEmpty);

      final onstageBlueprints = WidgetBlueprintParser.parse(
        const Offstage(offstage: false, child: CircleAvatar()),
      );
      expect(onstageBlueprints.length, 1);
      expect(onstageBlueprints.first.kind, SkeletonKind.circle);

      final constrainedBlueprints = WidgetBlueprintParser.parse(
        ConstrainedBox(
          constraints: const BoxConstraints(),
          child: const Text('Constrained'),
        ),
      );
      expect(constrainedBlueprints.length, 1);
      expect(constrainedBlueprints.first.kind, SkeletonKind.text);
    });
  });
}

