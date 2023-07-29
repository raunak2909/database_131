import 'package:flutter/material.dart';

import 'app_database.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppDataBase myDB;
  List<Map<String, dynamic>> arrNotes = [];

  @override
  initState() {
    super.initState();
    myDB = AppDataBase.db;

    addNotes();
  }

  void addNotes() async {
    bool check = await myDB.addNote("Flutter", "new flutter note");

    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Database'),
        ),
        body: ListView.builder(
            itemCount: arrNotes.length,
            itemBuilder: (_, index) {
              return ListTile(
                  title: Text('${arrNotes[index]['title']}'),
                  subtitle: Text('${arrNotes[index]['desc']}'));
            }),
        floatingActionButton: FloatingActionButton(onPressed: () {
          addNotes();
        }, child: Icon(Icons.add)
        ));
  }
}
