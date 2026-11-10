import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback onPressed;

  const CustomButton({
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
