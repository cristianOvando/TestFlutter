import 'package:flutter/material.dart';
import 'package:testflutter/screnn/StudentForm.dart';
import 'package:testflutter/screnn/chatbot.dart';
import 'package:testflutter/screnn/contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String carrera = 'Ingeniería en Software';
  final String materia = 'Programación para Móviles II';
  final String cuatri = '9 B';
  final String name = 'Cristian Ovando Gómez';
  final String matricula = '221256';

  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('images/logoup.jpg'),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        carrera,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        materia,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Cuatrimestre: $cuatri',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Matrícula: $matricula',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                      'https://github.com/cristianOvando/TestFlutter');
                  if (!await launchUrl(url)) {
                    throw 'No se pudo abrir el enlace $url';
                  }
                },
                child: const Text('Visitar mi repositorio'),
              ),
            ],
          ),
        ),
      ),
      const ChatbotPage(),
      const ContactsScreen(),
      const StudentForm()
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TEST FLUTTER')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Student Form',
          ),
        ],
      ),
    );
  }
}
