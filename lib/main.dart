import 'package:flutter/material.dart';

import 'screens/bitacora_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BitacoraApp());
}

class BitacoraApp extends StatelessWidget {
  const BitacoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitácora de inspección',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const BitacoraPage(),
    );
  }
}
