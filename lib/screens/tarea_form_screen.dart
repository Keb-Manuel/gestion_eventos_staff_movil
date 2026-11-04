import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/tarea_service.dart';

class TareaFormScreen extends StatefulWidget {
  final Tarea? tarea;
  final TareaService service;
  const TareaFormScreen({super.key, this.tarea, required this.service});

  @override
  State<TareaFormScreen> createState() => _TareaFormScreenState();
}

class _TareaFormScreenState extends State<TareaFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _desc;
  late bool _completada;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.tarea?.titulo ?? '');
    _desc = TextEditingController(text: widget.tarea?.descripcion ?? '');
    _completada = widget.tarea?.completada ?? false;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;

    if (widget.tarea == null) {
      await widget.service.crear(
        titulo: _titulo.text.trim(),
        descripcion: _desc.text.trim(),
      );
    } else {
      await widget.service.actualizar(widget.tarea!.copyWith(
        titulo: _titulo.text.trim(),
        descripcion: _desc.text.trim(),
        completada: _completada,
      ));
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.tarea == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esNueva ? 'Nueva tarea' : 'Editar tarea'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 6,
            ),
            if (!esNueva)
              SwitchListTile(
                title: const Text('Completada'),
                value: _completada,
                onChanged: (v) => setState(() => _completada = v),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
