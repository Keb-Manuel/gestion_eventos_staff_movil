import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/incidencia.dart';
import '../providers/incidencias_provider.dart';

class DetalleIncidenciaPage extends StatelessWidget {
  final Incidencia incidencia;

  const DetalleIncidenciaPage({
    super.key,
    required this.incidencia,
  });

  Future<void> _abrirMapa(BuildContext context) async {
    final latitud = incidencia.latitud;
    final longitud = incidencia.longitud;

    if (latitud == null || longitud == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud',
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Google Maps.'),
          ),
        );
      }
    }
  }

  Future<void> _eliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar incidencia'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este reporte?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !context.mounted) return;

    final id = incidencia.id;

    if (id == null) return;

    final eliminado = await context
        .read<IncidenciasProvider>()
        .eliminarIncidencia(id);

    if (!context.mounted) return;

    if (eliminado) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidencia eliminada correctamente.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar la incidencia.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fecha = incidencia.fecha;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de incidencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (incidencia.foto != null &&
                File(incidencia.foto!).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(incidencia.foto!),
                  height: 230,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(
                Icons.image_not_supported,
                size: 100,
                color: Colors.grey,
              ),
            const SizedBox(height: 20),
            Text(
              incidencia.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Align(
  alignment: Alignment.centerLeft,
  child: Chip(
    avatar: const Icon(Icons.category, size: 18),
    label: Text(incidencia.categoria),
  ),
),
            const SizedBox(height: 20),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              incidencia.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Fecha y hora',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${fecha.day.toString().padLeft(2, '0')}/'
              '${fecha.month.toString().padLeft(2, '0')}/'
              '${fecha.year} - '
              '${fecha.hour.toString().padLeft(2, '0')}:'
              '${fecha.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 24),
            const Text(
              'Ubicación',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (incidencia.latitud != null &&
                incidencia.longitud != null) ...[
              Text('Latitud: ${incidencia.latitud}'),
              Text('Longitud: ${incidencia.longitud}'),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _abrirMapa(context),
                icon: const Icon(Icons.map),
                label: const Text('Ver en Google Maps'),
              ),
            ] else
              const Text('No se registró una ubicación.'),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () => _eliminar(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(Icons.delete),
              label: const Text('Eliminar incidencia'),
            ),
          ],
        ),
      ),
    );
  }
}