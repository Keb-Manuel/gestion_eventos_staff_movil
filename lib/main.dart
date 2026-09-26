import 'package:flutter/material.dart';
import 'screens/inicio_page.dart';

void main() {
  runApp(const CatalogoApp());
}

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}