import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/reporte.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    final ruta = join(
      await getDatabasesPath(),
      'reportes.db',
    );

    _database = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reportes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            categoria TEXT NOT NULL,
            fotografia TEXT,
            latitud REAL NOT NULL,
            longitud REAL NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  static Future<int> insertar(Reporte reporte) async {
    final db = await database;

    return await db.insert(
      'reportes',
      reporte.toMap(),
    );
  }

  static Future<List<Reporte>> obtenerReportes() async {
    final db = await database;

    final resultado = await db.query(
      'reportes',
      orderBy: 'id DESC',
    );

    return resultado.map((e) => Reporte.fromMap(e)).toList();
  }
}
