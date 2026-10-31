import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/usuario_provider.dart';
import '../widgets/usuario_card.dart';
import '../widgets/fecha_actual_widget.dart';
import 'contador_page.dart';

class UsuariosProviderPage extends StatefulWidget {
  const UsuariosProviderPage({super.key});

  @override
  State<UsuariosProviderPage> createState() => _UsuariosProviderPageState();
}

class _UsuariosProviderPageState extends State<UsuariosProviderPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuarioProvider>().cargarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios con Provider'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: FechaActualWidget(),
            ),
          ),
        ],
      ),
      body: Consumer<UsuarioProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.cargarUsuarios,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.usuarios.isEmpty) {
            return const Center(
              child: Text('No hay usuarios disponibles'),
            );
          }

          return ListView.builder(
            itemCount: provider.usuarios.length,
            itemBuilder: (context, index) {
              final usuario = provider.usuarios[index];

              return UsuarioCard(
                usuario: usuario,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UsuarioProvider>().cargarUsuarios();
        },
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContadorPage(),
              ),
            );
          },
          icon: const Icon(Icons.calculate),
          label: const Text('Ir al contador'),
        ),
      ),
    );
  }
}
