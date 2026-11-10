import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:gestion_eventos_staff_movil/main.dart';
import 'package:gestion_eventos_staff_movil/models/punto_interes.dart';
import 'package:gestion_eventos_staff_movil/screens/distancia_page.dart';
import 'package:gestion_eventos_staff_movil/screens/puntos_page.dart';
import 'package:gestion_eventos_staff_movil/screens/registrar_punto_page.dart';
import 'package:gestion_eventos_staff_movil/services/ubicacion_service.dart';

class ServicioUbicacionPrueba extends UbicacionService {
  @override
  Future<Position> obtenerPosicion() async {
    return Position(
      longitude: -90.0500,
      latitude: 20.3833,
      timestamp: DateTime.now(),
      accuracy: 5,
      altitude: 0,
      altitudeAccuracy: 1,
      heading: 0,
      headingAccuracy: 1,
      speed: 0,
      speedAccuracy: 1,
    );
  }

  @override
  Future<void> abrirMapa(
    double latitud,
    double longitud,
  ) async {}
}

void main() {
  testWidgets(
    'La pantalla principal se muestra correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const PuntosInteresApp(),
      );

      expect(find.text('Puntos de interés'), findsOneWidget);
      expect(find.text('Mis lugares registrados'), findsOneWidget);
      expect(find.text('Total de puntos: 0'), findsOneWidget);
      expect(find.text('No hay puntos registrados.'), findsOneWidget);
      expect(find.text('Agregar punto'), findsOneWidget);
    },
  );

  testWidgets(
    'El formulario muestra error si el nombre está vacío',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegistrarPuntoPage(
            servicio: ServicioUbicacionPrueba(),
          ),
        ),
      );

      await tester.tap(
        find.text('Guardar punto de interés'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Ingresa el nombre del lugar.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Se puede obtener una ubicación y registrar un punto',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PuntosPage(
            servicio: ServicioUbicacionPrueba(),
          ),
        ),
      );

      await tester.tap(find.text('Agregar punto'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Instituto Tecnológico',
      );

      await tester.enterText(
        find.byType(TextFormField).last,
        'Lugar de estudio',
      );

      await tester.tap(
        find.text('Obtener ubicación GPS'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Ubicación obtenida correctamente.'),
        findsOneWidget,
      );

      expect(find.textContaining('Latitud:'), findsOneWidget);
      expect(find.textContaining('Longitud:'), findsOneWidget);

      final botonGuardar = find.text(
        'Guardar punto de interés',
      );

      await tester.ensureVisible(botonGuardar);
      await tester.pumpAndSettle();

      await tester.tap(botonGuardar);
      await tester.pumpAndSettle();

      expect(
        find.text('Instituto Tecnológico'),
        findsOneWidget,
      );

      expect(
        find.text('Total de puntos: 1'),
        findsOneWidget,
      );

      expect(
        find.text('Lugar de estudio'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'La pantalla de distancia se muestra correctamente',
    (WidgetTester tester) async {
      final puntos = [
        const PuntoInteres(
          nombre: 'Instituto',
          descripcion: 'Centro educativo',
          latitud: 20.3833,
          longitud: -90.0500,
        ),
        const PuntoInteres(
          nombre: 'Parque',
          descripcion: 'Parque principal',
          latitud: 20.3860,
          longitud: -90.0480,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DistanciaPage(puntos: puntos),
        ),
      );

      expect(
        find.text('Selecciona los puntos de interés'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          FilledButton,
          'Calcular distancia',
        ),
        findsOneWidget,
      );

      expect(
        find.byType(DropdownButtonFormField<PuntoInteres>),
        findsNWidgets(2),
      );
    },
  );

  test(
    'El cálculo de distancia entre dos coordenadas es correcto',
    () {
      final distancia = Geolocator.distanceBetween(
        20.3833,
        -90.0500,
        20.3860,
        -90.0480,
      );

      expect(distancia, greaterThan(0));
      expect(distancia, lessThan(1000));
    },
  );
}
