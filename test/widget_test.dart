import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gestion_eventos_staff_movil/providers/contador_provider.dart';
import 'package:gestion_eventos_staff_movil/screens/home_screen.dart';

void main() {
  testWidgets('El contador incrementa correctamente', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verificar valor inicial.
    expect(find.text('0'), findsOneWidget);

    // Incrementar contador.
    await tester.tap(find.text('Incrementar'));
    await tester.pump();

    // Verificar valor actualizado.
    expect(find.text('1'), findsOneWidget);
  });
}
