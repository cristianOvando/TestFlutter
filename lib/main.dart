import 'package:flutter/material.dart';
import 'package:testflutter/screnn/StudentList.dart';
import 'package:testflutter/screnn/contacts.dart';
import 'package:testflutter/screnn/home.dart';
import 'package:testflutter/screnn/StudentForm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      initialRoute: '/home', 
      routes: {
        '/home': (context) => HomeScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/studentform': (context) => StudentForm(),
        '/studentlist': (context) => StudentList(),
      },
    );
  }
}
