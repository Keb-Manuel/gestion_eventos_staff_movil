import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

class TareasDB {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final ruta = join(await getDatabasesPath(), 'gestor_tareas.db');

    return await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tareas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // Crear tarea
  Future<int> insertarTarea(Tarea tarea) async {
    final db = await database;
    return await db.insert('tareas', tarea.toMap());
  }

  // Consultar todas las tareas
  Future<List<Tarea>> obtenerTareas() async {
    final db = await database;

    final resultado = await db.query(
      'tareas',
      orderBy: 'id DESC',
    );

    return resultado.map((map) => Tarea.fromMap(map)).toList();
  }

  // Editar tarea
  Future<int> actualizarTarea(Tarea tarea) async {
    final db = await database;

    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  // Eliminar tarea
  Future<int> eliminarTarea(int id) async {
    final db = await database;

    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Marcar tarea como completada o pendiente
  Future<int> cambiarEstado(Tarea tarea) async {
    final db = await database;

    return await db.update(
      'tareas',
      {'completada': tarea.completada ? 1 : 0},
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }
}
