import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';

class SensorPlusPage extends StatefulWidget {
  const SensorPlusPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SensorPlusPageState createState() => _SensorPlusPageState();
}

class _SensorPlusPageState extends State<SensorPlusPage> {
  List<double> _accelerometerValues = [0.0, 0.0, 0.0];
  List<double> _gyroscopeValues = [0.0, 0.0, 0.0];
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();

    // ignore: deprecated_member_use
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });

    // ignore: deprecated_member_use
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  Future<void> _toggleTorch() async {
    try {
      if (_isTorchOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer = _accelerometerValues.map((double v) => v.toStringAsFixed(1)).toList();
    final List<String> gyroscope = _gyroscopeValues.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Plus Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Accelerometer: $accelerometer'),
              const SizedBox(height: 8.0),
              Text('Gyroscope: $gyroscope'),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _toggleTorch,
                child: Text(_isTorchOn ? 'Turn off Torch' : 'Turn on Torch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}