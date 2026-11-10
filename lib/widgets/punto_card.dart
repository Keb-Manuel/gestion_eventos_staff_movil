import 'package:flutter/material.dart';
import '../models/punto_interes.dart';

class PuntoCard extends StatelessWidget {
  final PuntoInteres punto;
  final VoidCallback onAbrirMapa;
  final VoidCallback onEliminar;

  const PuntoCard({
    super.key,
    required this.punto,
    required this.onAbrirMapa,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    punto.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onEliminar,
                  tooltip: 'Eliminar punto',
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            if (punto.descripcion.isNotEmpty) Text(punto.descripcion),
            const SizedBox(height: 12),
            Text(
              'Latitud: ${punto.latitud.toStringAsFixed(6)}',
            ),
            Text(
              'Longitud: ${punto.longitud.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onAbrirMapa,
                icon: const Icon(Icons.map),
                label: const Text('Abrir en mapa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
