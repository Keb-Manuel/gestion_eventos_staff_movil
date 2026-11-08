import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets(
    'La aplicación muestra la pantalla de cámara y sensores',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      expect(
        find.text('Práctica 9 - Cámara y Sensores'),
        findsOneWidget,
      );

      expect(
        find.text('Bitácora de inspección'),
        findsOneWidget,
      );
    },
  );
}