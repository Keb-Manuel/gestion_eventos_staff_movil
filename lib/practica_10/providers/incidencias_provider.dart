import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/incidencia_database.dart';
import '../services/notificacion_service.dart';

class IncidenciasProvider extends ChangeNotifier {
  List<Incidencia> incidencias = [];
  bool cargando = false;
  String? error;

  Future<void> cargarIncidencias() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      incidencias = await IncidenciaDatabase.instance.obtenerTodas();
    } catch (e) {
      error = 'Error al cargar los reportes: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<bool> agregarIncidencia(Incidencia incidencia) async {
    try {
      final id = await IncidenciaDatabase.instance.insertar(incidencia);

      final nuevaIncidencia = Incidencia(
        id: id,
        titulo: incidencia.titulo,
        descripcion: incidencia.descripcion,
        categoria: incidencia.categoria,
        foto: incidencia.foto,
        latitud: incidencia.latitud,
        longitud: incidencia.longitud,
        fecha: incidencia.fecha,
      );

      incidencias.insert(0, nuevaIncidencia);

      await NotificacionService.mostrarNotificacion(
        titulo: 'Incidencia registrada',
        cuerpo: incidencia.titulo,
      );

      notifyListeners();
      return true;
    } catch (e) {
      error = 'No se pudo registrar la incidencia: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarIncidencia(int id) async {
    try {
      await IncidenciaDatabase.instance.eliminar(id);

      incidencias.removeWhere((incidencia) => incidencia.id == id);

      notifyListeners();
      return true;
    } catch (e) {
      error = 'No se pudo eliminar la incidencia: $e';
      notifyListeners();
      return false;
    }
  }
}