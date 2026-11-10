import 'package:flutter/material.dart';

class EncabezadoTareas extends StatelessWidget {
  final String nombre;
  final int cantidad;

  const EncabezadoTareas({
    super.key,
    required this.nombre,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Hola, $nombre',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Chip(
            visualDensity: VisualDensity.compact,
            label: Text('$cantidad tareas'),
          ),
        ],
      ),
    );
  }
}