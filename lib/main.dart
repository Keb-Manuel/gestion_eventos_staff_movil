import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/database_factory.dart';

import 'practica_07/providers/contador_provider.dart';
import 'practica_07/providers/usuario_provider.dart';
import 'practica_07/providers/notas_provider.dart';

import 'practica_07/screens/contador_page.dart';
import 'practica_07/screens/usuarios_provider_page.dart';
import 'practica_07/screens/notas_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configurarDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsuarioProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContadorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotasProvider(),
        ),
      ],
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
      title: 'Práctica 7',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const NotasPage(),
      routes: {
        '/usuarios': (context) => const UsuariosProviderPage(),
        '/contador': (context) => const ContadorPage(),
      },
    );
  }
}