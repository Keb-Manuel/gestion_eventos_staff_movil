import 'package:flutter/material.dart';

import '../database/db.dart';
import '../services/preferencias_service.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final TextEditingController _tituloController = TextEditingController();

  final TextEditingController _contenidoController = TextEditingController();

  final TextEditingController _nombreController = TextEditingController();

  List<Map<String, dynamic>> _notas = [];
  int? _notaSeleccionada;
  String _nombreUsuario = 'Invitado';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final nombre = await PreferenciasService.leerNombre();
    await _cargarNotas();

    if (!mounted) return;

    setState(() {
      _nombreUsuario = nombre;
    });
  }

  Future<void> _cargarNotas() async {
    try {
      final notas = await DB.listar();

      if (!mounted) return;

      setState(() {
        _notas = notas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarMensaje('Error al consultar las notas');
    }
  }

  Future<void> _guardarNota() async {
    final titulo = _tituloController.text.trim();
    final contenido = _contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      _mostrarMensaje('Completa el título y el contenido');
      return;
    }

    try {
      if (_notaSeleccionada == null) {
        await DB.insertar(titulo, contenido);
        _mostrarMensaje('Nota guardada correctamente');
      } else {
        await DB.actualizar(
          _notaSeleccionada!,
          titulo,
          contenido,
        );
        _mostrarMensaje('Nota actualizada correctamente');
      }

      _limpiarFormulario();
      await _cargarNotas();
    } catch (e, stackTrace) {
      debugPrint('ERROR AL GUARDAR NOTA: $e');
      debugPrint('$stackTrace');

      _mostrarMensaje('Error al guardar: $e');
    }
  }

  void _editarNota(Map<String, dynamic> nota) {
    setState(() {
      _notaSeleccionada = nota['id'] as int;
      _tituloController.text = nota['titulo'] as String;
      _contenidoController.text = nota['contenido'] as String;
    });
  }

  void _limpiarFormulario() {
    _tituloController.clear();
    _contenidoController.clear();

    setState(() {
      _notaSeleccionada = null;
    });
  }

  Future<void> _eliminarNota(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta nota?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await DB.eliminar(id);

      if (_notaSeleccionada == id) {
        _limpiarFormulario();
      }

      await _cargarNotas();
      _mostrarMensaje('Nota eliminada correctamente');
    } catch (e) {
      _mostrarMensaje('No se pudo eliminar la nota');
    }
  }

  Future<void> _cambiarNombre() async {
    _nombreController.text = _nombreUsuario == 'Invitado' ? '' : _nombreUsuario;

    final nombre = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nombre de usuario'),
        content: TextField(
          controller: _nombreController,
          decoration: const InputDecoration(
            labelText: 'Escribe tu nombre',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                _nombreController.text.trim(),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nombre == null || nombre.isEmpty) return;

    await PreferenciasService.guardarNombre(nombre);

    if (!mounted) return;

    setState(() {
      _nombreUsuario = nombre;
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de notas offline'),
        actions: [
          IconButton(
            onPressed: _cambiarNombre,
            icon: const Icon(Icons.person),
            tooltip: 'Cambiar nombre',
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle),
                      const SizedBox(width: 8),
                      Text('Bienvenido, $_nombreUsuario'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título de la nota',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _contenidoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Contenido de la nota',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _guardarNota,
                              icon: Icon(
                                _notaSeleccionada == null
                                    ? Icons.save
                                    : Icons.edit,
                              ),
                              label: Text(
                                _notaSeleccionada == null
                                    ? 'Guardar'
                                    : 'Actualizar',
                              ),
                            ),
                          ),
                          if (_notaSeleccionada != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _limpiarFormulario,
                              icon: const Icon(Icons.close),
                              tooltip: 'Cancelar edición',
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _notas.isEmpty
                      ? const Center(
                          child: Text('No hay notas guardadas'),
                        )
                      : ListView.builder(
                          itemCount: _notas.length,
                          itemBuilder: (context, index) {
                            final nota = _notas[index];

                            return ListTile(
                              leading: const Icon(Icons.note),
                              title: Text(nota['titulo'] as String),
                              subtitle: Text(
                                nota['contenido'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _editarNota(nota),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _eliminarNota(nota['id'] as int),
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
