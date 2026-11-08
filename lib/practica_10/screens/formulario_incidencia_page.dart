import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/incidencia.dart';
import '../providers/incidencias_provider.dart';

class FormularioIncidenciaPage extends StatefulWidget {
  const FormularioIncidenciaPage({super.key});

  @override
  State<FormularioIncidenciaPage> createState() =>
      _FormularioIncidenciaPageState();
}

class _FormularioIncidenciaPageState
    extends State<FormularioIncidenciaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _categoria = 'Infraestructura';
  String? _rutaFoto;
  Position? _posicion;
  bool _obteniendoUbicacion = false;
  bool _guardando = false;

  final List<String> _categorias = [
    'Infraestructura',
    'Seguridad',
    'Limpieza',
    'Servicios',
    'Otro',
  ];

  Future<void> _tomarFoto(ImageSource origen) async {
    try {
      final imagen = await _picker.pickImage(
        source: origen,
        imageQuality: 75,
      );

      if (imagen != null && mounted) {
        setState(() {
          _rutaFoto = imagen.path;
        });
      }
    } catch (e) {
      _mostrarMensaje('No se pudo obtener la fotografía.');
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _obteniendoUbicacion = true;
    });

    try {
      final servicioActivo =
          await Geolocator.isLocationServiceEnabled();

      if (!servicioActivo) {
        throw Exception('Activa el servicio de ubicación del teléfono.');
      }

      LocationPermission permiso =
          await Geolocator.checkPermission();

      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }

      if (permiso == LocationPermission.denied) {
        throw Exception('No se concedió el permiso de ubicación.');
      }

      if (permiso == LocationPermission.deniedForever) {
        throw Exception(
          'El permiso está bloqueado. Habilítalo en los ajustes.',
        );
      }

      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _posicion = posicion;
      });

      _mostrarMensaje('Ubicación obtenida correctamente.');
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _obteniendoUbicacion = false;
        });
      }
    }
  }

  Future<void> _guardarIncidencia() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    final incidencia = Incidencia(
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      categoria: _categoria,
      foto: _rutaFoto,
      latitud: _posicion?.latitude,
      longitud: _posicion?.longitude,
      fecha: DateTime.now(),
    );

    final guardado = await context
        .read<IncidenciasProvider>()
        .agregarIncidencia(incidencia);

    if (!mounted) return;

    setState(() {
      _guardando = false;
    });

    if (guardado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidencia registrada correctamente.'),
        ),
      );

      Navigator.pop(context);
    } else {
      _mostrarMensaje('No se pudo guardar la incidencia.');
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva incidencia'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa un título.';
                }
                if (valor.trim().length < 3) {
                  return 'El título debe tener al menos 3 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa una descripción.';
                }
                if (valor.trim().length < 10) {
                  return 'Describe la incidencia con al menos 10 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    _categoria = valor;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Fotografía',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_rutaFoto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_rutaFoto!),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _tomarFoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _tomarFoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Ubicación GPS',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed:
                  _obteniendoUbicacion ? null : _obtenerUbicacion,
              icon: _obteniendoUbicacion
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                _obteniendoUbicacion
                    ? 'Obteniendo ubicación...'
                    : 'Obtener ubicación actual',
              ),
            ),
            if (_posicion != null) ...[
              const SizedBox(height: 8),
              Text(
                'Latitud: ${_posicion!.latitude}\n'
                'Longitud: ${_posicion!.longitude}',
              ),
            ],
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardarIncidencia,
              icon: const Icon(Icons.save),
              label: Text(
                _guardando ? 'Guardando...' : 'Guardar incidencia',
              ),
            ),
          ],
        ),
      ),
    );
  }
}