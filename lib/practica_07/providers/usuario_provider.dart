import 'package:flutter/foundation.dart';

import '../../practica_05_api/models/usuario.dart';
import '../../practica_05_api/services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();

  List<Usuario> _usuarios = [];
  bool _cargando = false;
  String? _error;

  List<Usuario> get usuarios => _usuarios;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarUsuarios() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await _usuarioService.obtenerUsuarios();
    } catch (e) {
      _error = 'No se pudieron cargar los usuarios: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
