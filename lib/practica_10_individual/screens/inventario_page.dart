import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/producto.dart';
import '../providers/inventario_provider.dart';
import 'producto_form_page.dart';
import 'dart:io';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final TextEditingController _busquedaController =
      TextEditingController();

  String _filtro = 'Todos';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Producto> _filtrarProductos(List<Producto> productos) {
    final busqueda = _busquedaController.text.toLowerCase();

    return productos.where((producto) {
      final coincideBusqueda =
          producto.nombre.toLowerCase().contains(busqueda) ||
          producto.categoria.toLowerCase().contains(busqueda);

      final coincideFiltro = switch (_filtro) {
        'Stock bajo' => producto.stockBajo,
        'Disponibles' => producto.stock > producto.stockMinimo,
        _ => true,
      };

      return coincideBusqueda && coincideFiltro;
    }).toList();
  }

  Future<void> _eliminarProducto(
    BuildContext context,
    Producto producto,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Deseas eliminar "${producto.nombre}" del inventario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final resultado = await context
        .read<InventarioProvider>()
        .eliminarProducto(producto.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultado
              ? 'Producto eliminado correctamente.'
              : context.read<InventarioProvider>().error ??
                  'No se pudo eliminar el producto.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductoFormPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          if (provider.cargando && provider.productos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.productos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: provider.cargarProductos,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final productos = _filtrarProductos(provider.productos);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _busquedaController,
                  decoration: InputDecoration(
                    hintText: 'Buscar producto o categoría...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _busquedaController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['Todos', 'Stock bajo', 'Disponibles']
                      .map(
                        (filtro) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filtro),
                            selected: _filtro == filtro,
                            onSelected: (_) {
                              setState(() => _filtro = filtro);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: productos.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron productos.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: provider.cargarProductos,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            4,
                            16,
                            90,
                          ),
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final producto = productos[index];

                            return _ProductoCard(
                              producto: producto,
                              onEditar: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductoFormPage(
                                      producto: producto,
                                    ),
                                  ),
                                );
                              },
                              onEliminar: () {
                                _eliminarProducto(context, producto);
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _ProductoCard({
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  
Widget _imagenProducto() {
  if (producto.imagen == null || producto.imagen!.isEmpty) {
    return const Icon(Icons.inventory_2, size: 35);
  }

  if (producto.imagen!.startsWith('http')) {
    return Image.network(
      producto.imagen!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 35),
    );
  }

  return Image.file(
    File(producto.imagen!),
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.inventory_2, size: 35),
  );
}


  @override
  Widget build(BuildContext context) {
    final stockBajo = producto.stockBajo;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade100,
                child: _imagenProducto(),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.categoria,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Stock: ${producto.stock} | Mínimo: ${producto.stockMinimo}',
                    style: TextStyle(
                      color: stockBajo ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (stockBajo)
                    const Text(
                      '¡Existencias bajas!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            PopupMenuButton<String>(
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
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Editar'),
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}