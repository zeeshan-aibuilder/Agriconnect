import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Make sure this import points to your actual main.dart file
import 'package:agriconnect/main.dart';

void main() {
  testWidgets('App boots successfully smoke test', (WidgetTester tester) async {
    // ---- THE FIX: Use AgriConnectApp instead of MyApp ----
    // ProviderScope is mandatory for Riverpod
    await tester.pumpWidget(const ProviderScope(child: AgriConnectApp()));

    // Trigger a frame to let the UI render
    await tester.pumpAndSettle();

    // Verify that the MaterialApp successfully loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
