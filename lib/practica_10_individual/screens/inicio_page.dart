import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventario_provider.dart';
import 'inventario_page.dart';
import 'producto_form_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InventarioProvider>().inicializar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'StockSmart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Actualizar inventario',
            onPressed: () {
              context.read<InventarioProvider>().cargarProductos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          if (provider.cargando && provider.productos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.cargarProductos,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Panel de control',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172554),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Resumen general de tu inventario',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),

                if (provider.error != null)
                  Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        provider.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      trailing: IconButton(
                        onPressed: provider.limpiarError,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),

                Row(
                  children: [
                    Expanded(
                      child: _TarjetaResumen(
                        titulo: 'Productos',
                        valor: provider.totalProductos.toString(),
                        icono: Icons.inventory_2,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TarjetaResumen(
                        titulo: 'Unidades',
                        valor: provider.totalUnidades.toString(),
                        icono: Icons.widgets,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _TarjetaResumen(
                  titulo: 'Productos con stock bajo',
                  valor: provider.productosStockBajo.toString(),
                  icono: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  horizontal: true,
                ),

                const SizedBox(height: 30),

                const Text(
                  'Administración',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                _BotonAccion(
                  titulo: 'Ver inventario',
                  descripcion: 'Consultar, editar y eliminar productos',
                  icono: Icons.inventory,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InventarioPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _BotonAccion(
                  titulo: 'Registrar producto',
                  descripcion: 'Agregar un nuevo producto con fotografía',
                  icono: Icons.add_box,
                  color: Colors.green,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductoFormPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _BotonAccion(
                  titulo: 'Importar desde API REST',
                  descripcion: 'Obtener productos de DummyJSON',
                  icono: Icons.cloud_download,
                  color: Colors.deepPurple,
                  onTap: () async {
                    final importados = await context
                        .read<InventarioProvider>()
                        .importarProductosApi();

                    if (!context.mounted) return;

                    final error = context
                        .read<InventarioProvider>()
                        .error;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error ??
                              'Se importaron $importados productos nuevos.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;
  final bool horizontal;

  const _TarjetaResumen({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: horizontal
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(icono, color: color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(titulo)),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icono, color: color, size: 30),
                  const SizedBox(height: 12),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    titulo,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BotonAccion extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}