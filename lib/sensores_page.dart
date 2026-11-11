import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:intl/intl.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  XFile? _foto;
  double _accX = 0, _accY = 0, _accZ = 0;
  double _gyroX = 0, _gyroY = 0, _gyroZ = 0;
  String? _timestamp;

  @override
  void initState() {
    super.initState();
    // Accelerometer stream
    accelerometerEventStream().listen((AccelerometerEvent e) {
      if (mounted) {
        setState(() {
          _accX = e.x;
          _accY = e.y;
          _accZ = e.z;
        });
      }
    });
    // Gyroscope stream
    gyroscopeEventStream().listen((GyroscopeEvent e) {
      if (mounted) {
        setState(() {
          _gyroX = e.x;
          _gyroY = e.y;
          _gyroZ = e.z;
        });
      }
    });
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    // Capture timestamp only when photo is actually taken
    if (foto != null) {
      setState(() {
        _foto = foto;
        _timestamp = DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara y sensores')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        FilledButton.icon(
          onPressed: _tomarFoto,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tomar fotografía'),
        ),
        const SizedBox(height: 12),
        if (_foto != null)
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(File(_foto!.path), height: 250, fit: BoxFit.cover),
                  const SizedBox(height: 8),
                  Text('Fecha/Hora: ${_timestamp ?? "-"}'),
                  const Divider(),
                  Text('Acelerómetro X: ${_accX.toStringAsFixed(2)}'),
                  Text('Acelerómetro Y: ${_accY.toStringAsFixed(2)}'),
                  Text('Acelerómetro Z: ${_accZ.toStringAsFixed(2)}'),
                  const Divider(),
                  Text('Giroscopio X: ${_gyroX.toStringAsFixed(2)}'),
                  Text('Giroscopio Y: ${_gyroY.toStringAsFixed(2)}'),
                  Text('Giroscopio Z: ${_gyroZ.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        const Divider(),
        // Show current sensor values when no photo yet
        if (_foto == null) ...[
          Text('Acelerómetro X: ${_accX.toStringAsFixed(2)}'),
          Text('Acelerómetro Y: ${_accY.toStringAsFixed(2)}'),
          Text('Acelerómetro Z: ${_accZ.toStringAsFixed(2)}'),
          const Divider(),
          Text('Giroscopio X: ${_gyroX.toStringAsFixed(2)}'),
          Text('Giroscopio Y: ${_gyroY.toStringAsFixed(2)}'),
          Text('Giroscopio Z: ${_gyroZ.toStringAsFixed(2)}'),
        ],
      ]),
    );
  }
}
