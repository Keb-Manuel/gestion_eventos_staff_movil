import 'dart:io';

import 'package:flutter/material.dart';

import '../models/reporte.dart';

class DetalleScreen extends StatelessWidget {
  final Reporte reporte;

  const DetalleScreen({
    super.key,
    required this.reporte,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del reporte'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reporte.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text('Categoría: ${reporte.categoria}'),
            const SizedBox(height: 15),
            const Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(reporte.descripcion),
            const SizedBox(height: 20),
            if (reporte.fotografia != null)
              Image.file(
                File(reporte.fotografia!),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('No se pudo cargar la fotografía.');
                },
              ),
            const SizedBox(height: 20),
            const Text(
              'Ubicación GPS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Latitud: ${reporte.latitud}'),
            Text('Longitud: ${reporte.longitud}'),
            const SizedBox(height: 20),
            const Text(
              'Fecha y hora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(reporte.fecha),
          ],
        ),
      ),
    );
  }
}
