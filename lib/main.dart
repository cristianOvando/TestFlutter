import 'package:flutter/material.dart';
import 'package:testflutter/screnn/project1.dart';
import 'package:testflutter/screnn/project2.dart';
import 'package:url_launcher/url_launcher.dart';


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
      home: MainScreen(),
      routes: {
        '/proyecto1': (context) => Project1Screen(),
        '/proyecto2': (context) => Project2Screen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  final String name = 'Mi repositorio'; 
  final String url = 'https://github.com/cristianOvando/TestFlutter'; 

  Future<void> _launchURL() async {
    final Uri link = Uri.parse(url);
    if (!await launchUrl(link)) {
      throw 'No se pudo abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Visitar Mi Link'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/proyecto1');
              },
              child: Text('Ir a Proyecto 1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/proyecto2');
              },
              child: Text('Ir a Proyecto 2'),
            ),
          ],
        ),
      ),
    );
  }
}
