import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_eventos_staff_movil/main.dart';

void main() {
  testWidgets(
    'La pantalla de geolocalizacion se muestra correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UbicacionPage(),
        ),
      );

      expect(find.text('Mi ubicación'), findsOneWidget);
      expect(find.text('Sin ubicación'), findsOneWidget);
      expect(find.text('Obtener ubicación'), findsOneWidget);
      expect(find.text('Abrir en mapa'), findsOneWidget);
    },
  );

  testWidgets(
    'El boton de abrir mapa inicia deshabilitado',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UbicacionPage(),
        ),
      );

      final boton = tester.widget<OutlinedButton>(
        find.widgetWithText(
          OutlinedButton,
          'Abrir en mapa',
        ),
      );

      expect(boton.onPressed, isNull);
    },
  );
}
