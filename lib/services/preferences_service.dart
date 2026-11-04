import 'package:shared_preferences/shared_preferences.dart';

enum FiltroTareas { todas, pendientes, completadas }

class PreferenciasService {
  static const _kNombre = 'nombre_usuario';
  static const _kFiltro = 'filtro_tareas';

  Future<void> guardarNombre(String nombre) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kNombre, nombre);
  }

  Future<String> leerNombre() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kNombre) ?? 'Invitado';
  }

  Future<void> guardarFiltro(FiltroTareas filtro) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kFiltro, filtro.index);
  }

  Future<FiltroTareas> leerFiltro() async {
    final p = await SharedPreferences.getInstance();
    final i = p.getInt(_kFiltro) ?? 0;
    if (i < 0 || i >= FiltroTareas.values.length) return FiltroTareas.todas;
    return FiltroTareas.values[i];
  }
}
