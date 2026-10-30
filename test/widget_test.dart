import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets('La aplicación muestra la pantalla de publicaciones REST',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Publicaciones REST'), findsOneWidget);
  });
}
