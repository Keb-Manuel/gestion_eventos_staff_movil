import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MiAplicacion());

    // Comprueba el título de la aplicación.
    expect(
      find.text('Reporte de Incidencias'),
      findsOneWidget,
    );

    // Comprueba el nombre del sistema.
    expect(
      find.text('Sistema de Reportes Móviles'),
      findsOneWidget,
    );

    // Comprueba los botones principales.
    expect(
      find.text('Nuevo reporte'),
      findsOneWidget,
    );

    expect(
      find.text('Consultar reportes'),
      findsOneWidget,
    );

    expect(
      find.text('Consultar API REST'),
      findsOneWidget,
    );
  });

  testWidgets('Navega al formulario de nuevo reporte',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MiAplicacion());

    await tester.tap(find.text('Nuevo reporte'));

    await tester.pumpAndSettle();

    // Comprueba que se abrió el formulario.
    expect(find.text('Nuevo reporte'), findsOneWidget);

    expect(find.text('Título del reporte'), findsOneWidget);

    expect(find.text('Descripción'), findsOneWidget);

    expect(find.text('Categoría'), findsOneWidget);
  });
}
