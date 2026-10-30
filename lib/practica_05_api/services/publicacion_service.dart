import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/publicacion.dart';

class PublicacionService {
  final String url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Publicacion>> obtenerPublicaciones() async {
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);

      return datos.take(20).map((json) => Publicacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las publicaciones');
    }
  }
}
