import 'package:flutter/material.dart';
import 'package:testflutter/screnn/geolocator.dart';
import 'package:testflutter/screnn/home.dart';
import 'package:testflutter/screnn/qrflutter.dart';
import 'package:testflutter/screnn/sensorplus.dart';
import 'package:testflutter/screnn/speech.dart';
import 'package:testflutter/screnn/text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 205, 243, 33),
          centerTitle: true,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    const LocationStatusScreen(),
    QrCodeScanner(),
    SensorPlusPage(),
    SpeechToTextView(),
    TextToSpeechView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,  
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'Geolocalización',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Habla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: 'Sonido',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 24, 102, 0), // Color del ícono seleccionado
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Color de los íconos no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}
