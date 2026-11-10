import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/preferences_service.dart';
import '../services/tarea_service.dart';

class TareaProvider extends ChangeNotifier {
  final TareaService _tareaService;
  final PreferenciasService _preferenciasService;

  TareaProvider({
    TareaService? tareaService,
    PreferenciasService? preferenciasService,
  })  : _tareaService = tareaService ?? TareaService(),
        _preferenciasService = preferenciasService ?? PreferenciasService();

  List<Tarea> _tareas = [];

  FiltroTareas _filtro = FiltroTareas.todas;

  String _nombre = 'Invitado';

  bool _cargando = true;

  String? _error;

  List<Tarea> get tareas => List.unmodifiable(_tareas);
  FiltroTareas get filtro => _filtro;
  String get nombre => _nombre;
  bool get cargando => _cargando;
  String? get error => _error;

  int get totalTareas => _tareas.length;

  int get tareasCompletadas =>
      _tareas.where((tarea) => tarea.completada).length;

  int get tareasPendientes =>
      _tareas.where((tarea) => !tarea.completada).length;

  Future<void> cargarInicial() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _nombre = await _preferenciasService.leerNombre();
      _filtro = await _preferenciasService.leerFiltro();

      await _cargarTareasSinNotificar();
    } catch (e) {
      _error = 'No se pudieron cargar los datos: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> _cargarTareasSinNotificar() async {
    _tareas = await _tareaService.obtenerTareas(_filtro);
  }

  Future<void> recargar() async {
    try {
      await _cargarTareasSinNotificar();
      _error = null;
    } catch (e) {
      _error = 'No se pudieron actualizar las tareas: $e';
    }

    notifyListeners();
  }

  Future<void> cambiarFiltro(FiltroTareas nuevoFiltro) async {
    if (_filtro == nuevoFiltro) return;

    _filtro = nuevoFiltro;
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _preferenciasService.guardarFiltro(nuevoFiltro);
      await _cargarTareasSinNotificar();
    } catch (e) {
      _error = 'No se pudo aplicar el filtro: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> crearTarea({
    required String titulo,
    required String descripcion,
  }) async {
    await _tareaService.crear(
      titulo: titulo,
      descripcion: descripcion,
    );

    await recargar();
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await _tareaService.actualizar(tarea);
    await recargar();
  }

  Future<void> cambiarEstado(Tarea tarea) async {
    await _tareaService.toggleCompletada(tarea);
    await recargar();
  }

  Future<void> eliminarTarea(int id) async {
    await _tareaService.eliminar(id);
    await recargar();
  }

  Future<void> guardarNombre(String nuevoNombre) async {
    await _preferenciasService.guardarNombre(nuevoNombre);

    _nombre = nuevoNombre;
    notifyListeners();
  }
}
