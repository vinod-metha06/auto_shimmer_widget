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

  group('v1.0.0 Form Controls & Selection Inputs tests', () {
    testWidgets('renders shimmer with Checkbox and CheckboxListTile',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Checkbox(value: true, onChanged: (_) {}),
                  CheckboxListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Agree to terms'),
                    subtitle: const Text('Read carefully'),
                    secondary: const Icon(Icons.info),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Notifications'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with Switch and SwitchListTile',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Switch(value: true, onChanged: (_) {}),
                  SwitchListTile(
                    value: false,
                    onChanged: (_) {},
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Enable dark theme'),
                    secondary: const Icon(Icons.dark_mode),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  SwitchListTile(
                    value: true,
                    onChanged: (_) {},
                    title: const Text('Auto-save'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with Radio and RadioListTile',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  // ignore: deprecated_member_use
                  Radio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
                  // ignore: deprecated_member_use
                  RadioListTile<String>(
                    value: 'opt1',
                    // ignore: deprecated_member_use
                    groupValue: 'opt1',
                    // ignore: deprecated_member_use
                    onChanged: (_) {},
                    title: const Text('Standard Delivery'),
                    subtitle: const Text('3-5 business days'),
                    secondary: const Icon(Icons.local_shipping),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  // ignore: deprecated_member_use
                  RadioListTile<String>(
                    value: 'opt2',
                    // ignore: deprecated_member_use
                    groupValue: 'opt1',
                    // ignore: deprecated_member_use
                    onChanged: (_) {},
                    title: const Text('Express Delivery'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with Slider and RangeSlider',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Slider(value: 0.6, min: 0.0, max: 1.0, onChanged: (_) {}),
                  RangeSlider(
                    values: const RangeValues(0.2, 0.8),
                    min: 0.0,
                    max: 1.0,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with DropdownButton and DropdownMenu',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: 'One',
                    items: const [
                      DropdownMenuItem(value: 'One', child: Text('One')),
                    ],
                    onChanged: (_) {},
                  ),
                  const DropdownMenu<String>(
                    leadingIcon: Icon(Icons.category),
                    label: Text('Category'),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'A', label: 'Item A'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with form controls in RTL directionality',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: AutoShimmer(
                isLoading: true,
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: true,
                      onChanged: (_) {},
                      title: const Text('RTL Checkbox'),
                      subtitle: const Text('Subtitle'),
                      secondary: const Icon(Icons.star),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SwitchListTile(
                      value: false,
                      onChanged: (_) {},
                      title: const Text('RTL Switch'),
                      secondary: const Icon(Icons.wifi),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    // ignore: deprecated_member_use
                    RadioListTile<int>(
                      value: 1,
                      // ignore: deprecated_member_use
                      groupValue: 1,
                      // ignore: deprecated_member_use
                      onChanged: (_) {},
                      title: const Text('RTL Radio'),
                    ),
                    Slider(value: 0.3, onChanged: (_) {}),
                    RangeSlider(
                      values: const RangeValues(0.3, 0.7),
                      onChanged: (_) {},
                    ),
                    DropdownButton<String>(
                      items: const [],
                      onChanged: (_) {},
                    ),
                    const DropdownMenu<String>(
                      leadingIcon: Icon(Icons.language),
                      dropdownMenuEntries: [],
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

    testWidgets('renders shimmer with form controls in Row and Wrap',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (_) {}),
                      const SizedBox(width: 8),
                      const Text('Remember me'),
                      const Spacer(),
                      Switch(value: false, onChanged: (_) {}),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      Checkbox(value: false, onChanged: (_) {}),
                      Switch(value: true, onChanged: (_) {}),
                      // ignore: deprecated_member_use
                      Radio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
                      DropdownButton<String>(
                        items: const [],
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    test('WidgetBlueprintParser parses form controls correctly', () {
      final checkboxBlueprint = WidgetBlueprintParser.parse(
        Checkbox(value: true, onChanged: (_) {}),
      );
      expect(checkboxBlueprint.length, 1);
      expect(checkboxBlueprint.first.kind, SkeletonKind.rect);

      final switchBlueprint = WidgetBlueprintParser.parse(
        Switch(value: true, onChanged: (_) {}),
      );
      expect(switchBlueprint.length, 1);
      expect(switchBlueprint.first.kind, SkeletonKind.rect);

      final radioBlueprint = WidgetBlueprintParser.parse(
        // ignore: deprecated_member_use
        Radio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
      );
      expect(radioBlueprint.length, 1);
      expect(radioBlueprint.first.kind, SkeletonKind.circle);

      final sliderBlueprint = WidgetBlueprintParser.parse(
        Slider(value: 0.5, onChanged: (_) {}),
      );
      expect(sliderBlueprint.length, 1);
      expect(sliderBlueprint.first.kind, SkeletonKind.rect);

      final rangeSliderBlueprint = WidgetBlueprintParser.parse(
        RangeSlider(
          values: const RangeValues(0.2, 0.8),
          onChanged: (_) {},
        ),
      );
      expect(rangeSliderBlueprint.length, 1);
      expect(rangeSliderBlueprint.first.kind, SkeletonKind.rect);

      final dropdownBlueprint = WidgetBlueprintParser.parse(
        DropdownButton<String>(items: const [], onChanged: (_) {}),
      );
      expect(dropdownBlueprint.length, 1);
      expect(dropdownBlueprint.first.kind, SkeletonKind.rect);

      final menuBlueprint = WidgetBlueprintParser.parse(
        const DropdownMenu<String>(
          leadingIcon: Icon(Icons.settings),
          dropdownMenuEntries: [],
        ),
      );
      expect(menuBlueprint.length, 2);
      expect(menuBlueprint[0].kind, SkeletonKind.rect);
      expect(menuBlueprint[1].kind, SkeletonKind.icon);

      final listTileBlueprints = WidgetBlueprintParser.parse(
        CheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: const Text('Title'),
          subtitle: const Text('Subtitle'),
          secondary: const Icon(Icons.check),
        ),
      );
      expect(listTileBlueprints.length, 4);
      expect(listTileBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(listTileBlueprints.any((b) => b.kind == SkeletonKind.text), isTrue);
      expect(listTileBlueprints.any((b) => b.kind == SkeletonKind.rect), isTrue);
    });
  });

  group('v1.1.0 Navigation, App Bars & Expansion tests', () {
    testWidgets('renders shimmer with AppBar and SliverAppBar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AutoShimmer(
                isLoading: true,
                child: AppBar(
                  leading: const Icon(Icons.menu),
                  title: const Text('Dashboard'),
                  actions: const [
                    Icon(Icons.search),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),
            ),
            body: const AutoShimmer(
              isLoading: true,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    leading: Icon(Icons.arrow_back),
                    title: Text('Sliver Header'),
                    actions: [Icon(Icons.share)],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsNWidgets(2));
    });

    testWidgets('renders shimmer with TabBar and Tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: AutoShimmer(
                  isLoading: true,
                  child: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.home), text: 'Home'),
                      Tab(icon: Icon(Icons.explore), text: 'Explore'),
                      Tab(text: 'Profile'),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  Center(child: Text('1')),
                  Center(child: Text('2')),
                  Center(child: Text('3')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with Badge and Placeholder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Badge(
                    label: Text('5'),
                    child: Icon(Icons.notifications),
                  ),
                  SizedBox(height: 12),
                  Badge(
                    child: CircleAvatar(radius: 20),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Placeholder(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with ExpansionTile (collapsed & expanded)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  ExpansionTile(
                    leading: Icon(Icons.folder),
                    title: Text('Documents'),
                    subtitle: Text('3 files'),
                    children: [
                      Text('Item 1'),
                      Text('Item 2'),
                    ],
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text('Expanded Section'),
                    children: [
                      ListTile(title: Text('Sub-item A')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with navigation widgets in RTL',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AutoShimmer(
                  isLoading: true,
                  child: AppBar(
                    leading: const Icon(Icons.menu),
                    title: const Text('RTL Header'),
                    actions: const [Icon(Icons.search)],
                  ),
                ),
              ),
              body: const AutoShimmer(
                isLoading: true,
                child: Column(
                  children: [
                    Badge(
                      label: Text('3'),
                      child: Icon(Icons.mail),
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.settings),
                      title: Text('RTL Expansion'),
                      subtitle: Text('Details'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsNWidgets(2));
    });

    test('WidgetBlueprintParser parses navigation & chrome widgets correctly', () {
      final appBarBlueprints = WidgetBlueprintParser.parse(
        AppBar(
          leading: const Icon(Icons.menu),
          title: const Text('Title'),
          actions: const [Icon(Icons.search)],
        ),
      );
      expect(appBarBlueprints.any((b) => b.kind == SkeletonKind.rect), isTrue);
      expect(appBarBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(appBarBlueprints.any((b) => b.kind == SkeletonKind.text), isTrue);

      final tabBlueprints = WidgetBlueprintParser.parse(
        const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(text: 'Settings'),
          ],
        ),
      );
      expect(tabBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(tabBlueprints.any((b) => b.kind == SkeletonKind.text), isTrue);

      final badgeBlueprints = WidgetBlueprintParser.parse(
        const Badge(
          label: Text('1'),
          child: Icon(Icons.shopping_cart),
        ),
      );
      expect(badgeBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(badgeBlueprints.any((b) => b.kind == SkeletonKind.rect), isTrue);

      final expansionBlueprints = WidgetBlueprintParser.parse(
        const ExpansionTile(
          leading: Icon(Icons.info),
          title: Text('More Info'),
        ),
      );
      expect(expansionBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(expansionBlueprints.any((b) => b.kind == SkeletonKind.text), isTrue);

      final placeholderBlueprints = WidgetBlueprintParser.parse(
        const Placeholder(),
      );
      expect(placeholderBlueprints.length, 1);
      expect(placeholderBlueprints.first.kind, SkeletonKind.rect);
    });
  });

  group('v1.2.0 Slivers, Tables & Complex Views tests', () {
    testWidgets('renders shimmer with CustomScrollView and multi-sliver hierarchy',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text('Sliver Header'),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Featured Section'),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        const [
                          ListTile(
                            leading: CircleAvatar(),
                            title: Text('Item 1'),
                          ),
                          ListTile(
                            leading: CircleAvatar(),
                            title: Text('Item 2'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildListDelegate(
                      const [
                        Card(child: Center(child: Text('Grid 1'))),
                        Card(child: Center(child: Text('Grid 2'))),
                      ],
                    ),
                  ),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('Footer')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byWidgetPredicate(_isRenderAutoShimmerWidget), findsOneWidget);
    });

    testWidgets('renders shimmer with SliverList and SliverGrid builder delegates',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              shimmerItemCount: 4,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Item $index')),
                      childCount: 4,
                    ),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Card(child: Text('Card $index')),
                      childCount: 4,
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

    testWidgets('renders shimmer with Table and TableRow (LTR and RTL)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoShimmer(
              isLoading: true,
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    children: const [
                      TableRow(
                        children: [
                          Text('Header 1'),
                          Text('Header 2'),
                          Text('Header 3'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Cell 1'),
                          Text('Cell 2'),
                          Text('Cell 3'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Table(
                      children: const [
                        TableRow(
                          children: [
                            Text('RTL 1'),
                            Text('RTL 2'),
                          ],
                        ),
                      ],
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

    test('WidgetBlueprintParser parses Slivers and Table correctly', () {
      final customScrollViewBlueprints = WidgetBlueprintParser.parse(
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: Text('Banner')),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  const [
                    Text('Row 1'),
                    Text('Row 2'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      expect(
        customScrollViewBlueprints.any((b) => b.kind == SkeletonKind.text),
        isTrue,
      );

      final tableBlueprints = WidgetBlueprintParser.parse(
        Table(
          children: const [
            TableRow(
              children: [
                Icon(Icons.star),
                Text('Col 2'),
              ],
            ),
          ],
        ),
      );
      expect(tableBlueprints.any((b) => b.kind == SkeletonKind.icon), isTrue);
      expect(tableBlueprints.any((b) => b.kind == SkeletonKind.text), isTrue);
    });
  });
}

