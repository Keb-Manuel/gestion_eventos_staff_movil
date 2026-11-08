import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'practica_10/providers/incidencias_provider.dart';
import 'practica_10/screens/inicio_page.dart';
import 'practica_10/services/notificacion_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificacionService.inicializar();

  runApp(
    ChangeNotifierProvider(
      create: (_) => IncidenciasProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 10 - Reporte Móvil de Incidencias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}