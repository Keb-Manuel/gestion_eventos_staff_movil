
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/incidencias_provider.dart';
import '../widgets/boton_menu.dart';
import '../widgets/encabezado_seccion.dart';
import 'formulario_incidencia_page.dart';
import 'lista_incidencias_page.dart';
import 'api_incidencias_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
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
        title: const Text('Reporte de Incidencias'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EncabezadoSeccion(
              titulo: 'Sistema de Reportes',
              descripcion:
                  'Registra, consulta y administra incidencias desde tu dispositivo.',
              icono: Icons.assignment,
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Reportes registrados',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${provider.incidencias.length}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            BotonMenu(
              texto: 'Registrar incidencia',
              icono: Icons.add,
              principal: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FormularioIncidenciaPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            BotonMenu(
              texto: 'Consultar reportes',
              icono: Icons.list_alt,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaIncidenciasPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            BotonMenu(
              texto: 'Consultar API REST',
              icono: Icons.cloud_download,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ApiIncidenciasPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}