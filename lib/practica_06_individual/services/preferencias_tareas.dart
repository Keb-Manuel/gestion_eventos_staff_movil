import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasTareas {
  static const String _claveFiltro = 'filtro_tareas';

  // Guardar el filtro seleccionado
  Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveFiltro, filtro);
  }

  // Recuperar el filtro guardado
  Future<String> obtenerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveFiltro) ?? 'Todas';
  }
}
