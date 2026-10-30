import 'package:flutter/material.dart';
import 'practica_05_api/usuarios_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 5 - API REST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UsuariosPage(),
    );
  }
}
