
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'practica_06_individual/screens/gestor_tareas_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SQLite para la versión web.
  databaseFactory = databaseFactoryFfiWeb;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const GestorTareasPage(),
    );
  }
}
