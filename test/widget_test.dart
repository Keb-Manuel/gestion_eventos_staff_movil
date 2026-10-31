
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gestion_eventos_staff_movil/main.dart';
import 'package:gestion_eventos_staff_movil/practica_07/providers/usuario_provider.dart';
import 'package:gestion_eventos_staff_movil/practica_07/providers/contador_provider.dart';

void main() {
  testWidgets(
    'La aplicación muestra la pantalla de usuarios con Provider',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => UsuarioProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ContadorProvider(),
            ),
          ],
          child: const MainApp(),
        ),
      );

      await tester.pump();

      expect(find.text('Usuarios con Provider'), findsOneWidget);
    },
  );
}
