import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Map<String, dynamic>> students = []; // Cambiar a dynamic
  bool isLoading = true; // Estado de carga
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents(); // Llamada inicial para obtener los datos de la API
  }

  // Función para obtener la lista de alumnos desde la API
  Future<void> _fetchStudents() async {
    final url = Uri.parse('http://192.168.56.1:3000/api/students'); // URL de la API

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Simulamos una demora artificial de 2 segundos antes de mostrar los datos
        await Future.delayed(Duration(seconds: 2));

        // Verificar que la respuesta no esté vacía
        if (data.isNotEmpty) {
          setState(() {
            students = data.map((student) {
              return {
                'name': student['name'] ?? 'Nombre no disponible',
                'last_name': student['last_name'] ?? 'Apellido no disponible',
              };
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No hay datos disponibles.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error al obtener la lista de alumnos.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error de conexión.';
      });
    } finally {
      setState(() {
        isLoading = false; // Terminamos la carga después de la demora
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Alumnos Registrados UP'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage)) // Mensaje de error
          : students.isEmpty
          ? Center(child: Text('Lista Vacia, Agregue Alumnos')) // Lista vacía
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${students[index]['name']} ${students[index]['last_name']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/student_form'); // Navegar al formulario de registro
        },
        child: Icon(Icons.arrow_back),
        tooltip: 'Regresar al formulario',
      ),
    );
  }
}