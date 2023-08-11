import 'package:database_131/add_note_page.dart';
import 'package:database_131/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'app_database.dart';
import 'note_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => NoteProvider(),
    child: const MyApp(),
  ));
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
  //late AppDataBase myDB;
  List<NoteModel> arrNotes = [];

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  void getInitialNotes(BuildContext context) {
    context.read<NoteProvider>().fetchNotes();
  }


  @override
  Widget build(BuildContext context) {
    getInitialNotes(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
        ),
        body: Consumer<NoteProvider>(
          builder: (_, provider, __) {
            return ListView.builder(
                itemCount: provider
                    .getNotes()
                    .length,
                itemBuilder: (_, index) {
                  var currData = provider.getNotes()[index];
                  return InkWell(
                    onTap: () {
                      //Update the Note
                      //titleController.text = currData.title;
                      //descController.text = currData.desc;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddNotePage(
                            isUpdate: true,
                            title: currData.title,
                            desc: currData.desc,),));
                      /*showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                                height: 400,
                                child: Column(children: [
                                  Text('Update Note',
                                      style: TextStyle(fontSize: 21)),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                        hintText: 'Enter Title',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(21.0))),
                                  ),
                                  TextField(
                                    controller: descController,
                                    decoration: InputDecoration(
                                        hintText: 'Enter Desc',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(21.0))),
                                  ),
                                  ElevatedButton(
                                      child: Text('Update'),
                                      onPressed: () async {}),
                                ]));
                          });*/
                    },
                    child: ListTile(
                        title: Text(currData.title),
                        subtitle: Text(currData.desc),
                        trailing: InkWell(
                            onTap: () async {}, child: Icon(Icons.delete))),
                  );
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotePage(isUpdate: false,),
                  ));

              /*showModalBottomSheet(
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

                                addNotes(title, desc, context);
                                titleController.text = "";
                                descController.clear();
                                Navigator.pop(context);
                              }),
                        ]));
                  });*/
            },
            child: Icon(Icons.add)));
  }
}
