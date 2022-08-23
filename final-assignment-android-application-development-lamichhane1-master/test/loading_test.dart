// External Import

import 'package:blog_app/pages/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Internal Import
// import '../lib/main.dart';

void main() {
testWidgets("Test the existence of Material App in My App",
(WidgetTester tester) async {
  
await tester.pumpWidget(MaterialApp(home: LoadingPage()));
final signin = find.byType(Scaffold);
expect(signin, findsOneWidget);
});
}