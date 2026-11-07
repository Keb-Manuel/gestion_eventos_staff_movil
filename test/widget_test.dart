import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'La aplicación muestra el gestor de notas offline',
    (WidgetTester tester) async {
      main();
      await tester.pump();

      expect(find.text('Gestor de notas offline'), findsOneWidget);
    },
  );
}
