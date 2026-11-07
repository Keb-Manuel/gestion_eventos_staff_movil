
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'practica_08/providers/ubicacion_provider.dart';
import 'practica_08/screens/ubicacion_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UbicacionProvider()..cargarPuntos(),
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
      title: 'Práctica 8 - Geolocalización',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const UbicacionPage(),
    );
  }
}
