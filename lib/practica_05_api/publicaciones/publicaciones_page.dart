import 'package:flutter/material.dart';

import '../models/publicacion.dart';
import '../services/publicacion_service.dart';
import 'detalle_publicacion_page.dart';

class PublicacionesPage extends StatefulWidget {
  const PublicacionesPage({super.key});

  @override
  State<PublicacionesPage> createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  final PublicacionService servicio = PublicacionService();

  late Future<List<Publicacion>> futuroPublicaciones;

  @override
  void initState() {
    super.initState();
    futuroPublicaciones = servicio.obtenerPublicaciones();
  }

  Future<void> actualizarPublicaciones() async {
    setState(() {
      futuroPublicaciones = servicio.obtenerPublicaciones();
    });

    await futuroPublicaciones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Publicacion>>(
        future: futuroPublicaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error al cargar las publicaciones'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: actualizarPublicaciones,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final publicaciones = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: actualizarPublicaciones,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: publicaciones.length,
              itemBuilder: (context, index) {
                final publicacion = publicaciones[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${publicacion.id}'),
                    ),
                    title: Text(
                      publicacion.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      publicacion.contenido,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePublicacionPage(
                            publicacion: publicacion,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
