import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mario_touch_adventure/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarioTouchAdventureApp());

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
