import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_note_app/database_helper.dart';
import 'package:my_note_app/notes.dart';
import 'package:my_note_app/splash_screen.dart';

enum PriorityStatus { low, medium, high }
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => const SplashScreen(),
    },
  ));
}

class MyNote extends StatefulWidget {
  Notes? edit;
  final bool isEdit;

  MyNote({
    Key? key,
    required this.isEdit,
    this.edit,
  }) : super(key: key);
  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  Color color = const Color(0xffD7ACD4);
  List<Color> colorPick = const [
    Color(0xffBB6464),
    Color(0xff7882A4),
    Color(0xff54BAB9),
    Color(0xffFF9F80),
    Color(0xffC3DBD9),
    Color(0xffB8405E),
    Color(0xffD3ECA7),
    Color(0xffFFADF0),
    Color(0xffC1DEAE),
    Color(0xff7897AB),
    Color(0xffFF9F50),
    Color(0xffFC28FB),
    Color(0xffC1A3A3),
    Color(0xffFFE162),
    Color(0xffE60965),
    Color(0xffCDDEFF),
    Color(0xff35589A),
    Color(0xff06FF00),
    Color(0xff781D42),
    Color(0xff84DFFF),
    Color(0xff98BAE7),
    Color(0xffFFC4E1),
    Color(0xff66806A),
    Color(0xffB91646),
    Color(0xffE5890A)
  ];
  PriorityStatus priorityStatus = PriorityStatus.medium;

  String priority = "medium";
  dynamic selectedIndex;

  @override
  void initState() {
    DatabaseHelper databaseHelper = DatabaseHelper();
    databaseHelper.initializeDb();
    if (widget.edit != null) {
      setState(() {
        titleController.text = widget.edit!.title;
        bodyController.text = widget.edit!.body;
      });
    }
    super.initState();
  }

  addNote() {
    databaseHelper.insertNote(Notes(
      title: titleController.text,
      body: bodyController.text,
      date: dateFormat.format(DateTime.now()),
      color: color.value,
      prority: priority,
      status: 0,
    ));
  }

  updateNote() {
    databaseHelper.updateNote(Notes(
      id: widget.edit!.id,
      title: titleController.text,
      body: bodyController.text,
      date: dateFormat.format(DateTime.now()),
      color: color.value,
      prority: priority,
      status: 0,
    ));
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        backgroundColor: const Color(0xff212121),
        centerTitle: true,
        title: Text(
          "Add Note",
          style: TextStyle(color: color),
        ),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priorityStatus = PriorityStatus.low;
                            priority = "Low";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: priorityStatus == PriorityStatus.low
                                  ? const Color(0xffFA7D09)
                                  : Colors.transparent,
                              border: Border.all(color: color)),
                          height: 40,
                          width: 125,
                          child: const Center(
                              child: Text(
                            "Low",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priorityStatus = PriorityStatus.medium;
                            priority = "Medium";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: priorityStatus == PriorityStatus.medium
                                  ? Colors.black
                                  : Colors.transparent,
                              border: Border.all(color: color)),
                          height: 40,
                          width: 125,
                          child: const Center(
                              child: Text(
                            "Medium",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priorityStatus = PriorityStatus.high;
                            priority = "High";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: priorityStatus == PriorityStatus.high
                                  ? const Color(0xffC70039)
                                  : Colors.transparent,
                              border: Border.all(color: color)),
                          height: 40,
                          width: 125,
                          child: const Center(
                              child: Text(
                            "High",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  itemCount: 16,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            color = colorPick[index];
                            selectedIndex = index;
                          });
                        },
                        child: CircleAvatar(
                            backgroundColor: colorPick[index],
                            radius: selectedIndex == index ? 30 : 25),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Note Title",
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: titleController,
                  cursorColor: color,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: color),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: color),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter something.';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Note Body",
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: bodyController,
                  cursorColor: color,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: color),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: color),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value == "") {
                      return 'Please enter something.';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: color,
          onPressed: () async {
            setState(() {
              if (formKey.currentState!.validate()) {
                if (widget.edit != null) {
                  updateNote();
                } else {
                  addNote();
                }
                Navigator.pop(context);
                titleController.clear();
                bodyController.clear();
              }
            });
          },
          child:
              widget.isEdit ? const Icon(Icons.edit) : const Icon(Icons.add)),
    );
  }
}
