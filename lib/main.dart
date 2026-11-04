import 'package:flutter/material.dart';
import 'practica_05_api/agentes/agentes_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de agentes VALORANT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4655),
        ),
        useMaterial3: true,
      ),
      home: const AgentesPage(),
    );
  }
}