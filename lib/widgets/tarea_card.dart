import 'package:flutter/material.dart';

import '../models/tarea.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onCambiarEstado;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.onCambiarEstado,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: tarea.completada,
          onChanged: (_) => onCambiarEstado(),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: tarea.descripcion.isEmpty
            ? null
            : Text(
                tarea.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Opciones',
          onSelected: (opcion) {
            if (opcion == 'editar') {
              onEditar();
            } else if (opcion == 'eliminar') {
              onEliminar();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            PopupMenuItem(
              value: 'eliminar',
              child: Text('Eliminar'),
            ),
          ],
        ),
        onTap: onEditar,
      ),
    );
  }
}
