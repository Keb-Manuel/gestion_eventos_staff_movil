import 'package:geolocator/geolocator.dart';

class UbicacionService {
  static Future<Position> obtenerUbicacion() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el GPS del dispositivo.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw Exception('No se concedió el permiso de ubicación.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
