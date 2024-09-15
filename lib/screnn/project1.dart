import 'package:flutter/material.dart';

class Project1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyecto 1'),
      ),
      body: Center(
        child: Text(
          'Pantalla de Proyecto 1',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
