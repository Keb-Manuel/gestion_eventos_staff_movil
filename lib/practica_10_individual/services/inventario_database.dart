import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/producto.dart';

class InventarioDatabase {
  static final InventarioDatabase instance = InventarioDatabase._init();

  static Database? _database;

  InventarioDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stocksmart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        apiId INTEGER,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        precio REAL NOT NULL,
        stock INTEGER NOT NULL,
        stockMinimo INTEGER NOT NULL,
        imagen TEXT,
        fechaRegistro TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarProducto(Producto producto) async {
    final db = await instance.database;

    return await db.insert(
      'productos',
      producto.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Producto>> obtenerProductos() async {
    final db = await instance.database;

    final resultado = await db.query(
      'productos',
      orderBy: 'nombre COLLATE NOCASE ASC',
    );

    return resultado.map((map) => Producto.fromMap(map)).toList();
  }

  Future<Producto?> obtenerProducto(int id) async {
    final db = await instance.database;

    final resultado = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) return null;

    return Producto.fromMap(resultado.first);
  }

  Future<int> actualizarProducto(Producto producto) async {
    if (producto.id == null) {
      throw ArgumentError('El producto debe tener un ID para actualizarse.');
    }

    final db = await instance.database;

    return await db.update(
      'productos',
      producto.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<int> eliminarProducto(int id) async {
    final db = await instance.database;

    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> existeProductoApi(int apiId) async {
    final db = await instance.database;

    final resultado = await db.query(
      'productos',
      columns: ['id'],
      where: 'apiId = ?',
      whereArgs: [apiId],
      limit: 1,
    );

    return resultado.isNotEmpty;
  }

  Future<void> cerrar() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}