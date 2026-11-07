import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'services/usuario_service.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuario>> futuro;

  final UsuarioService servicio = UsuarioService();

  @override
  void initState() {
    super.initState();
    futuro = servicio.obtenerUsuarios();
  }

  Future<void> actualizarUsuarios() async {
    setState(() {
      futuro = servicio.obtenerUsuarios();
    });

    await futuro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Usuario>>(
        future: futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final usuarios = snapshot.data ?? [];

          if (usuarios.isEmpty) {
            return const Center(
              child: Text('No hay usuarios disponibles'),
            );
          }

          return RefreshIndicator(
            onRefresh: actualizarUsuarios,
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${usuario.id}'),
                  ),
                  title: Text(usuario.nombre),
                  subtitle: Text(usuario.correo),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
