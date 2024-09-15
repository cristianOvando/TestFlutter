import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; 

class ButtonStyleClass {
  static ButtonStyle blackButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class TextFieldClass extends StatelessWidget {
  final String labelText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  const TextFieldClass({
    Key? key,
    required this.labelText,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _lastName;
  bool _isLoading = false;

  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse(
          'http://10.0.2.2:5001/api/student'); 
      final body = json.encode({
        'name': _name,
        'last_name': _lastName,
      });

      try {
        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: body,
            )
            .timeout(const Duration(seconds: 10)); 

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201 || response.statusCode == 200) {
          _showSnackBar('Registro Exitoso');
        } else {
          _showSnackBar('Error al registrar el estudiante. Código: ${response.statusCode}');
        }
      } on SocketException catch (_) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('El servidor no responde, por favor intente de nuevo más tarde.');
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('No se pudo conectar con el servidor. Error: $error');
      }
    } else {
      _showSnackBar('Por favor, complete todos los campos antes de continuar.');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Alumnos UP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldClass(
                labelText: 'Ingrese nombre/s del Alumno',
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
              const SizedBox(height: 16),
              TextFieldClass(
                labelText: 'Ingrese apellidos del Alumno',
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
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyleClass.blackButtonStyle(context),
                      onPressed: _registerStudent,
                      child: const Text('Registrar Alumno',
                          style: TextStyle(color: Colors.white)),
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyleClass.blackButtonStyle(context),
                onPressed: () {
                  Navigator.pushNamed(context, '/studentlist');
                },
                child: const Text('Ver Lista de Alumnos Registrados',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
