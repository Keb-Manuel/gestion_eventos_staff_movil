import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tarea_provider.dart';
import '../services/preferences_service.dart';
import '../widgets/encabezado_tareas.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/filtro_tareas.dart';
import '../widgets/tarea_card.dart';
import 'tarea_form_screen.dart';

class TareasPage extends StatelessWidget {
  const TareasPage({super.key});

  Future<void> _editarNombre(
    BuildContext context,
    TareaProvider provider,
  ) async {
    final controller = TextEditingController(
      text: provider.nombre,
    );

    final nuevoNombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                controller.text.trim(),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
      await provider.guardarNombre(nuevoNombre);
    }
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    Tarea? tarea,
  }) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TareaFormScreen(tarea: tarea),
      ),
    );

    if (resultado == true && context.mounted) {
      await context.read<TareaProvider>().recargar();
    }
  }

  Future<void> _eliminarTarea(
    BuildContext context,
    Tarea tarea,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text(
          '¿Deseas eliminar "${tarea.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await context.read<TareaProvider>().eliminarTarea(
              tarea.id,
            );
      } catch (e) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo eliminar la tarea: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
            onPressed: () => _editarNombre(
              context,
              context.read<TareaProvider>(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: Consumer<TareaProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.tareas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: provider.cargarInicial,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              EncabezadoTareas(
                nombre: provider.nombre,
                cantidad: provider.totalTareas,
              ),

              FiltroTareasWidget(
                seleccionado: provider.filtro,
                onChanged: provider.cambiarFiltro,
              ),

              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              Expanded(
                child: provider.tareas.isEmpty
                    ? EstadoVacio(filtro: provider.filtro)
                    : RefreshIndicator(
                        onRefresh: provider.recargar,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            12,
                            8,
                            12,
                            80,
                          ),
                          itemCount: provider.tareas.length,
                          itemBuilder: (context, index) {
                            final tarea = provider.tareas[index];

                            return TareaCard(
                              key: ValueKey(tarea.id),
                              tarea: tarea,
                              onCambiarEstado: () async {
                                try {
                                  await context
                                      .read<TareaProvider>()
                                      .cambiarEstado(tarea);
                                } catch (e) {
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudo cambiar el estado: $e',
                                      ),
                                    ),
                                  );
                                }
                              },
                              onEditar: () => _abrirFormulario(
                                context,
                                tarea: tarea,
                              ),
                              onEliminar: () => _eliminarTarea(
                                context,
                                tarea,
                              ),
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