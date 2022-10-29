import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:grace_nation/core/models/notes_model.dart';

class NotesDBWorker {
  NotesDBWorker._();
  static final NotesDBWorker db = NotesDBWorker._();

  Database? _db;

  Future get database async {
    _db = _db ?? await init();

    return _db;
  }

  Future<Database> init() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, "notes.db");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute(
        "CREATE TABLE notes(note_id INTEGER PRIMARY KEY autoincrement, title TEXT, content TEXT, date TEXT)",
      );
    });
    return db;
  }

  Note noteFromMap(Map map) {
    Note note = Note();
    note.id = map["note_id"];
    note.title = map["title"];
    note.content = map["content"];
    note.date = map["date"];
    return note;
  }

  Map<String, dynamic> noteToMap(Note inNote) {
    Map<String, dynamic> inMap = Map<String, dynamic>();
    inMap["note_id"] = inNote.id;
    inMap["title"] = inNote.title;
    inMap["content"] = inNote.content;
    inMap["date"] = inNote.date;
    return inMap;
  }

  Future create(Note note) async {
    Database db = await database;
    var val =
        await db.rawQuery("SELECT MAX(note_id) + 1 AS note_id FROM notes");
    var id = val.first["note_id"];
    id = id ?? 1;
    return await db.rawInsert(
        "INSERT INTO notes(note_id,title,content,date)"
        "VALUES (?,?,?,?)",
        [id, note.title, note.content, note.date]);
  }

  Future<Note> get(int inID) async {
    Database db = await database;
    var rec = await db.query("notes", where: "note_id = ?", whereArgs: [inID]);
    return noteFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("notes");
    var list = recs.isNotEmpty ? recs.map((m) => noteFromMap(m)).toList() : [];
    return list;
  }

  Future update(Note note) async {
    Database db = await database;
    var upd = await db.update("notes", noteToMap(note),
        where: "note_id = ?", whereArgs: [note.id]);
    return upd;
  }

  Future delete(int id) async {
    Database db = await database;
    return db.delete("notes", where: "note_id = ?", whereArgs: [id]);
  }
}
