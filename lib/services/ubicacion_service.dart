import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class UbicacionService {
  Future<Position> obtenerPosicion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception(
        'Activa el servicio de ubicación del dispositivo.',
      );
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado.');
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'Permiso bloqueado. Actívalo desde los ajustes.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      ),
    );
  }

  Future<void> abrirMapa(
    double latitud,
    double longitud,
  ) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=$latitud,$longitud',
    );

    final abierto = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!abierto) {
      throw Exception('No se pudo abrir Google Maps.');
    }
  }
}
