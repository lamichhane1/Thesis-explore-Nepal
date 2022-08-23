// External Import
import 'package:blog_app/screen/UserBlogScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Internal Import
// import '../lib/main.dart';

void main() {
testWidgets("Test the existence of Material App in My App",
(WidgetTester tester) async {
  
await tester.pumpWidget(MaterialApp(home: UserBlogScreen(),));
final screen = find.byType(Scaffold);
expect(screen, findsOneWidget);
});
}