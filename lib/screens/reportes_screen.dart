import 'package:flutter/material.dart';

import '../models/reporte.dart';
import '../services/database_service.dart';
import 'detalle_screen.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  List<Reporte> reportes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarReportes();
  }

  Future<void> cargarReportes() async {
    try {
      final datos = await DatabaseService.obtenerReportes();

      if (!mounted) return;

      setState(() {
        reportes = datos;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes registrados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : reportes.isEmpty
              ? const Center(
                  child: Text('No hay reportes registrados.'),
                )
              : RefreshIndicator(
                  onRefresh: cargarReportes,
                  child: ListView.builder(
                    itemCount: reportes.length,
                    itemBuilder: (context, index) {
                      final reporte = reportes[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.report,
                            color: Colors.blue,
                          ),
                          title: Text(reporte.titulo),
                          subtitle: Text(reporte.categoria),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleScreen(
                                  reporte: reporte,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
