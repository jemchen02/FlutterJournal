import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data/journal.dart';
import 'package:flutter_demo/pages/journal_details.dart';
import 'package:flutter_demo/util/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  List<Entry> entries = <Entry>[];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController updateController = TextEditingController();
  DateTime now = DateTime.now();
  _HomePageState() {
    fs.collection("journals").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        entries.add(Entry(element.id, element.data()["title"], element.data()["journalText"], element.data()["date"]));
      });
      setState((){
      });
    }).catchError((error) {
      print("Failed to load journal entries");
      print(error.toString());
    });
  }
  void createNewEntry() {
    showDialog(
      context: context,
      builder:(context) {
        return DialogBox(
          titleController: titleController,
          textController: textController, 
          onSave: saveNewEntry,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
  void saveNewEntry() {
    setState(() {
      Entry newEntry = Entry("", titleController.text, textController.text, '${now.month.toString()}/${now.day.toString()}/${now.year.toString()}');
      entries.add(newEntry);
      fs.collection("journals").add({
        "title": titleController.text,
        "journalText": textController.text,
        "date": '${now.month.toString()}/${now.day.toString()}/${now.year.toString()}'
      }).then((value) {
        print("Successfully added entry");
        newEntry.id = value.id;
      }).catchError((error) {
        print("failed to add entry");
        print(error.toString());
      });
      titleController.clear();
      textController.clear();
    });
    Navigator.of(context).pop();
  }
  void editEntry(String id) {
    setState(() {
      int index = entries.indexWhere((entry) => entry.id == id);
      if(index != -1) {
        entries[index].journalText = updateController.text;
      }
      DocumentReference docRef = fs.collection("journals").doc(id);
      docRef.update({
        "journalText": updateController.text
      }).then((value) {
        print("Successfully updated entry");
      }).catchError((error) {
        print("failed to edit entry");
        print(error.toString());
      });
      updateController.clear();
    });
  }
  void deleteEntry(String id) {
    setState(() {
      entries.removeWhere((entry) => entry.id == id);
      DocumentReference docRef = fs.collection("journals").doc(id);
      docRef.delete()
      .then((value) {
        print("Successfully removed entry");
      }).catchError((error) {
        print("failed to remove entry");
        print(error.toString());
      });
    });
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Home"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder:(context, index) {
          return ListTile(
            tileColor: index % 2 == 0 ? Color.fromARGB(255, 235, 235, 235) : Colors.white,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => JournalDetailPage(
                journalDetails: entries[index], 
                updateController: updateController, 
                editEntry: editEntry, 
                deleteEntry: deleteEntry
              )));
            },
            title: Container(
              height: 50,
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              child: Center(
                child: Row(
                  children: [        
                    Text(
                      entries[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      )
                    ),
                    Spacer(),
                    Text(entries[index].date)
                  ],
                ),
                )
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewEntry,
        child: Icon(Icons.add),
      ),
    );
  }
}