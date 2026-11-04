import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'posts.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE posts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          remote_id INTEGER UNIQUE,
          user_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          pendiente_sincronizar INTEGER NOT NULL DEFAULT 0
        )
      '''),
    );
    return _db!;
  }

  static Future<void> reiniciarParaTests() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    try {
      final ruta = join(await getDatabasesPath(), 'posts.db');
      await databaseFactory.deleteDatabase(ruta);
    } catch (_) {}
  }

  // ---------- CRUD local ----------
  static Future<int> insertarLocal({
    required int userId,
    required String title,
    required String body,
  }) async {
    final db = await database;
    return db.insert('posts', {
      'remote_id': null,
      'user_id': userId,
      'title': title,
      'body': body,
      'pendiente_sincronizar': 1,
    });
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final db = await database;
    return db.query('posts', orderBy: 'id DESC');
  }

  static Future<int> actualizarLocal(
    int id, {
    required int userId,
    required String title,
    required String body,
  }) async {
    final db = await database;
    return db.update(
      'posts',
      {
        'user_id': userId,
        'title': title,
        'body': body,
        'pendiente_sincronizar': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Sincronización con la API ----------
  static Future<int> upsertRemoto({
    required int remoteId,
    required int userId,
    required String title,
    required String body,
  }) async {
    final db = await database;
    final existe = await db.query('posts',
        where: 'remote_id = ?', whereArgs: [remoteId], limit: 1);
    if (existe.isEmpty) {
      return db.insert('posts', {
        'remote_id': remoteId,
        'user_id': userId,
        'title': title,
        'body': body,
        'pendiente_sincronizar': 0,
      });
    }
    if (existe.first['pendiente_sincronizar'] == 1) return 0;
    return db.update(
      'posts',
      {'user_id': userId, 'title': title, 'body': body},
      where: 'remote_id = ?',
      whereArgs: [remoteId],
    );
  }

  static Future<int> contarPendientes() async {
    final db = await database;
    final r = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM posts WHERE pendiente_sincronizar = 1');
    return (r.first['c'] as int?) ?? 0;
  }

  static Future<int> marcarTodosSincronizados() async {
    final db = await database;
    return db.update(
      'posts',
      {'pendiente_sincronizar': 0},
      where: 'pendiente_sincronizar = 1',
    );
  }
}
