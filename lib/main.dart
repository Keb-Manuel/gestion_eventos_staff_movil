import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UbicacionPage(),
  ));
}

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  Position? posicion;
  String mensaje = 'Sin ubicación';
  bool cargando = false;

  // Obtiene la ubicación actual del dispositivo.
  Future<void> obtener() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });

    try {
      // Comprobar si el GPS está activado.
      final servicioActivo = await Geolocator.isLocationServiceEnabled();

      if (!servicioActivo) {
        setState(() {
          mensaje = 'Activa el servicio de ubicación';
          posicion = null;
        });
        return;
      }

      // Comprobar los permisos.
      LocationPermission permiso = await Geolocator.checkPermission();

      // Solicitar permiso si está denegado.
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }

      // Verificar si el permiso fue rechazado.
      if (permiso == LocationPermission.denied) {
        setState(() {
          mensaje = 'Permiso de ubicación denegado';
          posicion = null;
        });
        return;
      }

      // Verificar si el permiso fue denegado permanentemente.
      if (permiso == LocationPermission.deniedForever) {
        setState(() {
          mensaje = 'Permiso bloqueado. Actívalo en ajustes';
          posicion = null;
        });
        return;
      }

      // Obtener las coordenadas actuales.
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      if (!mounted) return;

      setState(() {
        posicion = p;
        mensaje = 'Ubicación obtenida correctamente';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = 'Error al obtener ubicación: $e';
        posicion = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  // Abre Google Maps con las coordenadas obtenidas.
  Future<void> abrirMapa() async {
    if (posicion == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${posicion!.latitude},${posicion!.longitude}',
    );

    try {
      final abierto = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el mapa'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el mapa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi ubicación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 90,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              if (cargando) const CircularProgressIndicator(),
              if (posicion != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latitud: ${posicion!.latitude}',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Longitud: ${posicion!.longitude}',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Precisión: ${posicion!.accuracy} m',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: cargando ? null : obtener,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Obtener ubicación'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: posicion == null ? null : abrirMapa,
                  icon: const Icon(Icons.map),
                  label: const Text('Abrir en mapa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
