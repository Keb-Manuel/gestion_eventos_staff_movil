import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FechaActual extends StatelessWidget {
  const FechaActual({super.key});

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat(
      'EEEE d MMMM yyyy',
      'es',
    ).format(DateTime.now());

    return Text(
      fecha,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
