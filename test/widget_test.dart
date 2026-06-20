import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/main.dart';

void main() {
  testWidgets('Islamic app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IslamicApp());

    // Verify that the app launched without crashing
    expect(find.byType(IslamicApp), findsOneWidget);
  });
}