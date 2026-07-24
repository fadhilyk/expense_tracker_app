import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/main.dart';

void main() {
  testWidgets('App boots successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // It should render either loading indicator or the main screen
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
