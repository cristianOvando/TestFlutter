import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationStatusScreenState createState() => _LocationStatusScreenState();
}

class _LocationStatusScreenState extends State<LocationStatusScreen> {
  final double _thresholdDistance = 5.0;
  Position? _lastPosition;
  DateTime? _lastUpdateTime;
  final int _minTimeBetweenUpdates = 5;
  String _locationStatus = 'Desconocido';

  // Obtener ubicación y procesar anomalías
  Future<void> _getLocationStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus = 'Servicio de localización deshabilitado';
      });
      return;
    }

    // Verificar los permisos de localización
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Permiso de localización denegado';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = 'Permiso de localización denegado permanentemente';
      });
      return;
    }

    // Obtener la ubicación actual
    // ignore: deprecated_member_use
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    DateTime currentTime = DateTime.now();

    // Verificar si la ubicación es falsa (solo en Android)
    bool isMocked = position.isMocked;

    if (isMocked) {
      setState(() {
        _locationStatus = 'Ubicación FALSA detectada.';
      });
      return;
    }

    // Validar anomalías en la ubicación
    if (_lastPosition != null && _lastUpdateTime != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      int timeDifference = currentTime.difference(_lastUpdateTime!).inSeconds;

      if (distance > _thresholdDistance && timeDifference < _minTimeBetweenUpdates) {
        setState(() {
          _locationStatus = 'Ubicación FALSA detectada. Movimiento rápido de ${distance.toStringAsFixed(2)} metros en $timeDifference segundos.';
        });
      } else {
        setState(() {
          _locationStatus = 'Ubicación REAL: ${position.latitude}, ${position.longitude}';
        });
      }
    } else {
      // Si es la primera vez, simplemente almacenamos la ubicación
      setState(() {
        _locationStatus = 'Ubicación REAL: ${position.latitude}, ${position.longitude}';
      });
    }

    // Actualizar los valores de la última posición y tiempo
    _lastPosition = position;
    _lastUpdateTime = currentTime;
  }

  // Abrir Google Maps con las coordenadas actuales
  Future<void> _openInGoogleMaps() async {
    if (_lastPosition != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${_lastPosition!.latitude},${_lastPosition!.longitude}';
      // ignore: deprecated_member_use
      if (await canLaunch(url)) {
        // ignore: deprecated_member_use
        await launch(url);
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de la ubicación'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 248, 248, 248), Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 50,
                    color: _locationStatus.contains('FALSA') ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _locationStatus,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _locationStatus.contains('FALSA') ? Colors.red : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getLocationStatus, // Actualizamos la ubicación al hacer clic
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 79, 235, 124),
                    ),
                    child: const Text('Actualizar Ubicación'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _lastPosition != null ? _openInGoogleMaps : null, // Abrir Google Maps al hacer clic
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 79, 235, 124),
                    ),
                    child: const Text('Ver en Google Maps'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}