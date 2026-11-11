
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (punto.imagenUrl.isNotEmpty)
            Image.network(
              punto.imagenUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: Colors.blue.shade50,
                child: const Center(
                  child: Icon(
                    Icons.location_city,
                    size: 65,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 28,
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
                if (punto.descripcion.isNotEmpty)
                  Text(punto.descripcion),
                const SizedBox(height: 12),
                Text(
                  'Latitud: ${punto.latitud.toStringAsFixed(6)}',
                ),
                Text(
                  'Longitud: ${punto.longitud.toStringAsFixed(6)}',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onAbrirMapa,
                    icon: const Icon(Icons.map),
                    label: const Text('Abrir en Google Maps'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
