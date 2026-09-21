import 'package:flutter/material.dart';

class ResumenInventario extends StatelessWidget {
  final double total;
  final int cantidadProductos;

  const ResumenInventario({
    super.key,
    required this.total,
    required this.cantidadProductos,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.calculate),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Valor total del inventario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  Text(
                    '$cantidadProductos producto(s)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}