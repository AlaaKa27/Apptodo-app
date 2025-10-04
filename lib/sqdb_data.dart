import 'package:flutter_application_1/modles.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    if (_db != null) return _db!;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "ALAA.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL )
       ''');
      },
    );
    return _db!;
  }

  static Future<int> insertNote(Note note) async {
    final db = await initDB();
    return await db.insert('notes', note.toMap());
  }

  static Future<List<Note>> getNotes() async {
    final db = await initDB();
    final resulet = await db.query('notes', orderBy: 'id DESC');
    return resulet.map((map) => Note.formMap(map)).toList();
  }

  static Future<int> updateNote(Note note) async {
    final db = await initDB();
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> deleteNote(int id) async {
    final db = await initDB();
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
