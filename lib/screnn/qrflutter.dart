import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          if (capture.barcodes.isNotEmpty) {
            final Barcode barcode = capture.barcodes.first;
            if (barcode.rawValue != null) {
              final String qrContent = barcode.rawValue!;
              _handleQrContent(context, qrContent);
            }
          }
        },
      ),
    );
  }

  // Manejar el contenido del QR
  void _handleQrContent(BuildContext context, String qrContent) {
    if (_isValidUrl(qrContent)) {
      _launchUrl(qrContent); // Si es una URL válida, redirigir
    } else {
      _showDialog(context, qrContent); // Mostrar el contenido en un diálogo si no es una URL
    }
  }

  // Mostrar diálogo con el contenido escaneado
  void _showDialog(BuildContext context, String qrContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Detected'),
          content: Text(qrContent),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Verificar si el contenido del QR es una URL válida
  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  // Redirigir a la URL usando url_launcher
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}
