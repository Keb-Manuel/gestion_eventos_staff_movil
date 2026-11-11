import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensoresPage extends StatefulWidget {
  final bool iniciarHardware;

  const SensoresPage({
    super.key,
    this.iniciarHardware = true,
  });

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  CameraController? _cameraController;

  Uint8List? _fotoBytes;
  String? _timestamp;

  bool _cargandoCamara = false;
  bool _tomandoFoto = false;

  String? _errorCamara;
  String? _errorSensores;

  double _accX = 0;
  double _accY = 0;
  double _accZ = 0;

  double _gyroX = 0;
  double _gyroY = 0;
  double _gyroZ = 0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.iniciarHardware) {
      _iniciarSensores();
      _inicializarCamara();
    }
  }

  // Inicializa los sensores del dispositivo.
  void _iniciarSensores() {
    try {
      _accelerometerSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          if (!mounted) return;

          setState(() {
            _accX = event.x;
            _accY = event.y;
            _accZ = event.z;
          });
        },
        onError: (Object error) {
          if (!mounted) return;

          setState(() {
            _errorSensores = 'No se pudo acceder al acelerómetro.';
          });
        },
      );

      _gyroscopeSubscription = gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
          if (!mounted) return;

          setState(() {
            _gyroX = event.x;
            _gyroY = event.y;
            _gyroZ = event.z;
          });
        },
        onError: (Object error) {
          if (!mounted) return;

          setState(() {
            _errorSensores = 'No se pudo acceder al giroscopio.';
          });
        },
      );
    } catch (error) {
      _errorSensores = 'No fue posible iniciar los sensores.';
    }
  }

  // Busca las cámaras disponibles e inicializa una.
  Future<void> _inicializarCamara() async {
    if (!mounted) return;

    setState(() {
      _cargandoCamara = true;
      _errorCamara = null;
    });

    CameraController? nuevoController;

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No se encontraron cámaras.');
      }

      CameraDescription camaraSeleccionada;

      if (kIsWeb) {
        // En Edge se utiliza la primera webcam disponible.
        camaraSeleccionada = cameras.first;
      } else {
        // En Android se prefiere la cámara trasera.
        camaraSeleccionada = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
      }

      nuevoController = CameraController(
        camaraSeleccionada,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await nuevoController.initialize();

      if (!mounted) {
        await nuevoController.dispose();
        return;
      }

      final anterior = _cameraController;

      setState(() {
        _cameraController = nuevoController;
        _cargandoCamara = false;
      });

      await anterior?.dispose();
    } catch (error) {
      await nuevoController?.dispose();

      if (!mounted) return;

      setState(() {
        _cargandoCamara = false;
        _errorCamara = 'No se pudo iniciar la cámara: $error';
      });
    }
  }

  // Captura una fotografía.
  Future<void> _tomarFoto() async {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized || _tomandoFoto) {
      return;
    }

    setState(() {
      _tomandoFoto = true;
    });

    try {
      final XFile archivo = await controller.takePicture();

      // Se leen los bytes para funcionar tanto en web como Android.
      final Uint8List bytes = await archivo.readAsBytes();

      if (!mounted) return;

      setState(() {
        _fotoBytes = bytes;

        _timestamp = DateFormat(
          'yyyy-MM-dd – HH:mm:ss',
        ).format(DateTime.now());

        _tomandoFoto = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _tomandoFoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al tomar la fotografía: $error',
          ),
        ),
      );
    }
  }

  // Cancela los recursos al cerrar la pantalla.
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _cameraController?.dispose();

    super.dispose();
  }

  Widget _construirVistaCamara() {
    final controller = _cameraController;

    if (_cargandoCamara) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Iniciando cámara...'),
          ],
        ),
      );
    }

    if (_errorCamara != null) {
      return Column(
        children: [
          const Icon(
            Icons.no_photography,
            size: 55,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          Text(
            _errorCamara!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _inicializarCamara,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return Column(
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 55,
          ),
          const SizedBox(height: 10),
          const Text('La cámara no se ha iniciado.'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _inicializarCamara,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Iniciar cámara'),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _construirSensor({
    required String titulo,
    required double x,
    required double y,
    required double z,
    required IconData icono,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('Eje X: ${x.toStringAsFixed(2)}'),
            Text('Eje Y: ${y.toStringAsFixed(2)}'),
            Text('Eje Z: ${z.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final camaraLista = _cameraController?.value.isInitialized ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara y sensores'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Cámara del dispositivo',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 260,
                child: Center(
                  child: _construirVistaCamara(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: camaraLista && !_tomandoFoto ? _tomarFoto : null,
            icon: const Icon(Icons.camera_alt),
            label: Text(
              _tomandoFoto ? 'Tomando fotografía...' : 'Tomar fotografía',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Fotografía capturada',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_fotoBytes != null)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.memory(
                      _fotoBytes!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fecha y hora: $_timestamp',
                    ),
                  ],
                ),
              ),
            )
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Todavía no has tomado una fotografía.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Sensores del dispositivo',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_errorSensores != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _errorSensores!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 8),
          _construirSensor(
            titulo: 'Acelerómetro',
            x: _accX,
            y: _accY,
            z: _accZ,
            icono: Icons.screen_rotation,
          ),
          _construirSensor(
            titulo: 'Giroscopio',
            x: _gyroX,
            y: _gyroY,
            z: _gyroZ,
            icono: Icons.rotate_right,
          ),
        ],
      ),
    );
  }
}
