import 'package:flutter/material.dart';

import '../models/nota.dart';

class NotaCard extends StatelessWidget {
  final Nota nota;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const NotaCard({
    super.key,
    required this.nota,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: ListTile(
        leading: const Icon(Icons.note),
        title: Text(
          nota.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          nota.contenido,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onEditar,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Eliminar nota',
          onPressed: onEliminar,
        ),
      ),
    );
  }
}