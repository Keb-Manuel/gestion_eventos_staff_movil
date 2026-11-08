import 'package:flutter/material.dart';

class EncabezadoSeccion extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;

  const EncabezadoSeccion({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icono,
          size: 65,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          descripcion,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}