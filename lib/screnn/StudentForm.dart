import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _lastName;

  // Función para enviar los datos a la API
  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // URL de la API (actualiza el puerto si es necesario)
      final url = Uri.parse('http://192.168.56.1:3000/api/student');

      // Datos a enviar
      final body = json.encode({
        'name': _name,
        'last_name': _lastName,
      });

      try {
        // Enviamos la solicitud POST
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        // Manejo de los códigos de estado 200 y 201
        if (response.statusCode == 201 || response.statusCode == 200) {
          // Registro exitoso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registro Exitoso')),
          );
        } else {
          // Fallo en el registro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar el estudiante')),
          );
        }
      } catch (error) {
        // Manejo de errores de conexión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión')),
        );
      }
    } else {
      // Si la validación falla, mostramos un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rellene los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Alumnos UP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Ingrese nombre/s del Alumno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Ingrese apellidos del Alumno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los apellidos';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _registerStudent,
                child: Text('Registrar Alumno'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/student_list'); // Navegar a la lista de estudiantes
                },
                child: Text('Ver Lista de Alumnos Registrados'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}