import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bf_app/main.dart';

void main() {
  testWidgets('BF App launches and shows splash screen',
      (WidgetTester tester) async {
    // BFApp 빌드 및 프레임 트리거
    await tester.pumpWidget(const BFApp());

    // 스플래시 화면의 BF 로고 텍스트 확인
    expect(find.text('BF'), findsOneWidget);

    // 스플래시 화면이 표시되는지 확인
    expect(find.byType(Scaffold), findsWidgets);
  });

  // 추가 테스트 예제
  group('Navigation Tests', () {
    testWidgets('Splash screen appears on launch', (WidgetTester tester) async {
      await tester.pumpWidget(const BFApp());

      // BF 로고가 표시되는지 확인
      expect(find.text('BF'), findsOneWidget);
    });
  });
}
