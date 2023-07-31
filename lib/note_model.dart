import 'app_database.dart';

class NoteModel{
  int? note_id;
  String title;
  String desc;

  NoteModel({this.note_id, required this.title, required this.desc});

  //creating a note model from map data
  factory NoteModel.fromMap(Map<String, dynamic> map){
    return NoteModel(
      note_id: map[AppDataBase.NOTE_COLUMN_ID],
      title: map[AppDataBase.NOTE_COLUMN_TITLE],
      desc: map[AppDataBase.NOTE_COLUMN_DESC],
    );
  }

  //creating a map data from note model
  Map<String, dynamic> toMap(){
    return {
      AppDataBase.NOTE_COLUMN_ID: note_id,
      AppDataBase.NOTE_COLUMN_TITLE: title,
      AppDataBase.NOTE_COLUMN_DESC: desc
    };
  }

}

