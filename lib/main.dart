import 'package:flutter/material.dart';
import 'package:testflutter/screnn/StudentList.dart';
import 'package:testflutter/screnn/contacts.dart';
import 'package:testflutter/screnn/home.dart';
import 'package:testflutter/screnn/StudentForm.dart';
import 'package:testflutter/screnn/text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      initialRoute: '/home', 
      routes: {
        '/home': (context) => const HomeScreen(),
        '/contacts': (context) => const ContactsScreen(),
        '/text':(context) => const TextScreen(),
        '/studentform': (context) => const StudentForm(),
        '/studentlist': (context) => const StudentList(),
      },
    );
  }
}
