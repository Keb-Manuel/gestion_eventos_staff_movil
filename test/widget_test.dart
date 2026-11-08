
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gestion_eventos_staff_movil/main.dart';
import 'package:gestion_eventos_staff_movil/practica_10/providers/incidencias_provider.dart';

class FakeIncidenciasProvider extends IncidenciasProvider {
  @override
  Future<void> cargarIncidencias() async {}
}

void main() {
  testWidgets(
    'La aplicación muestra la pantalla principal de incidencias',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<IncidenciasProvider>(
          create: (_) => FakeIncidenciasProvider(),
          child: const MainApp(),
        ),
      );

      expect(
        find.text('Reporte de Incidencias'),
        findsOneWidget,
      );

      expect(
        find.text('Sistema de Reportes'),
        findsOneWidget,
      );

      expect(
        find.text('Registrar incidencia'),
        findsOneWidget,
      );

      expect(
        find.text('Consultar API REST'),
        findsOneWidget,
      );
    },
  );
}