import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/punto_interes.dart';
import '../providers/ubicacion_provider.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UbicacionProvider>().cargarPuntos();
    });
  }

  Future<void> _agregarPunto() async {
    final nombreController = TextEditingController();
    final latitudController = TextEditingController();
    final longitudController = TextEditingController();

    final punto = await showDialog<PuntoInteres>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo punto de interés'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del lugar',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: latitudController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Latitud',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: longitudController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Longitud',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final nombre = nombreController.text.trim();
                final latitud = double.tryParse(latitudController.text.trim());
                final longitud =
                    double.tryParse(longitudController.text.trim());

                if (nombre.isEmpty ||
                    latitud == null ||
                    longitud == null ||
                    latitud < -90 ||
                    latitud > 90 ||
                    longitud < -180 ||
                    longitud > 180) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ingresa un nombre y coordenadas válidas.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  PuntoInteres(
                    nombre: nombre,
                    latitud: latitud,
                    longitud: longitud,
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    nombreController.dispose();
    latitudController.dispose();
    longitudController.dispose();

    if (punto != null && mounted) {
      try {
        await context.read<UbicacionProvider>().agregarPunto(punto);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo guardar: $e')),
          );
        }
      }
    }
  }

  String _formatearDistancia(double distancia) {
    if (distancia >= 1000) {
      return '${(distancia / 1000).toStringAsFixed(2)} km';
    }

    return '${distancia.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS y geolocalización'),
        centerTitle: true,
      ),
      body: Consumer<UbicacionProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.my_location, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Mi ubicación actual',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (provider.cargando)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else if (provider.error != null)
                        Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (provider.posicionActual != null) ...[
                        Text(
                          'Latitud: ${provider.posicionActual!.latitude}',
                        ),
                        Text(
                          'Longitud: ${provider.posicionActual!.longitude}',
                        ),
                        Text(
                          'Precisión: '
                          '${provider.posicionActual!.accuracy.toStringAsFixed(2)} metros',
                        ),
                      ] else
                        const Text(
                          'Todavía no se ha obtenido la ubicación.',
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: provider.cargando
                              ? null
                              : provider.obtenerUbicacion,
                          icon: const Icon(Icons.location_searching),
                          label: const Text('Obtener ubicación'),
                        ),
                      ),
                      if (provider.posicionActual != null)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final posicion = provider.posicionActual!;

                              provider.abrirMapa(
                                PuntoInteres(
                                  nombre: 'Mi ubicación',
                                  latitud: posicion.latitude,
                                  longitud: posicion.longitude,
                                ),
                              );
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Abrir en Google Maps'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Puntos de interés',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _agregarPunto,
                    icon: const Icon(Icons.add_location_alt),
                    label: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (provider.puntos.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No hay puntos registrados. Agrega al menos tres '
                      'lugares para completar el ejercicio.',
                    ),
                  ),
                )
              else
                ...List.generate(provider.puntos.length, (indice) {
                  final punto = provider.puntos[indice];
                  final distancia = provider.distanciaAlPunto(punto);

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(punto.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitud: ${punto.latitud}'),
                          Text('Longitud: ${punto.longitud}'),
                          Text(
                            distancia == null
                                ? 'Obtén tu ubicación para calcular la distancia.'
                                : 'Distancia: ${_formatearDistancia(distancia)}',
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (opcion) async {
                          if (opcion == 'mapa') {
                            final messenger = ScaffoldMessenger.of(context);

                            try {
                              await provider.abrirMapa(punto);
                            } catch (e) {
                              if (!mounted) return;

                              messenger.showSnackBar(
                                SnackBar(content: Text('$e')),
                              );
                            }
                          } else if (opcion == 'eliminar') {
                            await provider.eliminarPunto(indice);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'mapa',
                            child: Text('Abrir en Google Maps'),
                          ),
                          PopupMenuItem(
                            value: 'eliminar',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
