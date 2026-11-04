import 'package:flutter/material.dart';
import '../models/agente.dart';

class DetalleAgentePage extends StatelessWidget {
  final Agente agente;

  const DetalleAgentePage({
    super.key,
    required this.agente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(agente.nombre),
        backgroundColor: const Color(0xFFFF4655),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                agente.icono,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 120);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              agente.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rol: ${agente.rol}',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFFF4655),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              agente.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            const Text(
              'Habilidades',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...agente.habilidades.map((habilidad) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: habilidad.icono.isNotEmpty
                      ? Image.network(
                          habilidad.icono,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.flash_on);
                          },
                        )
                      : const Icon(Icons.flash_on),
                  title: Text(
                    habilidad.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(habilidad.descripcion),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}