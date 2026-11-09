import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incidencias_provider.dart';
import 'detalle_incidencia_page.dart';

class ListaIncidenciasPage extends StatefulWidget {
  const ListaIncidenciasPage({super.key});

  @override
  State<ListaIncidenciasPage> createState() =>
      _ListaIncidenciasPageState();
}

class _ListaIncidenciasPageState extends State<ListaIncidenciasPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidenciasProvider>().cargarIncidencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidenciasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes registrados'),
      ),
      body: Builder(
        builder: (context) {
          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.incidencias.isEmpty) {
            return Center(
              child: Text(provider.error!),
            );
          }

          if (provider.incidencias.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No hay incidencias registradas.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.cargarIncidencias,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.incidencias.length,
              itemBuilder: (context, index) {
                final incidencia = provider.incidencias[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: incidencia.foto != null &&
                            File(incidencia.foto!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(incidencia.foto!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.report_problem),
                          ),
                    title: Text(
                      incidencia.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${incidencia.categoria}\n'
                      '${incidencia.fecha.day.toString().padLeft(2, '0')}/'
                      '${incidencia.fecha.month.toString().padLeft(2, '0')}/'
                      '${incidencia.fecha.year}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleIncidenciaPage(
                            incidencia: incidencia,
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