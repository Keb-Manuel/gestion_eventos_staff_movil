import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/preferencias_service.dart';
import '../models/nota.dart';
import '../providers/notas_provider.dart';
import '../widgets/bienvenida_widget.dart';
import '../widgets/nota_card.dart';
import '../widgets/nota_form.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final TextEditingController _tituloController =
      TextEditingController();

  final TextEditingController _contenidoController =
      TextEditingController();

  final TextEditingController _nombreController =
      TextEditingController();

  int? _notaSeleccionada;
  String _nombreUsuario = 'Invitado';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotasProvider>().cargarNotas();
      _cargarNombre();
    });
  }

  Future<void> _cargarNombre() async {
    final nombre = await PreferenciasService.leerNombre();

    if (!mounted) return;

    setState(() {
      _nombreUsuario = nombre;
    });
  }

  Future<void> _guardarNota() async {
    final titulo = _tituloController.text.trim();
    final contenido = _contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      _mostrarMensaje('Completa el título y el contenido');
      return;
    }

    final nota = Nota(
      id: _notaSeleccionada,
      titulo: titulo,
      contenido: contenido,
    );

    final resultado = await context
        .read<NotasProvider>()
        .guardarNota(nota);

    if (!mounted) return;

    if (resultado) {
      _limpiarFormulario();
      _mostrarMensaje(
        _notaSeleccionada == null
            ? 'Nota guardada correctamente'
            : 'Nota actualizada correctamente',
      );
    } else {
      _mostrarMensaje('No se pudo guardar la nota');
    }
  }

  void _editarNota(Nota nota) {
    setState(() {
      _notaSeleccionada = nota.id;
      _tituloController.text = nota.titulo;
      _contenidoController.text = nota.contenido;
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

    if (confirmar != true || !mounted) return;

    final resultado = await context
        .read<NotasProvider>()
        .eliminarNota(id);

    if (!mounted) return;

    if (_notaSeleccionada == id) {
      _limpiarFormulario();
    }

    _mostrarMensaje(
      resultado
          ? 'Nota eliminada correctamente'
          : 'No se pudo eliminar la nota',
    );
  }

  Future<void> _cambiarNombre() async {
    _nombreController.text =
        _nombreUsuario == 'Invitado' ? '' : _nombreUsuario;

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
      ),
      body: Column(
        children: [
          BienvenidaWidget(
            nombre: _nombreUsuario,
            onCambiarNombre: _cambiarNombre,
          ),
          NotaForm(
            tituloController: _tituloController,
            contenidoController: _contenidoController,
            editando: _notaSeleccionada != null,
            onGuardar: _guardarNota,
            onCancelar: _limpiarFormulario,
          ),
          const Divider(),
          Expanded(
            child: Consumer<NotasProvider>(
              builder: (context, provider, child) {
                if (provider.cargando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Text(provider.error!),
                  );
                }

                if (provider.notas.isEmpty) {
                  return const Center(
                    child: Text('No hay notas guardadas'),
                  );
                }

                return ListView.builder(
                  itemCount: provider.notas.length,
                  itemBuilder: (context, index) {
                    final nota = provider.notas[index];

                    return NotaCard(
                      nota: nota,
                      onEditar: () => _editarNota(nota),
                      onEliminar: () => _eliminarNota(nota.id!),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}