import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets(
    'La aplicación inicia correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(
        find.text('Registro de productos'),
        findsOneWidget,
      );

      expect(
        find.text('Nombre del producto'),
        findsOneWidget,
      );

      expect(
        find.text('Categoría'),
        findsOneWidget,
      );

      expect(
        find.text('Precio'),
        findsOneWidget,
      );

      expect(
        find.text('Existencia'),
        findsOneWidget,
      );

      expect(
        find.text('Agregar producto'),
        findsOneWidget,
      );
    },
  );
}