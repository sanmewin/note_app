import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_note_app/database_helper.dart';
import 'package:my_note_app/note_details.dart';
import 'package:my_note_app/notes.dart';

import 'main.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);
  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Color priorityStatusCheck(String priority) {
    if (priority == "High") {
      return Colors.red;
    }
    if (priority == "Medium") {
      return Colors.teal;
    }
    if (priority == "Low") {
      return const Color(0xffFA7D09);
    }
    return Colors.white;
  }

  bool isChanged = true;
  int countNum = 2;
  @override
  Widget build(BuildContext context) {
    List<Notes> noteList = [];
    Future<List<Notes>> getNote() async {
      noteList = await databaseHelper.retrieveNotes();
      return noteList;
    }

    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: const Color(0xff212121),
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const Text(""),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    if (isChanged) {
                      isChanged = false;
                      countNum = 1;
                    } else {
                      isChanged = true;
                      countNum = 2;
                    }
                  });
                },
                icon: Icon(isChanged
                    ? Icons.format_align_justify_outlined
                    : Icons.apps)),
          )
        ],
      ),
      body: FutureBuilder<List<Notes>>(
          future: getNote(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Notes>> asyncSnapshot) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                child: StaggeredGrid.count(
                  crossAxisCount: countNum,
                  children: [
                    for (Notes notes in noteList)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => NoteDetails(
                                          id: notes.id!.toInt(),
                                        )))).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(notes.color),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 25,
                                        color:
                                            priorityStatusCheck(notes.prority),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: SizedBox(
                                        height: 20,
                                        width: double.infinity,
                                        child: Text(
                                          notes.title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration: notes.status == 0
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 5, right: 10),
                                  child: SizedBox(
                                    height: 20,
                                    width: double.infinity,
                                    child: Text(
                                      notes.body,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        decoration: notes.status == 0
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 20, bottom: 20),
                                  child: Text(
                                    "Date ${notes.date}",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      decoration: notes.status == 0
                                          ? TextDecoration.none
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyNote(
                        isEdit: false,
                      ))).then((value) {
            setState(() {});
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
