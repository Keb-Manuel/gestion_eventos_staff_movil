import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../services/tareas_db.dart';
import '../services/preferencias_tareas.dart';

class GestorTareasPage extends StatefulWidget {
  const GestorTareasPage({super.key});

  @override
  State<GestorTareasPage> createState() => _GestorTareasPageState();
}

class _GestorTareasPageState extends State<GestorTareasPage> {
  final TareasDB _db = TareasDB();
  final PreferenciasTareas _preferencias = PreferenciasTareas();

  List<Tarea> _tareas = [];
  String _filtro = 'Todas';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    _filtro = await _preferencias.obtenerFiltro();
    await _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final tareas = await _db.obtenerTareas();

    if (!mounted) return;

    setState(() {
      _tareas = tareas;
      _cargando = false;
    });
  }

  List<Tarea> get _tareasFiltradas {
    switch (_filtro) {
      case 'Pendientes':
        return _tareas.where((t) => !t.completada).toList();
      case 'Completadas':
        return _tareas.where((t) => t.completada).toList();
      default:
        return _tareas;
    }
  }

  Future<void> _cambiarFiltro(String filtro) async {
    setState(() => _filtro = filtro);
    await _preferencias.guardarFiltro(filtro);
  }

  Future<void> _mostrarFormulario({Tarea? tarea}) async {
    final tituloController = TextEditingController(
      text: tarea?.titulo ?? '',
    );

    final descripcionController = TextEditingController(
      text: tarea?.descripcion ?? '',
    );

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tarea == null ? 'Nueva tarea' : 'Editar tarea'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Escribe un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Escribe una descripción';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final nuevaTarea = Tarea(
                  id: tarea?.id,
                  titulo: tituloController.text.trim(),
                  descripcion: descripcionController.text.trim(),
                  completada: tarea?.completada ?? false,
                );

                if (tarea == null) {
                  await _db.insertarTarea(nuevaTarea);
                } else {
                  await _db.actualizarTarea(nuevaTarea);
                }

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);
                await _cargarTareas();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    tituloController.dispose();
    descripcionController.dispose();
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Deseas eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _db.eliminarTarea(tarea.id!);
      await _cargarTareas();
    }
  }

  Future<void> _cambiarEstado(Tarea tarea, bool? valor) async {
    final actualizada = tarea.copyWith(completada: valor ?? false);
    await _db.cambiarEstado(actualizada);
    await _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    final tareas = _tareasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas offline'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis tareas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _filtro,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar tareas',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Todas',
                            child: Text('Todas'),
                          ),
                          DropdownMenuItem(
                            value: 'Pendientes',
                            child: Text('Pendientes'),
                          ),
                          DropdownMenuItem(
                            value: 'Completadas',
                            child: Text('Completadas'),
                          ),
                        ],
                        onChanged: (valor) {
                          if (valor != null) _cambiarFiltro(valor);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tareas.isEmpty
                      ? const Center(
                          child: Text('No hay tareas para mostrar'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 90,
                          ),
                          itemCount: tareas.length,
                          itemBuilder: (context, index) {
                            final tarea = tareas[index];

                            return Card(
                              child: ListTile(
                                leading: Checkbox(
                                  value: tarea.completada,
                                  onChanged: (valor) =>
                                      _cambiarEstado(tarea, valor),
                                ),
                                title: Text(
                                  tarea.titulo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: tarea.completada
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text(tarea.descripcion),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (opcion) {
                                    if (opcion == 'editar') {
                                      _mostrarFormulario(tarea: tarea);
                                    } else if (opcion == 'eliminar') {
                                      _eliminarTarea(tarea);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'editar',
                                      child: Text('Editar'),
                                    ),
                                    PopupMenuItem(
                                      value: 'eliminar',
                                      child: Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
