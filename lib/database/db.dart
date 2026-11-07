import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;

  // Obtener o crear la base de datos
  static Future<Database> get database async {
    if (_db != null) return _db!;

    final ruta = path.join(
      await getDatabasesPath(),
      'notas.db',
    );

    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  // Insertar una nota
  static Future<int> insertar(
    String titulo,
    String contenido,
  ) async {
    final db = await database;

    return db.insert('notas', {
      'titulo': titulo,
      'contenido': contenido,
    });
  }

  // Consultar todas las notas
  static Future<List<Map<String, dynamic>>> listar() async {
    final db = await database;

    return db.query(
      'notas',
      orderBy: 'id DESC',
    );
  }

  // Actualizar una nota
  static Future<int> actualizar(
    int id,
    String titulo,
    String contenido,
  ) async {
    final db = await database;

    return db.update(
      'notas',
      {
        'titulo': titulo,
        'contenido': contenido,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar una nota
  static Future<int> eliminar(int id) async {
    final db = await database;

    return db.delete(
      'notas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
