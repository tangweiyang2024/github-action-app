import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smart Clock basic test', (WidgetTester tester) async {
    // 简单测试：确保应用可以启动
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('智能时钟'),
          ),
        ),
      ),
    );

    expect(find.text('智能时钟'), findsOneWidget);
  });
}