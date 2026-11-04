import 'dart:convert';
import 'package:http/http.dart' as http;

import '../database/db.dart';
import '../models/post.dart';
import 'preferences_service.dart';

class ResultadoCarga {
  final List<Post> posts;
  final bool offline;
  final String? error;
  const ResultadoCarga(
      {required this.posts, required this.offline, this.error});
}

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;
  final PreferencesService _prefs;

  PostService({http.Client? client, PreferencesService? prefs})
      : _client = client ?? http.Client(),
        _prefs = prefs ?? PreferencesService();

  Future<ResultadoCarga> obtenerPosts() async {
    try {
      final r = await _client
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 15));

      if (r.statusCode != 200) {
        throw Exception('Error del servidor. Código HTTP: ${r.statusCode}');
      }

      final List<dynamic> data = jsonDecode(r.body);
      for (final j in data.take(20)) {
        final p = Post.fromJson(j as Map<String, dynamic>);
        await DB.upsertRemoto(
          remoteId: p.remoteId!,
          userId: p.userId,
          title: p.title,
          body: p.body,
        );
      }
      await _prefs.guardarUltimaSync(DateTime.now());

      final filas = await DB.listar();
      return ResultadoCarga(
        posts: filas.map(Post.fromRow).toList(),
        offline: false,
      );
    } on Exception catch (e) {
      final filas = await DB.listar();
      return ResultadoCarga(
        posts: filas.map(Post.fromRow).toList(),
        offline: true,
        error: e.toString(),
      );
    }
  }

  Future<void> crear({
    required int userId,
    required String title,
    required String body,
  }) =>
      DB.insertarLocal(userId: userId, title: title, body: body);

  Future<void> actualizar(Post p) => DB.actualizarLocal(
        p.id,
        userId: p.userId,
        title: p.title,
        body: p.body,
      );

  Future<void> eliminar(int id) => DB.eliminar(id);

  Future<void> marcarSincronizado() => DB.marcarTodosSincronizados();

  Future<int> pendientes() => DB.contarPendientes();
}
