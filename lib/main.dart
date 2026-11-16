import 'package:flutter/material.dart';

import 'screens/inicio_screen.dart';
import 'services/notificaciones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Notificaciones.iniciar();

  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reporte Móvil de Incidencias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const InicioScreen(),
    );
  }
}
