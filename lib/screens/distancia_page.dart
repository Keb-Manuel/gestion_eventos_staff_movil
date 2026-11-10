import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/punto_interes.dart';

class DistanciaPage extends StatefulWidget {
  final List<PuntoInteres> puntos;

  const DistanciaPage({
    super.key,
    required this.puntos,
  });

  @override
  State<DistanciaPage> createState() => _DistanciaPageState();
}

class _DistanciaPageState extends State<DistanciaPage> {
  PuntoInteres? punto1;
  PuntoInteres? punto2;
  double? distancia;

  void calcularDistancia() {
    if (punto1 == null || punto2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona los dos puntos.'),
        ),
      );
      return;
    }

    if (identical(punto1, punto2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona dos puntos diferentes.'),
        ),
      );
      return;
    }

    final resultado = Geolocator.distanceBetween(
      punto1!.latitud,
      punto1!.longitud,
      punto2!.latitud,
      punto2!.longitud,
    );

    setState(() {
      distancia = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular distancia'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.route,
              size: 90,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Selecciona los puntos de interés',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            DropdownButtonFormField<PuntoInteres>(
              initialValue: punto1,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Primer punto',
                border: OutlineInputBorder(),
              ),
              items: widget.puntos.map((punto) {
                return DropdownMenuItem(
                  value: punto,
                  child: Text(punto.nombre),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  punto1 = valor;
                  distancia = null;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<PuntoInteres>(
              initialValue: punto2,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Segundo punto',
                border: OutlineInputBorder(),
              ),
              items: widget.puntos.map((punto) {
                return DropdownMenuItem(
                  value: punto,
                  child: Text(punto.nombre),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  punto2 = valor;
                  distancia = null;
                });
              },
            ),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: widget.puntos.length < 2 ? null : calcularDistancia,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular distancia'),
            ),
            const SizedBox(height: 25),
            if (distancia != null)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.straighten,
                        size: 45,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Distancia entre los puntos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${distancia!.toStringAsFixed(2)} metros',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '${(distancia! / 1000).toStringAsFixed(3)} kilómetros',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
