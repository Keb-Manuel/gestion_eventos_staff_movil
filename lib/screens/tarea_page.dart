import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/preferences_service.dart';
import '../services/tarea_service.dart';
import 'tarea_form_screen.dart';

class TareasPage extends StatefulWidget {
  final TareaService? service;
  final PreferenciasService? prefs;
  const TareasPage({super.key, this.service, this.prefs});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  late final TareaService _service;
  late final PreferenciasService _prefs;

  List<Tarea> _tareas = [];
  FiltroTareas _filtro = FiltroTareas.todas;
  String _nombre = 'Invitado';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? TareaService();
    _prefs = widget.prefs ?? PreferenciasService();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    try {
      final nombre = await _prefs.leerNombre();
      final filtro = await _prefs.leerFiltro();
      final tareas = await _service.obtenerTareas(filtro);
      if (!mounted) return;
      setState(() {
        _nombre = nombre;
        _filtro = filtro;
        _tareas = tareas;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _cambiarFiltro(FiltroTareas filtro) async {
    await _prefs.guardarFiltro(filtro);
    final tareas = await _service.obtenerTareas(filtro);
    if (!mounted) return;
    setState(() {
      _filtro = filtro;
      _tareas = tareas;
    });
  }

  Future<void> _recargar() async {
    final tareas = await _service.obtenerTareas(_filtro);
    if (!mounted) return;
    setState(() => _tareas = tareas);
  }

  Future<void> _abrirFormulario({Tarea? tarea}) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TareaFormScreen(service: _service, tarea: tarea),
      ),
    );
    if (ok == true) _recargar();
  }

  Future<void> _toggle(Tarea t) async {
    await _service.toggleCompletada(t);
    _recargar();
  }

  Future<void> _eliminar(Tarea t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${t.titulo}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) {
      await _service.eliminar(t.id);
      _recargar();
    }
  }

  Future<void> _editarNombre() async {
    final ctrl = TextEditingController(text: _nombre);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (nuevo != null && nuevo.isNotEmpty) {
      await _prefs.guardarNombre(nuevo);
      if (!mounted) return;
      setState(() => _nombre = nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
            onPressed: _editarNombre,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hola, $_nombre',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (!_cargando && _tareas.isNotEmpty)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text('${_tareas.length}'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _chip('Todas', FiltroTareas.todas),
                const SizedBox(width: 8),
                _chip('Pendientes', FiltroTareas.pendientes),
                const SizedBox(width: 8),
                _chip('Completadas', FiltroTareas.completadas),
              ],
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: Text('Cargando...'))
                : _tareas.isEmpty
                    ? _estadoVacio()
                    : RefreshIndicator(
                        onRefresh: _recargar,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                          itemCount: _tareas.length,
                          itemBuilder: (_, i) {
                            final t = _tareas[i];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Checkbox(
                                  value: t.completada,
                                  onChanged: (_) => _toggle(t),
                                ),
                                title: Text(
                                  t.titulo,
                                  style: TextStyle(
                                    decoration: t.completada
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: t.descripcion.isEmpty
                                    ? null
                                    : Text(
                                        t.descripcion,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (v) => v == 'edit'
                                      ? _abrirFormulario(tarea: t)
                                      : _eliminar(t),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'edit', child: Text('Editar')),
                                    PopupMenuItem(
                                        value: 'del', child: Text('Eliminar')),
                                  ],
                                ),
                                onTap: () => _abrirFormulario(tarea: t),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, FiltroTareas filtro) => ChoiceChip(
        label: Text(label),
        selected: _filtro == filtro,
        onSelected: (_) => _cambiarFiltro(filtro),
      );

  Widget _estadoVacio() {
    final msg = switch (_filtro) {
      FiltroTareas.todas => 'No hay tareas. Crea la primera con el botón +.',
      FiltroTareas.pendientes => 'No hay tareas pendientes.',
      FiltroTareas.completadas => 'No hay tareas completadas.',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
