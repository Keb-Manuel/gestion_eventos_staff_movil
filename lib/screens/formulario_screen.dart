import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import '../models/reporte.dart';
import '../services/database_service.dart';
import '../services/ubicacion_service.dart';
import '../services/notificaciones.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();

  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();

  String categoria = 'Infraestructura';
  String? fotografia;

  double? latitud;
  double? longitud;

  bool cargando = false;

  final picker = ImagePicker();

  Future<void> tomarFotografia() async {
    try {
      final imagen = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (imagen != null) {
        setState(() {
          fotografia = imagen.path;
        });
      }
    } catch (e) {
      mostrarMensaje('No se pudo abrir la cámara: $e');
    }
  }

  Future<void> obtenerGPS() async {
    try {
      final Position posicion = await UbicacionService.obtenerUbicacion();

      setState(() {
        latitud = posicion.latitude;
        longitud = posicion.longitude;
      });

      mostrarMensaje('Ubicación obtenida correctamente.');
    } catch (e) {
      mostrarMensaje(e.toString());
    }
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> guardarReporte() async {
    if (!_formKey.currentState!.validate()) return;

    if (latitud == null || longitud == null) {
      mostrarMensaje('Primero debes obtener la ubicación GPS.');
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final reporte = Reporte(
        titulo: tituloController.text.trim(),
        descripcion: descripcionController.text.trim(),
        categoria: categoria,
        fotografia: fotografia,
        latitud: latitud!,
        longitud: longitud!,
        fecha: DateTime.now().toIso8601String(),
      );

      await DatabaseService.insertar(reporte);

      await Notificaciones.mostrar();

      if (!mounted) return;

      mostrarMensaje('Reporte guardado correctamente.');

      Navigator.pop(context, true);
    } catch (e) {
      mostrarMensaje('Error al guardar el reporte: $e');
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo reporte'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Título del reporte',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  hintText: 'Ej. Luminaria dañada',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe la incidencia...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una descripción.';
                  }
                  if (value.trim().length < 10) {
                    return 'Mínimo 10 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Categoría',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                initialValue: categoria,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Infraestructura',
                  'Electricidad',
                  'Limpieza',
                  'Seguridad',
                  'Otros',
                ].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      categoria = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: tomarFotografia,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar fotografía'),
                ),
              ),
              if (fotografia != null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.file(
                    File(fotografia!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: obtenerGPS,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Obtener ubicación GPS'),
                ),
              ),
              if (latitud != null)
                Text(
                  'Latitud: $latitud\nLongitud: $longitud',
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: cargando ? null : guardarReporte,
                  child: cargando
                      ? const CircularProgressIndicator()
                      : const Text('Guardar reporte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
