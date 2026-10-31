import 'package:flutter/material.dart';

import '../../practica_05_api/models/usuario.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;

  const UsuarioCard({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(usuario.nombre[0]),
        ),
        title: Text(usuario.nombre),
        subtitle: Text(usuario.correo),
        trailing: Text('#${usuario.id}'),
      ),
    );
  }
}
