import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FechaActualWidget extends StatelessWidget {
  const FechaActualWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Text(
      'Fecha: $fecha',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
