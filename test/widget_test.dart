
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gestion_eventos_staff_movil/main.dart';
import 'package:gestion_eventos_staff_movil/practica_10_individual/providers/inventario_provider.dart';

class FakeInventarioProvider extends InventarioProvider {
  @override
  Future<void> inicializar() async {}
}

void main() {
  testWidgets(
    'StockSmart muestra su pantalla principal',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<InventarioProvider>(
          create: (_) => FakeInventarioProvider(),
          child: const StockSmartApp(),
        ),
      );

      await tester.pump();

      expect(find.text('StockSmart'), findsOneWidget);
      expect(find.text('Panel de control'), findsOneWidget);
      expect(find.text('Ver inventario'), findsOneWidget);
      expect(find.text('Registrar producto'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Importar desde API REST'),
        300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Importar desde API REST'), findsOneWidget);
    },
  );
}
