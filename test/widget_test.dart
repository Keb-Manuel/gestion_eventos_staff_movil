import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gestion_eventos_staff_movil/main.dart';
import 'package:gestion_eventos_staff_movil/practica_08/providers/ubicacion_provider.dart';

void main() {
  testWidgets(
    'La aplicación muestra la pantalla de geolocalización',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => UbicacionProvider(),
          child: const MainApp(),
        ),
      );

      await tester.pump();

      expect(find.text('GPS y geolocalización'), findsOneWidget);
    },
  );
}
