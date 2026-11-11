import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets('La bitácora inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BitacoraApp());

    expect(
      find.text('Bitácora de inspección'),
      findsOneWidget,
    );

    expect(
      find.text('Registro de evidencias'),
      findsOneWidget,
    );

    expect(
      find.text('Tomar fotografía y registrar evidencia'),
      findsOneWidget,
    );
  });
}
