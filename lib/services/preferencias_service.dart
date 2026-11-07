import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  // Guardar el nombre del usuario
  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nombre_usuario', nombre);
  }

  // Leer el nombre guardado
  static Future<String> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('nombre_usuario') ?? 'Invitado';
  }
}
