import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../models/punto_interes.dart';
import '../services/puntos_interes_service.dart';
import '../services/ubicacion_service.dart';

class UbicacionProvider extends ChangeNotifier {
  final UbicacionService _ubicacionService = UbicacionService();
  final PuntosInteresService _puntosService = PuntosInteresService();

  Position? posicionActual;
  bool cargando = false;
  String? error;

  final List<PuntoInteres> puntos = [];

  Future<void> cargarPuntos() async {
    try {
      final guardados = await _puntosService.obtenerPuntos();
      puntos
        ..clear()
        ..addAll(guardados);
      notifyListeners();
    } catch (e) {
      error = 'No se pudieron cargar los puntos: $e';
      notifyListeners();
    }
  }

  Future<void> obtenerUbicacion() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      posicionActual = await _ubicacionService.obtenerPosicionActual();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregarPunto(PuntoInteres punto) async {
    puntos.add(punto);
    await _puntosService.guardarPuntos(puntos);
    notifyListeners();
  }

  Future<void> eliminarPunto(int indice) async {
    puntos.removeAt(indice);
    await _puntosService.guardarPuntos(puntos);
    notifyListeners();
  }

  double? distanciaAlPunto(PuntoInteres punto) {
    if (posicionActual == null) return null;

    return _ubicacionService.calcularDistancia(
      posicionActual!,
      punto,
    );
  }

  Future<void> abrirMapa(PuntoInteres punto) async {
    await _ubicacionService.abrirMapa(
      punto.latitud,
      punto.longitud,
    );
  }
}
