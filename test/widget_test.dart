import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Cámara y sensores'), findsOneWidget);
    expect(find.text('Tomar fotografía'), findsOneWidget);
  });
}
