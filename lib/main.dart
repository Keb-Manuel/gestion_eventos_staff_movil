import 'package:flutter/material.dart';

import 'screens/puntos_page.dart';
import 'services/ubicacion_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PuntosInteresApp());
}

class PuntosInteresApp extends StatelessWidget {
  const PuntosInteresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puntos de interés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: PuntosPage(
        servicio: UbicacionService(),
      ),
    );
  }
}
