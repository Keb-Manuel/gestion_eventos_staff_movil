import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  Future<List<Usuario>> obtenerUsuarios() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP: ${respuesta.statusCode}');
    }

    final List datos = jsonDecode(respuesta.body);

    return datos.map((json) => Usuario.fromJson(json)).toList();
  }
}
