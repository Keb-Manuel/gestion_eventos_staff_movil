import '../database/db.dart';
import '../models/tarea.dart';
import 'preferences_service.dart';

class TareaService {
  Future<List<Tarea>> obtenerTareas(FiltroTareas filtro) async {
    bool? solo;
    switch (filtro) {
      case FiltroTareas.todas:
        solo = null;
        break;
      case FiltroTareas.pendientes:
        solo = false;
        break;
      case FiltroTareas.completadas:
        solo = true;
        break;
    }
    final filas = await DB.listarTareas(soloCompletadas: solo);
    return filas.map(Tarea.fromRow).toList();
  }

  Future<void> crear({
    required String titulo,
    required String descripcion,
  }) =>
      DB.insertarTarea(titulo: titulo, descripcion: descripcion);

  Future<void> actualizar(Tarea t) => DB.actualizarTarea(
        t.id,
        titulo: t.titulo,
        descripcion: t.descripcion,
        completada: t.completada,
      );

  Future<void> toggleCompletada(Tarea t) =>
      DB.toggleCompletada(t.id, !t.completada);

  Future<void> eliminar(int id) => DB.eliminarTarea(id);
}