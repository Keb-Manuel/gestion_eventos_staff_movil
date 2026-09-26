import 'package:flutter/material.dart';

import '../models/Materia.dart';
import '../widgets/formulario_producto.dart';
import '../widgets/lista_productos.dart';
import '../widgets/resumen_inventario.dart';

class RegistroProductosPage extends StatefulWidget {
  const RegistroProductosPage({super.key});

  @override
  State<RegistroProductosPage> createState() =>
      _RegistroProductosPageState();
}

class _RegistroProductosPageState
    extends State<RegistroProductosPage> {
  final List<Producto> productos = [];

  void agregarProducto(Producto producto) {
    setState(() {
      productos.add(producto);
    });
  }

  void eliminarProducto(int index) {
    final producto = productos[index];

    setState(() {
      productos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${producto.nombre} eliminado',
        ),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            setState(() {
              productos.insert(index, producto);
            });
          },
        ),
      ),
    );
  }

  double calcularTotalInventario() {
    return productos.fold(
      0,
      (total, producto) => total + producto.valorInventario,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de productos'),
        centerTitle: true,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final esPantallaGrande = constraints.maxWidth >= 900;

          if (esPantallaGrande) {
            return _buildLayoutGrande();
          }

          return _buildLayoutPequeno();
        },
      ),
    );
  }

  Widget _buildLayoutGrande() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nuevo producto',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                        ),

                        const SizedBox(height: 20),

                        FormularioProducto(
                          onAgregar: agregarProducto,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    ResumenInventario(
                      total: calcularTotalInventario(),
                      cantidadProductos: productos.length,
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: ListaProductos(
                        productos: productos,
                        onEliminar: eliminarProducto,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildLayoutPequeno() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FormularioProducto(
              onAgregar: agregarProducto,
            ),
          ),
        ),

        const SizedBox(height: 16),

        ResumenInventario(
          total: calcularTotalInventario(),
          cantidadProductos: productos.length,
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 300,
          child: ListaProductos(
            productos: productos,
            onEliminar: eliminarProducto,
          ),
        ),
      ],
    ),
  );
}
}