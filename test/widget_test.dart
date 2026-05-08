import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- YAHAN RIVERPOD IMPORT KIYA

import 'package:agriconnect/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    
    // ---- THE FIX: WRAPPED MyApp IN ProviderScope ----
    // Jab bhi Riverpod use hota hai, test mein bhi ProviderScope laazmi hota hai
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}