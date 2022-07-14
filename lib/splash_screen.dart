import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_note_app/main.dart';
import 'package:my_note_app/second_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);
  @override
  
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
     Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>NoteScreen(),
            )));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: const Center(
        child: Text("MyNote",style:
         TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.amber),),
      ),
    );
  }
}