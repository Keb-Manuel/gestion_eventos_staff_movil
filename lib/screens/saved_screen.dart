import 'package:flutter/material.dart';
import '../data/book_database.dart';
import '../models/book.dart';

class SavedScreen extends StatelessWidget {
  final int refresh;
  final ValueChanged<Book> onBookTap;
  const SavedScreen(
      {super.key, required this.refresh, required this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      key: ValueKey(refresh),
      future: BookDatabase.instance.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text('Ocurrió un error al leer los libros.'));
        }
        final books = snapshot.data ?? [];
        return CustomScrollView(slivers: [
          const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 26, 20, 12),
              sliver: SliverToBoxAdapter(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Mi biblioteca',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Tu colección permanece disponible sin conexión.'),
                  ]))),
          if (books.isEmpty)
            const SliverFillRemaining(
                child: Center(child: Text('Todavía no has guardado libros.')))
          else
            SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.book)),
                      title: Text(books[index].title),
                      subtitle: Text(books[index].author),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => onBookTap(books[index]),
                    ),
                  ),
                )),
        ]);
      },
    );
  }
}
