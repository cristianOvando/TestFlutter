import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    final Map<String, Map<String, String>> teamMembers = {
      'Miembro1': {
        'name': 'Cristian Ovando Gómez',
        'phone': '9651257602',
      },
      'Miembro2': {
        'name': 'Martin Ochoa Espinosa',
        'phone': '9651193170'
      },
      'Miembro3': {
        'name': 'Diego Ortiz Cruz',
        'phone': '9181071656'
      },
    };

    final List<Widget> teamMembersList = teamMembers.entries.map((entry) {
      return ListTile(
        subtitle: Text(entry.value['name'] ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 0, 140, 255).withOpacity(0.1),
              ),
              child: IconButton(
                color: const Color.fromARGB(255, 0, 0, 0),
                icon: const Icon(Icons.phone),
                onPressed: () async {
                  final phoneNumber =
                      Uri.parse('tel:${entry.value['phone']}');
                  if (await canLaunchUrl(phoneNumber)) {
                    await launchUrl(phoneNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo realizar la llamada a ${entry.value['phone']}'),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(width: 10),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 0, 255, 64).withOpacity(0.1),
              ),
              child: IconButton(
                color: const Color.fromARGB(255, 0, 0, 0),
                icon: const Icon(Icons.message),
                onPressed: () async {
                  final messageNumber =
                      Uri.parse('sms:${entry.value['phone']}');
                  if (await canLaunchUrl(messageNumber)) {
                    await launchUrl(messageNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo enviar el mensaje a ${entry.value['phone']}'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }).toList();

    // Construcción de la pantalla
    return Scaffold(
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
