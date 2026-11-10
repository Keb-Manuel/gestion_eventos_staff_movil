import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:gestion_eventos_staff_movil/providers/tarea_provider.dart';
import 'package:gestion_eventos_staff_movil/screens/tarea_page.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('La aplicación muestra la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TareaProvider()..cargarInicial(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TareasPage(),
        ),
      ),
    );

    // Permite que se ejecuten las primeras actualizaciones.
    await tester.pump();

    // Comprueba que la aplicación se haya construido.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(TareasPage), findsOneWidget);
  });
}
