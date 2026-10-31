import 'package:flutter/material.dart';

class BienvenidaWidget extends StatelessWidget {
  final String nombre;
  final VoidCallback onCambiarNombre;

  const BienvenidaWidget({
    super.key,
    required this.nombre,
    required this.onCambiarNombre,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Bienvenido, $nombre'),
          ),
          IconButton(
            onPressed: onCambiarNombre,
            icon: const Icon(Icons.edit),
            tooltip: 'Cambiar nombre',
          ),
        ],
      ),
    );
  }
}