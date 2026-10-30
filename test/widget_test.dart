import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets('Muestra la pantalla del gestor de tareas',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Gestor de tareas offline'), findsOneWidget);
    expect(find.text('Nueva tarea'), findsOneWidget);
  });
}
