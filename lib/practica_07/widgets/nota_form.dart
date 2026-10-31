import 'package:flutter/material.dart';

class NotaForm extends StatelessWidget {
  final TextEditingController tituloController;
  final TextEditingController contenidoController;
  final bool editando;
  final VoidCallback onGuardar;
  final VoidCallback onCancelar;

  const NotaForm({
    super.key,
    required this.tituloController,
    required this.contenidoController,
    required this.editando,
    required this.onGuardar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            controller: tituloController,
            decoration: const InputDecoration(
              labelText: 'Título de la nota',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: contenidoController,
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
                  onPressed: onGuardar,
                  icon: Icon(editando ? Icons.edit : Icons.save),
                  label: Text(editando ? 'Actualizar' : 'Guardar'),
                ),
              ),
              if (editando) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onCancelar,
                  icon: const Icon(Icons.close),
                  tooltip: 'Cancelar edición',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}