import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;
  static const _nombreDb = 'tareas.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), _nombreDb);
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, v) => db.execute('''
        CREATE TABLE tareas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          descripcion TEXT NOT NULL,
          completada INTEGER NOT NULL DEFAULT 0,
          fecha_creacion TEXT NOT NULL
        )
      '''),
    );
    return _db!;
  }

  // ── CRUD ────────────────────────────────────────────────────
  static Future<int> insertarTarea({
    required String titulo,
    required String descripcion,
  }) async {
    final db = await database;
    return db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': 0,
      'fecha_creacion': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> listarTareas({
    bool? soloCompletadas,
  }) async {
    final db = await database;
    String? where;
    if (soloCompletadas == true) where = 'completada = 1';
    if (soloCompletadas == false) where = 'completada = 0';
    return db.query('tareas', where: where, orderBy: 'id DESC');
  }

  static Future<int> actualizarTarea(
    int id, {
    required String titulo,
    required String descripcion,
    required bool completada,
  }) async {
    final db = await database;
    return db.update(
      'tareas',
      {
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> toggleCompletada(int id, bool completada) async {
    final db = await database;
    return db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminarTarea(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }

  // ── utilidades para tests ───────────────────────────────────
  static Future<void> cerrarParaTests() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  static Future<void> reiniciarParaTests() async {
    await cerrarParaTests();
    try {
      final ruta = join(await getDatabasesPath(), _nombreDb);
      await databaseFactory.deleteDatabase(ruta);
    } catch (_) {}
  }
}