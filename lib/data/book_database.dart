import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class BookDatabase {
  BookDatabase._();
  static final BookDatabase instance = BookDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      p.join(dbPath, 'biblioteca_personal.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            book_key TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            year INTEGER,
            cover_id INTEGER,
            notes TEXT NOT NULL DEFAULT '',
            photo_path TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<Book>> getAll() async {
    final db = await database;
    final rows = await db.query('books', orderBy: 'title COLLATE NOCASE');
    return rows.map(Book.fromMap).toList();
  }

  Future<void> save(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String key) async {
    final db = await database;
    await db.delete('books', where: 'book_key = ?', whereArgs: [key]);
  }

  Future<bool> contains(String key) async {
    final db = await database;
    final rows = await db.query('books',
        columns: ['book_key'],
        where: 'book_key = ?',
        whereArgs: [key],
        limit: 1);
    return rows.isNotEmpty;
  }
}
