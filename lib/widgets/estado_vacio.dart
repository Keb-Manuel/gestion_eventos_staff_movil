import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class EstadoVacio extends StatelessWidget {
  final FiltroTareas filtro;

  const EstadoVacio({
    super.key,
    required this.filtro,
  });

  @override
  Widget build(BuildContext context) {
    final mensaje = switch (filtro) {
      FiltroTareas.todas => 'No hay tareas. Crea la primera con el botón +.',
      FiltroTareas.pendientes => 'No hay tareas pendientes.',
      FiltroTareas.completadas => 'No hay tareas completadas.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
