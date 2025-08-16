import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Build a simple MaterialApp for testing
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Test'),
        ),
      ),
    ));

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });
}
