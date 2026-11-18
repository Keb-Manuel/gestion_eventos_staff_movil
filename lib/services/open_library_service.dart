
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class OpenLibraryService {
  static const String _apiKey = 'AIzaSyBwzjrlK8WA0ZrflcbHEyh_4X2POC2HIrc';

  Future<List<Book>> search(String query) async {
    final uri = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {
        'q': query,
        'maxResults': '20',
        'key': _apiKey,
      },
    );

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.body}',
        );
      }

      final decoded =
          jsonDecode(response.body) as Map<String, dynamic>;

      final items = decoded['items'] as List? ?? [];

      return items
          .whereType<Map<String, dynamic>>()
          .map(Book.fromApi)
          .where((book) => book.key.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Error al consultar Google Books: $e');
    }
  }
}
