
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/sensores_page.dart';

void main() {
  testWidgets('La pantalla de cámara y sensores se muestra',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SensoresPage(iniciarHardware: false),
      ),
    );

    expect(
      find.text('Cámara y sensores'),
      findsOneWidget,
    );

    expect(
      find.text('Tomar fotografía'),
      findsOneWidget,
    );

    expect(
      find.text('Acelerómetro'),
      findsOneWidget,
    );

    expect(
      find.text('Giroscopio'),
      findsOneWidget,
    );
  });
}