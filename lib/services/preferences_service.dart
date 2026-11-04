import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _kNombre = 'nombre_usuario';
  static const _kUltimaSync = 'ultima_sincronizacion';

  Future<void> guardarNombre(String nombre) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kNombre, nombre);
  }

  Future<String> leerNombre() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kNombre) ?? 'Invitado';
  }

  Future<void> guardarUltimaSync(DateTime d) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUltimaSync, d.toIso8601String());
  }

  Future<DateTime?> leerUltimaSync() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kUltimaSync);
    return s == null ? null : DateTime.tryParse(s);
  }
}
