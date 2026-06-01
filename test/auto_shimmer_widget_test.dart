import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_shimmer_widget/auto_shimmer_widget.dart';

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

  testWidgets('wraps child in shimmer widget when isLoading is true', (tester) async {
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
}
