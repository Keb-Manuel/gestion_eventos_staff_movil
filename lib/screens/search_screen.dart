import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/open_library_service.dart';
import '../data/book_database.dart';
import '../services/notification_service.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Book> onBookTap;
  final VoidCallback onSaved;
  const SearchScreen(
      {super.key, required this.onBookTap, required this.onSaved});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _api = OpenLibraryService();
  List<Book> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _search() async {
    if (_controller.text.trim().isEmpty) {
      setState(() => _error = 'Escribe el título o autor que deseas buscar.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _api.search(_controller.text.trim());
      if (mounted) setState(() => _results = results);
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            'No fue posible consultar la API. Revisa tu conexión e inténtalo de nuevo.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save(Book book) async {
    await BookDatabase.instance.save(book);
    await NotificationService.instance.bookSaved(book.title);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro guardado en tu biblioteca.')));
    widget.onSaved();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Explorar libros',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Busca en el catálogo de Open Library.'),
        const SizedBox(height: 18),
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          decoration: InputDecoration(
            hintText: 'Título o autor',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward), onPressed: _search),
          ),
        ),
        if (_error != null)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red))),
        const SizedBox(height: 12),
        if (_loading) const LinearProgressIndicator(),
        Expanded(
            child: _results.isEmpty && !_loading
                ? const Center(
                    child: Text('Los resultados aparecerán aquí.',
                        textAlign: TextAlign.center))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final book = _results[index];
                      return FutureBuilder<bool>(
                        future: BookDatabase.instance.contains(book.key),
                        builder: (context, saved) => Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: book.coverUrl == null
                                ? const SizedBox(
                                    width: 48,
                                    child: Icon(Icons.menu_book, size: 34))
                                : Image.network(book.coverUrl!,
                                    width: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.menu_book)),
                            title: Text(book.title,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                                '${book.author}${book.year == null ? '' : ' · ${book.year}'}'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BookDetailScreen(book: book))),
                            trailing: IconButton(
                              tooltip:
                                  saved.data == true ? 'Guardado' : 'Guardar',
                              icon: Icon(saved.data == true
                                  ? Icons.bookmark
                                  : Icons.bookmark_add_outlined),
                              onPressed:
                                  saved.data == true ? null : () => _save(book),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
      ]),
    );
  }
}
