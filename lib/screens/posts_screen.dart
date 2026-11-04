import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import '../services/preferences_service.dart';
import 'post_detail_screen.dart';
import 'post_form_screen.dart';

class PostsScreen extends StatefulWidget {
  final PostService? service;
  const PostsScreen({super.key, this.service});
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final PostService _service;
  final _prefs = PreferencesService();

  late Future<ResultadoCarga> _futurePosts;
  String _nombre = 'Invitado';
  int _pendientes = 0;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? PostService();
    _futurePosts = _cargar();
    _prefs
        .leerNombre()
        .then((n) => mounted ? setState(() => _nombre = n) : null);
  }

  Future<ResultadoCarga> _cargar() async {
    final r = await _service.obtenerPosts();
    _pendientes = await _service.pendientes();
    return r;
  }

  Future<void> _refrescar() async {
    setState(() => _futurePosts = _cargar());
    await _futurePosts;
    setState(() {});
  }

  Future<void> _nuevaPublicacion() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PostFormScreen(service: _service),
      ),
    );
    if (ok == true) _refrescar();
  }

  Future<void> _editar(Post p) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PostFormScreen(service: _service, post: p),
      ),
    );
    if (ok == true) _refrescar();
  }

  Future<void> _eliminar(Post p) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: Text('¿Eliminar “${p.title}”? Esta acción es local.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar == true) {
      await _service.eliminar(p.id);
      _refrescar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones REST'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevaPublicacion,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
      body: FutureBuilder<ResultadoCarga>(
        future: _futurePosts,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final res = snap.data;
          final posts = res?.posts ?? const <Post>[];
          final offline = res?.offline ?? true;

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Bienvenido, $_nombre')),
                    if (_pendientes > 0)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.orange.shade100,
                        label: Text('$_pendientes pendiente(s)'),
                      ),
                  ],
                ),
              ),
              // 📴 Banner offline
              if (offline)
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(children: [
                    Icon(Icons.wifi_off, size: 18, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text('Sin conexión — mostrando datos locales.')),
                  ]),
                ),

              // 📃 Lista
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refrescar,
                  child: posts.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('No hay publicaciones')),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                          itemCount: posts.length,
                          itemBuilder: (_, i) {
                            final p = posts[i];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    '${p.remoteId ?? p.id}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(p.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    if (p.pendienteSincronizar)
                                      const Icon(Icons.cloud_upload,
                                          size: 16, color: Colors.orange),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(p.body,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (v) =>
                                      v == 'edit' ? _editar(p) : _eliminar(p),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'edit', child: Text('Editar')),
                                    PopupMenuItem(
                                        value: 'del', child: Text('Eliminar')),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PostDetailScreen(post: p),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
