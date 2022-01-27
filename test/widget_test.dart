import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:btox/main.dart';

void main() {
  testWidgets('Add contact adds a contact smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Verify that we start with 1 dummy contact.
    expect(find.text('Contact 0'), findsOneWidget);
    expect(find.text('Contact 1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that another contact appeared.
    expect(find.text('Contact 1'), findsOneWidget);
    expect(find.text('Contact 2'), findsNothing);
  });
}
