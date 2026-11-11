import 'package:flutter/material.dart';

import '../models/evidencia_inspeccion.dart';
import '../services/camara_service.dart';
import '../services/sensores_service.dart';
import '../widgets/evidencia_card.dart';

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final CamaraService _camara = CamaraService();
  final SensoresService _sensores = SensoresService();

  final List<EvidenciaInspeccion> evidencias = [];

  bool _capturando = false;

  @override
  void initState() {
    super.initState();

    _sensores.iniciar(
      onActualizar: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> capturarEvidencia() async {
    if (_capturando) return;

    setState(() {
      _capturando = true;
    });

    try {
      final fotografia = await _camara.tomarFotografia();

      // Cancelar la cámara no genera una evidencia.
      if (!mounted || fotografia == null) return;

      final evidencia = EvidenciaInspeccion(
        fotografia: fotografia,
        fechaHora: DateTime.now(),
        acelerometroX: _sensores.acelerometroX,
        acelerometroY: _sensores.acelerometroY,
        acelerometroZ: _sensores.acelerometroZ,
        giroscopioX: _sensores.giroscopioX,
        giroscopioY: _sensores.giroscopioY,
        giroscopioZ: _sensores.giroscopioZ,
      );

      setState(() {
        evidencias.insert(0, evidencia);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evidencia registrada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _capturando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _sensores.detener();
    super.dispose();
  }

  Widget sensorCard(
    String titulo,
    double x,
    double y,
    double z,
    IconData icono,
  ) {
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
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('X: ${x.toStringAsFixed(3)}'),
            Text('Y: ${y.toStringAsFixed(3)}'),
            Text('Z: ${z.toStringAsFixed(3)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de inspección'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.fact_check,
            size: 65,
            color: Colors.blue,
          ),
          const Center(
            child: Text(
              'Registro de evidencias',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          sensorCard(
            'Acelerómetro',
            _sensores.acelerometroX,
            _sensores.acelerometroY,
            _sensores.acelerometroZ,
            Icons.screen_rotation,
          ),
          sensorCard(
            'Giroscopio',
            _sensores.giroscopioX,
            _sensores.giroscopioY,
            _sensores.giroscopioZ,
            Icons.threesixty,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _capturando ? null : capturarEvidencia,
            icon: _capturando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.camera_alt),
            label: Text(
              _capturando
                  ? 'Abriendo cámara...'
                  : 'Tomar fotografía y registrar evidencia',
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Evidencias registradas: ${evidencias.length}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (evidencias.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Todavía no hay evidencias registradas.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ...evidencias.map(
            (evidencia) => EvidenciaCard(
              evidencia: evidencia,
            ),
          ),
        ],
      ),
    );
  }
}
