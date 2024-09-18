import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  // Método para hacer una llamada
  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    final telUrl = 'tel:$phoneNumber'; // Número a marcar
    final Uri telUri = Uri.parse(telUrl);
    if (!await launchUrl(telUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo iniciar la llamada al número: $phoneNumber'),
        ),
      );
    }
  }

  // Método para enviar un mensaje de texto
  Future<void> _sendMessage(String phoneNumber, BuildContext context) async {
    final smsUrl = 'sms:$phoneNumber'; // Número al que enviar el mensaje
    final Uri smsUri = Uri.parse(smsUrl);
    if (!await launchUrl(smsUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar el mensaje al número: $phoneNumber'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> teamMembers = {
      'Miembro1': {
        'name': 'Cristian Ovando Gómez',
        'phone': '9651257602',
      },
      'Miembro2': {
        'name': 'Martin Ochoa Espinosa',
        'phone': '9651193170',
      },
      'Miembro3': {
        'name': 'Diego Ortiz Cruz',
        'phone': '9181071656',
      },
    };

    final List<Widget> teamMembersList = teamMembers.entries.map((entry) {
      return ListTile(
        subtitle: Text(entry.value['name'] ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de llamada
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 0, 140, 255).withOpacity(0.1),
              ),
              child: IconButton(
                color: const Color.fromARGB(255, 0, 0, 0),
                icon: const Icon(Icons.phone),
                onPressed: () {
                  _makePhoneCall(entry.value['phone'] ?? '', context);
                },
              ),
            ),
            const SizedBox(width: 10),
            // Botón de mensaje
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 0, 255, 64).withOpacity(0.1),
              ),
              child: IconButton(
                color: const Color.fromARGB(255, 0, 0, 0),
                icon: const Icon(Icons.message),
                onPressed: () {
                  _sendMessage(entry.value['phone'] ?? '', context);
                },
              ),
            ),
          ],
        ),
      );
    }).toList();

    // Construcción de la pantalla
    return Scaffold(
      appBar: AppBar(title: const Text('Equipo de Desarrollo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Equipo de Desarrollo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                children: teamMembersList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
