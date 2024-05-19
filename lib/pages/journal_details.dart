import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data/journal.dart';
class JournalDetailPage
 extends StatefulWidget {
  Entry journalDetails;
  final TextEditingController updateController;
  final void Function(String id) editEntry;
  final void Function(String id) deleteEntry;
  JournalDetailPage
  ({
    required this.journalDetails, 
    required this.updateController,
    required this.editEntry,
    required this.deleteEntry
  });

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  bool isEditing = false;
  void setEditing() {
    setState(() {
      isEditing = true;
      widget.updateController.text = widget.journalDetails.journalText;
    });
  }
  void finishEditing() {
    setState(() {
      isEditing = false;
      widget.journalDetails.journalText = widget.updateController.text;
      widget.editEntry(widget.journalDetails.id);
    });
  }
  void delete() {
    widget.deleteEntry(widget.journalDetails.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow,
        title: Text(widget.journalDetails.title),
      ),
      body: Container(
        height: 400,
        padding: EdgeInsets.only(left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: !isEditing ?
          [
            Text(
              widget.journalDetails.journalText,
              style: GoogleFonts.raleway(fontSize: 16)
            ),
            Container(
              width: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: setEditing,
                    child: Icon(Icons.edit)
                  ),
                  ElevatedButton(
                    onPressed: delete,
                    child: Icon(Icons.delete)
                  ),
                ],
              ),
            )
          ] :
          [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.updateController,
                maxLines: null,
                minLines: 4,
                style: GoogleFonts.raleway(fontSize: 16),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "update"
                ),
              ),
            ),
            ElevatedButton(
              onPressed: finishEditing,
              child: Icon(Icons.done)
            )
          ],
        ),
      )
    );
  }
}