import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:btox/app.dart';

void main() {
  final String allZeroToxId =
      String.fromCharCodes(Iterable.generate(76, (_) => '0'.codeUnits.first));
  testWidgets('Add contact adds a contact', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Check that no contact with all 0s for the public key exists.
    expect(find.textContaining('00000000'), findsNothing);

    // Navigate to the 'add contact' screen.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill in the contact data.
    await tester.enterText(find.byKey(const Key('toxId')), allZeroToxId);
    await tester.pump();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify that the contact appeared.
    expect(find.textContaining('00000000'), findsOneWidget);
  });
}
