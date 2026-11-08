import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiIncidenciasService {
  static const String _url =
      'https://jsonplaceholder.typicode.com/posts';

  Future<List<Map<String, dynamic>>> obtenerIncidencias() async {
    final respuesta = await http
        .get(Uri.parse('$_url?_limit=15'))
        .timeout(const Duration(seconds: 15));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);

      return datos
          .map((elemento) => elemento as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception(
        'Error al consultar la API: ${respuesta.statusCode}',
      );
    }
  }
}