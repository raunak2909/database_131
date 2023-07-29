import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase{
  //for singleton database class
  AppDataBase._();
  static final AppDataBase db = AppDataBase._();

  //database variable
  Database? _database;

  Future<Database> getDB() async{
    if(_database != null){
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(documentDirectory.path, "noteDB.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version){

        //create tables here
        db.execute("Create table note ( note_id integer primary key autoincrement, title text, desc text )");

      }
    );

  }


  Future<bool> addNote(String title, String desc) async{

    var db = await getDB();

    int rowsEffect = await db.insert('note', {'title' : title, 'desc' : desc});

    if(rowsEffect>0){
      return true;
    } else {
      return false;
    }

  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async{
    var db = await getDB();

    List<Map<String, dynamic>> notes = await db.query('note');

    return notes;
  }

}