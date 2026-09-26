import 'package:flutter/material.dart';
import '../models/materia.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final VoidCallback onTap;

  const MateriaCard({
    super.key,
    required this.materia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          materia.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Semestre ${materia.semestre} • ${materia.creditos} créditos',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
