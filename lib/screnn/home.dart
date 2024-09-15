import 'package:flutter/material.dart';
import 'package:testflutter/screnn/contacts.dart';
import 'package:testflutter/screnn/StudentForm.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String name = 'Cristian Ovando Gómez';
  final String url = 'https://github.com/cristianOvando/TestFlutter';

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Cristian Ovando Gómez',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final Uri url =
                  Uri.parse('https://github.com/cristianOvando/TestFlutter');
              if (!await launchUrl(url)) {
                throw 'No se pudo abrir el enlace $url';
              }
            },
            child: const Text('Visitar mi repositorio'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    const ContactsScreen(),
    StudentForm()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('221256')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'studentsform',
          ),
        ],
      ),
    );
  }
}
