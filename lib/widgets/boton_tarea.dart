import 'package:flutter/material.dart';

class BotonTarea extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onPressed;

  const BotonTarea({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}
