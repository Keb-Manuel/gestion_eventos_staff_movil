import 'package:flutter/material.dart';
import 'data/book_database.dart';
import 'services/notification_service.dart';
import 'screens/library_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookDatabase.instance.database;
  await NotificationService.instance.initialize();
  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF173B57);
    return MaterialApp(
      title: 'Biblioteca Personal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FA),
          foregroundColor: navy,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LibraryShell(),
    );
  }
}
