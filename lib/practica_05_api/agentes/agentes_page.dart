import 'package:flutter/material.dart';

import '../models/agente.dart';
import '../services/agente_service.dart';
import 'detalle_agente_page.dart';

class AgentesPage extends StatefulWidget {
  const AgentesPage({super.key});

  @override
  State<AgentesPage> createState() => _AgentesPageState();
}

class _AgentesPageState extends State<AgentesPage> {
  final AgenteService servicio = AgenteService();

  late Future<List<Agente>> futuroAgentes;

  @override
  void initState() {
    super.initState();
    futuroAgentes = servicio.obtenerAgentes();
  }

  Future<void> actualizarAgentes() async {
    setState(() {
      futuroAgentes = servicio.obtenerAgentes();
    });

    await futuroAgentes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agentes de VALORANT'),
        backgroundColor: const Color(0xFFFF4655),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Agente>>(
        future: futuroAgentes,
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
                  const Icon(Icons.error_outline, size: 50),
                  const SizedBox(height: 10),
                  const Text('Error al cargar los agentes'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: actualizarAgentes,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final agentes = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: actualizarAgentes,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: agentes.length,
              itemBuilder: (context, index) {
                final agente = agentes[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFF4655),
                      backgroundImage: agente.icono.isNotEmpty
                          ? NetworkImage(agente.icono)
                          : null,
                      child: agente.icono.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      agente.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(agente.rol),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleAgentePage(
                            agente: agente,
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