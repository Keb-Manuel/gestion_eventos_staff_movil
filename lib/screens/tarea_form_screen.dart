import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tarea_provider.dart';
import '../widgets/boton_tarea.dart';

class TareaFormScreen extends StatefulWidget {
  final Tarea? tarea;

  const TareaFormScreen({
    super.key,
    this.tarea,
  });

  @override
  State<TareaFormScreen> createState() =>
      _TareaFormScreenState();
}

class _TareaFormScreenState extends State<TareaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;

  late bool _completada;

  bool _guardando = false;

  bool get esNueva => widget.tarea == null;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(
      text: widget.tarea?.titulo ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.tarea?.descripcion ?? '',
    );

    _completada = widget.tarea?.completada ?? false;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final provider = context.read<TareaProvider>();

      if (esNueva) {
        await provider.crearTarea(
          titulo: _tituloController.text.trim(),
          descripcion: _descripcionController.text.trim(),
        );
      } else {
        final tareaActualizada = widget.tarea!.copyWith(
          titulo: _tituloController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          completada: _completada,
        );

        await provider.actualizarTarea(tareaActualizada);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la tarea: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          esNueva ? 'Nueva tarea' : 'Editar tarea',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Escribe el título de la tarea',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'El título es obligatorio';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descripcionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Describe la tarea',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              minLines: 3,
              maxLines: 6,
            ),

            if (!esNueva) ...[
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Completada'),
                subtitle: const Text(
                  'Indica si terminaste esta tarea',
                ),
                value: _completada,
                onChanged: (valor) {
                  setState(() {
                    _completada = valor;
                  });
                },
              ),
            ],

            const SizedBox(height: 24),

            BotonTarea(
              texto: _guardando ? 'Guardando...' : 'Guardar',
              icono: Icons.save,
              onPressed: _guardando ? null : _guardar,
            ),
          ],
        ),
      ),
    );
  }
}