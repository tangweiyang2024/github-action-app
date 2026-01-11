import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:time_display_app/main.dart';

void main() {
  testWidgets('Smart Clock app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeDisplayApp());

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(ClockScreen), findsOneWidget);
    expect(find.byIcon(Icons.access_time), findsOneWidget);
    
    expect(find.text('Clock'), findsOneWidget);
  });
}
