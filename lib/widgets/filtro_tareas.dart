import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class FiltroTareasWidget extends StatelessWidget {
  final FiltroTareas seleccionado;
  final ValueChanged<FiltroTareas> onChanged;

  const FiltroTareasWidget({
    super.key,
    required this.seleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Wrap(
        spacing: 8,
        children: [
          _crearChip('Todas', FiltroTareas.todas),
          _crearChip('Pendientes', FiltroTareas.pendientes),
          _crearChip('Completadas', FiltroTareas.completadas),
        ],
      ),
    );
  }

  Widget _crearChip(String texto, FiltroTareas filtro) {
    return ChoiceChip(
      label: Text(texto),
      selected: seleccionado == filtro,
      onSelected: (_) => onChanged(filtro),
    );
  }
}
