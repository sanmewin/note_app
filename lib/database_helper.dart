import 'package:sqflite/sqflite.dart';

import 'notes.dart';

class DatabaseHelper {
  String notesTable = 'noteTable';
  String colId = 'id';
  String colTitle = 'title';
  String colBody = 'body';
  String colDate = 'date';
  String colColor = 'color';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> initializeDb() async {
    String path = await getDatabasesPath();

    return openDatabase(
      (path + 'notes.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE $notesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT NOT NULL, $colBody TEXT NOT NULL,$colDate TEXT NOT NULL,$colColor INTEGER NOT NULL,$colPriority TEXT NOT NULL,$colStatus INTEGER NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertNote(Notes notes) async {
    int result = 0;
    final Database db = await initializeDb();
    result = await db.insert(notesTable, notes.toMap());

    return result;
  }

  Future<List<Notes>> retrieveNotes() async {
    final Database db = await initializeDb();
    final List<Map<String, Object?>> queryResult = await db.query(notesTable);
    return queryResult.map((e) => Notes.fromMap(e)).toList();
  }

  Future<List<Notes>> findById(int id) async {
    final Database db = await initializeDb();
    final List<Map<String, Object?>> queryResult = await db.query(
      notesTable,
      where: "$colId = ?",
      whereArgs: [id],
    );
    return queryResult.map((e) => Notes.fromMap(e)).toList();
  }

  Future<void> deleteNote(
    int id,
  ) async {
    final db = await initializeDb();
    await db.delete(
      notesTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateNote(Notes notes) async {
    final db = await initializeDb();
    final int result = await db.update(
      notesTable,
      notes.toMap(),
      where: "$colId = ?",
      whereArgs: [notes.id],
    );
    return result;
  }
}
