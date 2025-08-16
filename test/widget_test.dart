import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mario_touch_adventure/main.dart';
import 'package:mario_touch_adventure/core/game_state.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Create a mock game state
    final gameState = GameState();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(gameState: gameState));

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
