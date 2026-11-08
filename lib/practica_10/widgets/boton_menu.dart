import 'package:flutter/material.dart';

class BotonMenu extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback onPressed;
  final bool principal;

  const BotonMenu({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    this.principal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (principal) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(texto),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}