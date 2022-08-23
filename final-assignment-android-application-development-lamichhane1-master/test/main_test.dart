// External Import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Internal Import
import '../lib/main.dart';

void main() {
testWidgets("Test the existence of Material App in My App",
(WidgetTester tester) async {
await tester.pumpWidget(MyApp());
final materialApp = find.byType(MaterialApp);
final guester = find.byType(GestureDetector);
expect(guester, findsNWidgets(1)); 
expect(materialApp, findsOneWidget);
});
}