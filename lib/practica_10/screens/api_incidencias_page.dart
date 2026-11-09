import 'package:flutter/material.dart';

import '../services/api_incidencias_service.dart';

class ApiIncidenciasPage extends StatefulWidget {
  const ApiIncidenciasPage({super.key});

  @override
  State<ApiIncidenciasPage> createState() => _ApiIncidenciasPageState();
}

class _ApiIncidenciasPageState extends State<ApiIncidenciasPage> {
  final ApiIncidenciasService _api = ApiIncidenciasService();

  List<Map<String, dynamic>> incidencias = [];
  bool cargando = false;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await _api.obtenerIncidencias();

      if (!mounted) return;

      setState(() {
        incidencias = resultado;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'No se pudieron consultar los datos. Comprueba tu conexión.';
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidencias desde API REST'),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: cargarDatos,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: cargarDatos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: incidencias.length,
                    itemBuilder: (context, index) {
                      final incidencia = incidencias[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${incidencia['id']}'),
                          ),
                          title: Text(
                            incidencia['title'] ?? 'Sin título',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            incidencia['body'] ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}