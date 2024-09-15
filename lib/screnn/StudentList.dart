import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo de estudiante
class Student {
  final String name;
  final String lastName;

  Student({required this.name, required this.lastName});

  // Factory para crear un Student a partir de un JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? 'Nombre no disponible',
      lastName: json['last_name'] ?? 'Apellido no disponible',
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final url = Uri.parse('http://10.0.2.2:5001/api/students');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            students = data.map((student) {
              return Student.fromJson(student);
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No hay datos disponibles.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error al obtener la lista de alumnos. Código: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error de conexión: $error';
      });
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alumnos Registrados UP'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) 
              : students.isEmpty
                  ? const Center(child: Text('Lista Vacia, Agregue Alumnos'))
                  : _buildStudentTable(), 
    );
  }

  Widget _buildStudentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Alumnos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columnSpacing: 170.0,
            columns: const [
              DataColumn(
                label: Center(
                  child: Text(
                    'Nombre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Apellidos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: students.map((student) {
              return DataRow(cells: [
                DataCell(
                  Center(child: Text(student.name)),
                ),
                DataCell(
                  Center(child: Text(student.lastName)),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
