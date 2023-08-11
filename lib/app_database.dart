import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class AppDataBase{
  //for singleton database class
  AppDataBase._();
  static final AppDataBase db = AppDataBase._();

  //database variable
  Database? _database;
  //note(
  static final NOTE_TABLE = "note";
  static final NOTE_COLUMN_ID = "note_id";
  static final NOTE_COLUMN_TITLE = "title";
  static final NOTE_COLUMN_DESC = "desc";



  Future<Database> getDB() async{
    if(_database != null){
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }

  Future<Database> initDB() async{

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(documentDirectory.path, "noteDB.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async{
        //create tables here
        db.execute("Create table $NOTE_TABLE ( $NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE text, $NOTE_COLUMN_DESC text)");
      }
    );

  }


  Future<bool> addNote(NoteModel note) async{

    var db = await getDB();

    int rowsEffect = await db.insert(NOTE_TABLE, note.toMap());

    return rowsEffect>0;

  }

  Future<List<NoteModel>> fetchAllNotes() async{
    var db = await getDB();

    List<Map<String, dynamic>> notes = await db.query(NOTE_TABLE);

    List<NoteModel> listNotes = [];

    for(Map<String, dynamic> note in notes){
      listNotes.add(NoteModel.fromMap(note));
    }

    return listNotes;
  }


  Future<bool> updateNote(NoteModel note) async{

    var db = await getDB();

    var count = await db.update(NOTE_TABLE, note.toMap(), where: "$NOTE_COLUMN_ID = ${note.note_id}");

    return count>0;
  }

  Future<bool> deleteNote(int id) async {

    var db = await getDB();

    var count = await db.delete(NOTE_TABLE, where: "$NOTE_COLUMN_ID = ?", whereArgs: ['$id']);

    return count>0;
  }

}