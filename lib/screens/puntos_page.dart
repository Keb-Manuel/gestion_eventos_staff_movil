import 'package:flutter/material.dart';
import '../models/punto_interes.dart';
import '../services/ubicacion_service.dart';
import '../widgets/punto_card.dart';
import 'distancia_page.dart';
import 'registrar_punto_page.dart';

class PuntosPage extends StatefulWidget {
  final UbicacionService servicio;

  const PuntosPage({
    super.key,
    required this.servicio,
  });

  @override
  State<PuntosPage> createState() => _PuntosPageState();
}

class _PuntosPageState extends State<PuntosPage> {
  final List<PuntoInteres> puntos = [];

  Future<void> registrarPunto() async {
    final resultado = await Navigator.push<PuntoInteres>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarPuntoPage(
          servicio: widget.servicio,
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    setState(() {
      puntos.add(resultado);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Punto de interés registrado correctamente.'),
      ),
    );
  }

  Future<void> abrirMapa(PuntoInteres punto) async {
    try {
      await widget.servicio.abrirMapa(
        punto.latitud,
        punto.longitud,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  void eliminarPunto(int indice) {
    setState(() {
      puntos.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Punto eliminado.'),
      ),
    );
  }

  void abrirDistancias() {
    if (puntos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registra al menos dos puntos para calcular distancias.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DistanciaPage(
          puntos: List.unmodifiable(puntos),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de interés'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: abrirDistancias,
            tooltip: 'Calcular distancia',
            icon: const Icon(Icons.route),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mis lugares registrados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total de puntos: ${puntos.length}',
                ),
              ],
            ),
          ),
          Expanded(
            child: puntos.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 70,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay puntos registrados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Utiliza el botón para agregar tu primer lugar.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: puntos.length,
                    itemBuilder: (context, index) {
                      final punto = puntos[index];

                      return PuntoCard(
                        punto: punto,
                        onAbrirMapa: () => abrirMapa(punto),
                        onEliminar: () => eliminarPunto(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: registrarPunto,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar punto'),
      ),
    );
  }
}
