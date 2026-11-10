import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/punto_interes.dart';
import '../services/ubicacion_service.dart';

class RegistrarPuntoPage extends StatefulWidget {
  final UbicacionService servicio;

  const RegistrarPuntoPage({
    super.key,
    required this.servicio,
  });

  @override
  State<RegistrarPuntoPage> createState() => _RegistrarPuntoPageState();
}

class _RegistrarPuntoPageState extends State<RegistrarPuntoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  Position? posicion;
  bool cargando = false;
  String mensaje = 'Obtén tu ubicación para registrar el punto.';

  Future<void> obtenerUbicacion() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });

    try {
      final resultado = await widget.servicio.obtenerPosicion();

      if (!mounted) return;

      setState(() {
        posicion = resultado;
        mensaje = 'Ubicación obtenida correctamente.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = e.toString().replaceFirst('Exception: ', '');
        posicion = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  void guardarPunto() {
    if (!_formKey.currentState!.validate()) return;

    if (posicion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes obtener la ubicación GPS.'),
        ),
      );
      return;
    }

    final punto = PuntoInteres(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      latitud: posicion!.latitude,
      longitud: posicion!.longitude,
    );

    Navigator.pop(context, punto);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar punto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.add_location_alt,
                size: 90,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del lugar',
                  prefixIcon: Icon(Icons.place),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre del lugar.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: cargando ? null : obtenerUbicacion,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener ubicación GPS'),
              ),
              const SizedBox(height: 16),
              if (cargando)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Text(
                mensaje,
                textAlign: TextAlign.center,
              ),
              if (posicion != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coordenadas obtenidas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Latitud: ${posicion!.latitude}',
                        ),
                        Text(
                          'Longitud: ${posicion!.longitude}',
                        ),
                        Text(
                          'Precisión: ${posicion!.accuracy} m',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: guardarPunto,
                child: const Text('Guardar punto de interés'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
