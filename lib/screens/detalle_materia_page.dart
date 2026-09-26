import 'package:flutter/material.dart';
import 'package:gestion_eventos_staff_movil/models/Materia.dart';

class DetalleMateriaPage extends StatelessWidget {
  final Materia materia;

  const DetalleMateriaPage({
    super.key,
    required this.materia,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de materia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                child: Icon(
                  Icons.menu_book,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              materia.nombre,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InformacionItem(
                      icono: Icons.school,
                      titulo: 'Semestre',
                      valor: materia.semestre.toString(),
                    ),

                    const Divider(),

                    _InformacionItem(
                      icono: Icons.credit_score,
                      titulo: 'Créditos',
                      valor: materia.creditos.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Descripción',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 10),

            Text(
              materia.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _InformacionItem extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _InformacionItem({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(valor),
      ],
    );
  }
}