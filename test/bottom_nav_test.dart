import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweet_balance/ui/widgets/bottom_nav_menu.dart';

Widget createTestWidget({required int selectedIndex, required ValueChanged<int> onTap}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text(
          selectedIndex == 0
              ? 'Home Screen'
              : selectedIndex == 1
              ? 'Meals Screen'
              : 'My Page Screen',
        ),
      ),
      bottomNavigationBar: BottomNavMenu(
        currentIndex: selectedIndex,
        onTap: onTap,
      ),
    ),
  );
}

void main() {
  testWidgets('Shows Home screen initially', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => createTestWidget(
          selectedIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );

    expect(find.text('Home Screen'), findsOneWidget);
  });

  testWidgets('Navigates to Meals screen on tab', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => createTestWidget(
          selectedIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );

    await tester.tap(find.text('Meals'));
    await tester.pumpAndSettle();

    expect(find.text('Meals Screen'), findsOneWidget);
  });

  testWidgets('Navigates to My Page screen on tab', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => createTestWidget(
          selectedIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );

    await tester.tap(find.text('My page'));
    await tester.pumpAndSettle();

    expect(find.text('My Page Screen'), findsOneWidget);
  });
}
