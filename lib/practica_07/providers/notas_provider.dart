import 'package:flutter/material.dart';

import '../models/nota.dart';
import '../services/notas_service.dart';

class NotasProvider extends ChangeNotifier {
  final NotasService _service = NotasService();

  List<Nota> _notas = [];
  bool _cargando = false;
  String? _error;

  List<Nota> get notas => _notas;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarNotas() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _notas = await _service.listar();
    } catch (e) {
      _error = 'No se pudieron cargar las notas';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> guardarNota(Nota nota) async {
    try {
      if (nota.id == null) {
        await _service.insertar(nota);
      } else {
        await _service.actualizar(nota);
      }

      await cargarNotas();
      return true;
    } catch (e) {
      _error = 'No se pudo guardar la nota';
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarNota(int id) async {
    try {
      await _service.eliminar(id);
      await cargarNotas();
      return true;
    } catch (e) {
      _error = 'No se pudo eliminar la nota';
      notifyListeners();
      return false;
    }
  }
}