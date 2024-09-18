import 'package:flutter/material.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  String nombre = ''; // Aquí se almacena el estado del nombre

  final TextEditingController _controller =
      TextEditingController(); // Controlador para el TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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