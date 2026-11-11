
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
  State<RegistrarPuntoPage> createState() =>
      _RegistrarPuntoPageState();
}

class _RegistrarPuntoPageState
    extends State<RegistrarPuntoPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  bool cargando = false;
  String mensaje = 'Puedes escribir las coordenadas o utilizar el GPS.';

  Future<void> obtenerUbicacion() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });

    try {
      final Position resultado =
          await widget.servicio.obtenerPosicion();

      if (!mounted) return;

      setState(() {
        _latitudController.text =
            resultado.latitude.toStringAsFixed(6);

        _longitudController.text =
            resultado.longitude.toStringAsFixed(6);

        mensaje = 'Ubicación obtenida correctamente.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  String? validarCoordenada(
    String? value,
    double minimo,
    double maximo,
    String nombre,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa la $nombre.';
    }

    final numero = double.tryParse(value.trim());

    if (numero == null) {
      return 'Ingresa un número válido.';
    }

    if (!numero.isFinite ||
        numero < minimo ||
        numero > maximo) {
      return 'Valor fuera del rango permitido.';
    }

    return null;
  }

  void guardarPunto() {
    if (!_formKey.currentState!.validate()) return;

    final latitud =
        double.parse(_latitudController.text.trim());

    final longitud =
        double.parse(_longitudController.text.trim());

    final punto = PuntoInteres(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      latitud: latitud,
      longitud: longitud,
    );

    Navigator.pop(context, punto);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
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
                size: 75,
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

              const SizedBox(height: 24),

              const Text(
                'Coordenadas geográficas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _latitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  hintText: 'Ej. 20.310710',
                  prefixIcon: Icon(Icons.explore),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validarCoordenada(
                  value,
                  -90,
                  90,
                  'latitud',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _longitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  hintText: 'Ej. -90.061925',
                  prefixIcon: Icon(Icons.explore_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validarCoordenada(
                  value,
                  -180,
                  180,
                  'longitud',
                ),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: cargando ? null : obtenerUbicacion,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener coordenadas por GPS'),
              ),

              const SizedBox(height: 12),

              if (cargando)
                const Center(
                  child: CircularProgressIndicator(),
                ),

              Text(
                mensaje,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: guardarPunto,
                icon: const Icon(Icons.save),
                label: const Text('Guardar punto de interés'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
