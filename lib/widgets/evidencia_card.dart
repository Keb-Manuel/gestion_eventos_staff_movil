import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/evidencia_inspeccion.dart';

class EvidenciaCard extends StatelessWidget {
  final EvidenciaInspeccion evidencia;

  const EvidenciaCard({
    super.key,
    required this.evidencia,
  });

  Widget dato(String titulo, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor.toStringAsFixed(3),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            File(evidencia.fotografia.path),
            height: 230,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, error, stack) {
              return const SizedBox(
                height: 230,
                child: Center(
                  child: Text('No se pudo mostrar la fotografía'),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EVIDENCIA DE INSPECCIÓN',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(evidencia.fechaHora)}',
                ),
                Text(
                  'Hora: ${DateFormat('HH:mm:ss').format(evidencia.fechaHora)}',
                ),
                const SizedBox(height: 16),
                const Text(
                  'ACELERÓMETRO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                dato('Eje X', evidencia.acelerometroX),
                dato('Eje Y', evidencia.acelerometroY),
                dato('Eje Z', evidencia.acelerometroZ),
                const Divider(),
                const Text(
                  'GIROSCOPIO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                dato('Eje X', evidencia.giroscopioX),
                dato('Eje Y', evidencia.giroscopioY),
                dato('Eje Z', evidencia.giroscopioZ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
