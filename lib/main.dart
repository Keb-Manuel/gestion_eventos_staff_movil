import 'package:flutter/material.dart';
import 'pages/propina_page.dart';
import 'pages/combustible_page.dart';

void main() {
  runApp(const Practica02App());
}

class Practica02App extends StatelessWidget {
  const Practica02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 02 - Dart y Estado',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/propina',
      routes: {
        '/propina': (context) => const PropinaPage(),
        '/combustible': (context) => const CombustiblePage(),
      },
    );
  }
}