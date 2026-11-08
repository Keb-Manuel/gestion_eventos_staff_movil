import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/incidencia.dart';

class IncidenciaDatabase {
  static final IncidenciaDatabase instance = IncidenciaDatabase._init();

  static Database? _database;

  IncidenciaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('incidencias.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final pathDB = join(dbPath, filePath);

    return await openDatabase(
      pathDB,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incidencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        foto TEXT,
        latitud REAL,
        longitud REAL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertar(Incidencia incidencia) async {
    final db = await instance.database;

    return await db.insert(
      'incidencias',
      incidencia.toMap(),
    );
  }

  Future<List<Incidencia>> obtenerTodas() async {
    final db = await instance.database;

    final resultado = await db.query(
      'incidencias',
      orderBy: 'fecha DESC',
    );

    return resultado.map((map) => Incidencia.fromMap(map)).toList();
  }

  Future<int> eliminar(int id) async {
    final db = await instance.database;

    return await db.delete(
      'incidencias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}