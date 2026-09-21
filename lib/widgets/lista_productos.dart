import 'package:flutter/material.dart';
import '../models/producto.dart';

class ListaProductos extends StatelessWidget {
  final List<Producto> productos;
  final void Function(int index) onEliminar;

  const ListaProductos({
    super.key,
    required this.productos,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    if (productos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 60,
            ),
            SizedBox(height: 12),
            Text(
              'No hay productos registrados',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),

            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),

            title: Text(
              producto.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categoría: ${producto.categoria}'),
                  Text(
                    'Precio: \$${producto.precio.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Existencia: ${producto.existencia}',
                  ),
                  Text(
                    'Valor: \$${producto.valorInventario.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),

            trailing: IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete),
              onPressed: () {
                onEliminar(index);
              },
            ),
          ),
        );
      },
    );
  }
}