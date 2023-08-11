import 'package:database_131/app_database.dart';
import 'package:flutter/material.dart';

import 'note_model.dart';

class NoteProvider extends ChangeNotifier{

  List<NoteModel> _arrNotes = [];
  AppDataBase db = AppDataBase.db;

  //to get initial notes when app is opened
  fetchNotes() async{
    _arrNotes = await db.fetchAllNotes();
    notifyListeners();
  }

  //to add note
  addNote(NoteModel newNote) async{
    var check = await db.addNote(newNote);

    if(check){
      /*_arrNotes = await db.fetchAllNotes();
      notifyListeners();*/
      fetchNotes();
    }
  }



  List<NoteModel> getNotes(){
    return _arrNotes;
  }




}