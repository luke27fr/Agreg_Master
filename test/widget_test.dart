import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const AgregMasterApp());
    await tester.pump();

    // Vérifie que le splash screen s'affiche
    expect(find.text('Agreg Master'), findsOneWidget);
    expect(find.text('Chargement...'), findsOneWidget);
  });
}
