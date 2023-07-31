import 'package:flutter/material.dart';

import 'app_database.dart';
import 'note_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "My Database"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;

  MyHomePage({required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppDataBase myDB;
  List<NoteModel> arrNotes = [];

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  initState() {
    super.initState();
    myDB = AppDataBase.db;

    getNotes();
  }

  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
    setState(() {});
  }

  void addNotes(String title, String desc) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));

    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
        ),
        body: ListView.builder(
            itemCount: arrNotes.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: (){
                  titleController.text = arrNotes[index].title;
                  descController.text = arrNotes[index].desc;
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            height: 400,
                            child: Column(children: [
                              Text('Update Note', style: TextStyle(fontSize: 21)),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                    hintText: 'Enter Title',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21.0))),
                              ),
                              TextField(
                                controller: descController,
                                decoration: InputDecoration(
                                    hintText: 'Enter Desc',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21.0))),
                              ),
                              ElevatedButton(
                                  child: Text('Update'),
                                  onPressed: () async{
                                    var mTitle = titleController.text.toString();
                                    var mDesc = descController.text.toString();
                                    await myDB.updateNote(NoteModel(note_id: arrNotes[index].note_id, title: mTitle, desc: mDesc));
                                    getNotes();
                                    titleController.text = "";
                                    descController.clear();
                                    Navigator.pop(context);
                                  }),
                            ]));
                      });
                },
                child: ListTile(
                    title: Text(arrNotes[index].title),
                    subtitle: Text(arrNotes[index].desc),
                    trailing: InkWell(onTap: () async{
                      await myDB.deleteNote(arrNotes[index].note_id!);
                      getNotes();
                    }, child: Icon(Icons.delete))),
              );
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: 400,
                        child: Column(children: [
                          Text('Add Note', style: TextStyle(fontSize: 21)),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'Enter Title',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21.0))),
                          ),
                          TextField(
                            controller: descController,
                            decoration: InputDecoration(
                                hintText: 'Enter Desc',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(21.0))),
                          ),
                          ElevatedButton(
                              child: Text('Add'),
                              onPressed: () {
                                var title = titleController.text.toString();
                                var desc = descController.text.toString();

                                addNotes(title, desc);
                                titleController.text = "";
                                descController.clear();
                                Navigator.pop(context);
                              }),
                        ]));
                  });
            },
            child: Icon(Icons.add)));
  }
}
