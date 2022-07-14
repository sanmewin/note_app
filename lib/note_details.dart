import 'package:flutter/material.dart';
import 'package:my_note_app/second_screen.dart';
import 'ExpandableFab/expandableFB.dart';
import 'database_helper.dart';
import 'main.dart';
import 'notes.dart';

class NoteDetails extends StatefulWidget {
  final int id;
  NoteDetails({Key? key, required this.id}) : super(key: key);
  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  bool isChecked = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notes> list = [];
  Future<List<Notes>> noteById(int id) async {
    list = await databaseHelper.findById(id);
    return list;
  }

  showDeletingMessage(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade200,
        title: const Text('Are you sure you want to delete?'),
        content: const Text("This notes will be deleted!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
                ModalRoute.withName("/"),
              );
              setState(() {
                databaseHelper.deleteNote(id);
              });
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  checkedNote() {
    for (Notes notes in list) {
      databaseHelper.updateNote(Notes(
          id: notes.id,
          title: notes.title,
          body: notes.body,
          date: notes.date,
          color: notes.color,
          prority: notes.prority,
          status: 1));
    }
  }

  unchecked() {
    for (Notes notes in list) {
      databaseHelper.updateNote(Notes(
          id: notes.id,
          title: notes.title,
          body: notes.body,
          date: notes.date,
          color: notes.color,
          prority: notes.prority,
          status: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: const Color(0xff212121),
        title: const Text("Details",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Notes>>(
          future: noteById(widget.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Notes>> asyncSnapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (Notes note in list)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 220, top: 10, bottom: 10),
                          child: Text(
                            note.date,
                            style: TextStyle(
                              color: Color(note.color),
                              fontSize: 18,
                              decoration: note.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Text(
                            note.title,
                            style: TextStyle(
                              color: Color(note.color),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              decoration: note.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Text(
                            note.body,
                            style: TextStyle(
                              color: Color(note.color),
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              decoration: note.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
            );
          }),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              setState(() {
                for (Notes notes in list) {
                  if (notes.status == 0) {
                    isChecked = false;
                    checkedNote();
                    final snackBar = SnackBar(
                      content: Text(
                        "You've read this note.",
                        style:
                            TextStyle(color: Color(notes.color), fontSize: 20),
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            unchecked();
                          });
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    unchecked();
                    final snackBar = SnackBar(
                      content: Text(
                        "You haven't read this note yet.",
                        style:
                            TextStyle(color: Color(notes.color), fontSize: 20),
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            checkedNote();
                          });
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              });
            },
            icon: const Icon(Icons.check),
          ),
          ActionButton(
            onPressed: () {
              setState(() {
                showDeletingMessage(context, widget.id);
              });
            },
            icon: const Icon(Icons.delete),
          ),
          ActionButton(
            onPressed: () {
              for (Notes notes in list) {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyNote(
                          isEdit: true,
                          edit: notes,
                        ),
                      )).then((value) {
                    setState(() {});
                  });
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //         backgroundColor: Colors.white,
      //         onPressed: () {
      //           setState(() {
      //             for (Notes notes in list) {
      //               if (notes.status == 0 ) {
      //                 isChecked=false;
      //                 checkedNote();
      //                 final snackBar = SnackBar(
      //                   content: Text(
      //                     "You've read this note.",
      //                     style: TextStyle(
      //                         color: Color(notes.color), fontSize: 20),
      //                   ),
      //                   action: SnackBarAction(
      //                     label: 'Undo',
      //                     onPressed: () {
      //                       setState(() {
      //                         unchecked();
      //                       });
      //                     },
      //                   ),
      //                 );
      //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //               } else {

      //                 unchecked();
      //                 final snackBar = SnackBar(
      //                   content: Text(
      //                     "You haven't read this note yet.",
      //                     style: TextStyle(
      //                         color: Color(notes.color), fontSize: 20),
      //                   ),
      //                   action: SnackBarAction(
      //                     label: 'Undo',
      //                     onPressed: () {
      //                       setState(() {
      //                         checkedNote();
      //                       });
      //                     },
      //                   ),
      //                 );
      //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //               }
      //             }
      //           });
      //         },
      //         child: isChecked
      //             ? const Icon(
      //                 Icons.undo_rounded,
      //                 color: Colors.black,
      //               )
      //             : const Icon(
      //                 Icons.check,
      //                 color: Colors.black,
      //               )),
      //     const SizedBox(width: 20),
      //     FloatingActionButton(
      //       backgroundColor: Colors.white,
      //       onPressed: () {
      //         setState(() {
      //           showDeletingMessage(context, widget.id);
      //         });
      //       },
      //       child: const Icon(
      //         Icons.delete,
      //         color: Colors.black,
      //       ),
      //       heroTag: 0,
      //     )
      //   ],
      // ),
    );
  }
}
