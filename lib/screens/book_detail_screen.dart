import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/book_database.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});
  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _saved = false;
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final value = await BookDatabase.instance.contains(widget.book.key);
    if (mounted) setState(() => _saved = value);
  }

  Future<void> _toggle() async {
    if (_saved) {
      await BookDatabase.instance.delete(widget.book.key);
    } else {
      await BookDatabase.instance.save(widget.book);
    }
    if (mounted) setState(() => _saved = !_saved);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del libro')),
      body: ListView(padding: const EdgeInsets.all(22), children: [
        if (book.coverUrl != null)
          Center(
              child: Image.network(book.coverUrl!,
                  height: 230,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.menu_book, size: 100)))
        else
          const Center(child: Icon(Icons.menu_book, size: 100)),
        const SizedBox(height: 22),
        Text(book.title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(book.author,
            style: const TextStyle(fontSize: 17, color: Colors.blueGrey)),
        if (book.year != null)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Año de publicación: ${book.year}')),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _toggle,
          icon: Icon(_saved ? Icons.bookmark_remove : Icons.bookmark_add),
          label: Text(
              _saved ? 'Quitar de mi biblioteca' : 'Guardar en mi biblioteca'),
        ),
        const SizedBox(height: 12),
        const Text(
            'Los libros guardados se almacenan localmente para que puedas consultarlos sin conexión.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueGrey)),
      ]),
    );
  }
}
