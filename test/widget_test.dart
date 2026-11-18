import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_evaluable/main.dart';

void main() {
  testWidgets('La pantalla inicial muestra el encabezado de la biblioteca',
      (tester) async {
    await tester.pumpWidget(const BibliotecaApp());
    await tester.pump();
    expect(find.text('BIBLIOTECA PERSONAL'), findsOneWidget);
  });
}
