
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/registro_inspeccion.dart';
import '../providers/inspeccion_provider.dart';

class InspeccionPage extends StatefulWidget {
  const InspeccionPage({super.key});

  @override
  State<InspeccionPage> createState() => _InspeccionPageState();
}

class _InspeccionPageState extends State<InspeccionPage> {
  late final InspeccionProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = InspeccionProvider();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio - $hora:$minuto';
  }

  Widget _crearValorSensor(String etiqueta, double valor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor.toStringAsFixed(2),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearPanelSensor({
    required String titulo,
    required IconData icono,
    required Color color,
    required double x,
    required double y,
    required double z,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: color),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Tiempo real',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _crearValorSensor('Eje X', x),
                _crearValorSensor('Eje Y', y),
                _crearValorSensor('Eje Z', z),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearRegistro(RegistroInspeccion registro) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (File(registro.rutaImagen).existsSync())
            Image.file(
              File(registro.rutaImagen),
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stackTrace) => const SizedBox(
                height: 100,
                child: Center(child: Text('No se pudo mostrar la imagen')),
              ),
            )
          else
            const SizedBox(
              height: 100,
              child: Center(
                child: Text('Fotografía no disponible'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 17),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatearFecha(registro.fecha),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Eliminar registro',
                      onPressed: () => _provider.eliminarRegistro(registro),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const Text(
                  'Acelerómetro (m/s²)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'X: ${registro.acelerometroX.toStringAsFixed(2)}   '
                  'Y: ${registro.acelerometroY.toStringAsFixed(2)}   '
                  'Z: ${registro.acelerometroZ.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Giroscopio (rad/s)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'X: ${registro.giroscopioX.toStringAsFixed(2)}   '
                  'Y: ${registro.giroscopioY.toStringAsFixed(2)}   '
                  'Z: ${registro.giroscopioZ.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _provider,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Práctica 9 - Cámara y Sensores'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bitácora de inspección',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Captura fotografías y registra los valores '
                          'del acelerómetro y giroscopio de tu dispositivo.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _crearPanelSensor(
                  titulo: 'Acelerómetro',
                  icono: Icons.speed,
                  color: Colors.blue,
                  x: _provider.acelerometroX,
                  y: _provider.acelerometroY,
                  z: _provider.acelerometroZ,
                ),
                _crearPanelSensor(
                  titulo: 'Giroscopio',
                  icono: Icons.screen_rotation,
                  color: Colors.deepPurple,
                  x: _provider.giroscopioX,
                  y: _provider.giroscopioY,
                  z: _provider.giroscopioZ,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _provider.cargando
                      ? null
                      : _provider.tomarFotografia,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    _provider.cargando
                        ? 'Procesando fotografía...'
                        : 'Tomar fotografía y guardar registro',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                if (_provider.cargando)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_provider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Registros de inspección',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text('${_provider.registros.length}'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_provider.registros.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Todavía no hay registros.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Toma una fotografía para comenzar.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._provider.registros.map(_crearRegistro),
              ],
            ),
          ),
        );
      },
    );
  }
}
