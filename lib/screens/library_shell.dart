import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/book_database.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'add_book_screen.dart';
import 'book_detail_screen.dart';

class LibraryShell extends StatefulWidget {
  const LibraryShell({super.key});
  @override
  State<LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<LibraryShell> {
  int _index = 0;
  int _refresh = 0;

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => const AddBookScreen()));
    if (added == true && mounted) setState(() => _refresh++);
  }

  void _openDetail(Book book) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailScreen(book: book),
        )).then((_) {
      if (mounted) setState(() => _refresh++);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeScreen(
          onSearch: () => setState(() => _index = 1),
          onAdd: _openAdd,
          refresh: _refresh,
          onBookTap: _openDetail),
      SearchScreen(
          onBookTap: _openDetail, onSaved: () => setState(() => _refresh++)),
      SavedScreen(refresh: _refresh, onBookTap: _openDetail),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      floatingActionButton: _index == 2
          ? FloatingActionButton.extended(
              onPressed: _openAdd,
              icon: const Icon(Icons.add),
              label: const Text('Agregar libro'))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Mi biblioteca'),
        ],
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onAdd;
  final int refresh;
  final ValueChanged<Book> onBookTap;
  const _HomeScreen(
      {required this.onSearch,
      required this.onAdd,
      required this.refresh,
      required this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      key: ValueKey(refresh),
      future: BookDatabase.instance.getAll(),
      builder: (context, snapshot) {
        final books = snapshot.data ?? [];
        return CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BIBLIOTECA PERSONAL',
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF547084))),
                const SizedBox(height: 12),
                const Text(
                  'Tus libros,\nTu espacio.',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173B57),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Descubre lecturas y organiza tu colección.'),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                      child: FilledButton.icon(
                          onPressed: onSearch,
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar libros'))),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar')),
                ]),
                const SizedBox(height: 28),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tu colección',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('${books.length} libros',
                          style: const TextStyle(color: Colors.blueGrey)),
                    ]),
                const SizedBox(height: 12),
              ],
            )),
          ),
          if (snapshot.connectionState == ConnectionState.waiting)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (snapshot.hasError)
            const SliverFillRemaining(
                child: Center(child: Text('No se pudo cargar la biblioteca.')))
          else if (books.isEmpty)
            const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                    child: Text(
                        'Aún no tienes libros guardados.\nBusca un libro o agrega uno manualmente.',
                        textAlign: TextAlign.center)))
          else
            SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: const CircleAvatar(child: Icon(Icons.menu_book)),
                    title: Text(books[index].title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(books[index].author),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onBookTap(books[index]),
                  ),
                )),
        ]);
      },
    );
  }
}
