import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:time_display_app/main.dart';

void main() {
  testWidgets('Time display app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeDisplayApp());

    expect(find.byType(TimeDisplayPage), findsOneWidget);
    expect(find.byIcon(Icons.access_time), findsOneWidget);
    
    expect(find.text('Time Display'), findsOneWidget);
  });
}
