import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/punto_interes.dart';

class UbicacionService {
  // Obtener la ubicación actual del dispositivo.
  Future<Position> obtenerPosicionActual() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el servicio de ubicación');
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso está denegado permanentemente',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // Calcular la distancia entre la ubicación actual y un punto.
  double calcularDistancia(
    Position posicionActual,
    PuntoInteres punto,
  ) {
    return Geolocator.distanceBetween(
      posicionActual.latitude,
      posicionActual.longitude,
      punto.latitud,
      punto.longitud,
    );
  }

  // Abrir Google Maps con las coordenadas del punto.
  Future<void> abrirMapa(
    double latitud,
    double longitud,
  ) async {
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '$latitud,$longitud',
      },
    );

    final abierto = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!abierto) {
      throw Exception('No se pudo abrir Google Maps');
    }
  }
}
