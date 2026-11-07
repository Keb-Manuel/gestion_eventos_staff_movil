
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/punto_interes.dart';
import '../providers/ubicacion_provider.dart';

class UbicacionPage extends StatelessWidget {
  const UbicacionPage({super.key});

  String _formatearDistancia(double? distancia) {
    if (distancia == null) return 'No disponible';

    if (distancia < 1000) {
      return '${distancia.toStringAsFixed(0)} m';
    }

    return '${(distancia / 1000).toStringAsFixed(2)} km';
  }

  Future<void> _agregarPunto(BuildContext context) async {
    final punto = await showDialog<PuntoInteres>(
      context: context,
      builder: (_) => const _FormularioPuntoDialog(),
    );

    if (punto == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    try {
      await context.read<UbicacionProvider>().agregarPunto(punto);
    } catch (e) {
      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 8 - Geolocalización'),
        centerTitle: true,
      ),
      body: Consumer<UbicacionProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.obtenerUbicacion,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mi ubicación actual',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (provider.cargando)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (provider.posicionActual != null) ...[
                          Text(
                            'Latitud: ${provider.posicionActual!.latitude}',
                          ),
                          Text(
                            'Longitud: ${provider.posicionActual!.longitude}',
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ubicación obtenida correctamente.',
                          ),
                        ] else
                          Text(
                            provider.error ??
                                'Presiona el botón para obtener tu ubicación.',
                          ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: provider.cargando
                                ? null
                                : provider.obtenerUbicacion,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Obtener mi ubicación'),
                          ),
                        ),
                        if (provider.posicionActual != null) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final messenger =
                                    ScaffoldMessenger.of(context);

                                final posicion = provider.posicionActual!;

                                try {
                                  await provider.abrirMapa(
                                    PuntoInteres(
                                      nombre: 'Mi ubicación',
                                      latitud: posicion.latitude,
                                      longitud: posicion.longitude,
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  messenger.showSnackBar(
                                    SnackBar(content: Text('$e')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('Abrir en Google Maps'),
                            ),
                          ),
                        ],
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
                    ElevatedButton.icon(
                      onPressed: () => _agregarPunto(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (provider.puntos.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Todavía no tienes puntos guardados.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  ...provider.puntos.asMap().entries.map((entry) {
                    final indice = entry.key;
                    final punto = entry.value;

                    final distancia =
                        provider.distanciaAlPunto(punto);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.place),
                        ),
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
                            final messenger =
                                ScaffoldMessenger.of(context);

                            if (opcion == 'mapa') {
                              try {
                                await provider.abrirMapa(punto);
                              } catch (e) {
                                if (!context.mounted) return;

                                messenger.showSnackBar(
                                  SnackBar(content: Text('$e')),
                                );
                              }
                            } else if (opcion == 'eliminar') {
                              try {
                                await provider.eliminarPunto(indice);
                              } catch (e) {
                                if (!context.mounted) return;

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No se pudo eliminar: $e',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (_) => const [
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
            ),
          );
        },
      ),
    );
  }
}

class _FormularioPuntoDialog extends StatefulWidget {
  const _FormularioPuntoDialog();

  @override
  State<_FormularioPuntoDialog> createState() =>
      _FormularioPuntoDialogState();
}

class _FormularioPuntoDialogState
    extends State<_FormularioPuntoDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final latitud = double.tryParse(
      _latitudController.text.trim(),
    );

    final longitud = double.tryParse(
      _longitudController.text.trim(),
    );

    if (latitud == null ||
        longitud == null ||
        latitud < -90 ||
        latitud > 90 ||
        longitud < -180 ||
        longitud > 180) {
      setState(() {
        _error = 'Ingresa coordenadas válidas.';
      });
      return;
    }

    Navigator.of(context).pop(
      PuntoInteres(
        nombre: _nombreController.text.trim(),
        latitud: latitud,
        longitud: longitud,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar punto de interés'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del lugar',
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Escribe el nombre del lugar.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _latitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la latitud.';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Ingresa un número válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _longitudController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la longitud.';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Ingresa un número válido.';
                  }
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
