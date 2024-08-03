import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_experimental.dart';
import 'screens/home_notes.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      //to change the status bar above the appbar
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes And TodoList App',
      home: NotesHome(),
      //routes to navigate for drawer

    );
  }
}

