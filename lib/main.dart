import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'practica_10_individual/providers/inventario_provider.dart';
import 'practica_10_individual/screens/inicio_page.dart';
import 'practica_10_individual/services/notificacion_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificacionService.inicializar();

  runApp(
    ChangeNotifierProvider(
      create: (_) => InventarioProvider(),
      child: const StockSmartApp(),
    ),
  );
}

class StockSmartApp extends StatelessWidget {
  const StockSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockSmart - Inventario',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF172554),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const InicioPage(),
    );
  }
}