import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sweet_balance/ui/screens/welcome_screen.dart';
import 'firebase_test_utils.dart';

void main() {
  setUpAll(() async {
    await setupFirebase();
  });

  testWidgets('Displays initial welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WelcomeScreen()),
    );

    expect(find.text('Welcome to Sugar Tracker'), findsOneWidget);
    expect(find.text('Track your sugar levels and maintain a healthy lifestyle.'), findsOneWidget);
  });

  testWidgets('Navigates to MultiStepFormScreen on "Get Started for FREE"', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WelcomeScreen()),
    );

    await tester.tap(find.text('Get Started for FREE'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('multiStepFormScreen')), findsOneWidget);
  });

  testWidgets('Navigates to SignInScreen on "Sign in" tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: WelcomeScreen()),
    );

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('signInScreen')), findsOneWidget);
  });
}
