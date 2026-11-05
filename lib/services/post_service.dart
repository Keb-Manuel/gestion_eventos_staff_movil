import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  PostService({http.Client? client}) : _client = client ?? http.Client();

  // Obtiene las publicaciones desde la API.
  Future<List<Post>> getPosts() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 15));

      // Validar el código de respuesta HTTP.
      if (response.statusCode != 200) {
        throw Exception(
          'Error del servidor. Código HTTP: ${response.statusCode}',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);

      final posts = data
          .map(
            (json) => Post.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      return posts.take(20).toList();
    } on http.ClientException {
      throw Exception('No se pudo conectar con el servidor.');
    } on FormatException {
      throw Exception('La respuesta del servidor no es un JSON válido.');
    } on Exception {
      rethrow;
    }
  }
}
