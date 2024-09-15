import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nombre = ''; // Aquí se almacena el estado del nombre

  final TextEditingController _controller =
      TextEditingController(); // Controlador para el TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra los elementos en la columna
          children: [
            TextField(
              controller: _controller, // Asocia el controlador al TextField
              decoration: const InputDecoration(
                labelText: 'Inserta tu nombre',
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              onPressed: () {
                setState(() {
                  nombre = _controller
                      .text; // Actualiza el estado con el valor del TextField
                });
              },
              child: const Text('Enviar'),
            ),
            Text('Hola $nombre'),
          ],
        ),
      ),
    );
  }
}