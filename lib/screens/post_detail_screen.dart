import 'package:flutter/material.dart';

import '../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final idVisible = post.remoteId ?? post.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de publicación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue,
                child: Text(
                  '$idVisible',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (post.pendienteSincronizar) ...[
              const SizedBox(height: 12),
              Center(
                child: Chip(
                  avatar: const Icon(
                    Icons.cloud_upload,
                    size: 18,
                    color: Colors.orange,
                  ),
                  backgroundColor: Colors.orange.shade100,
                  label: const Text('Pendiente de sincronizar'),
                ),
              ),
            ],
            const SizedBox(height: 25),
            const Text(
              'Título',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Contenido',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 17,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 25),
            const Divider(),
            Text(
              'ID del usuario: ${post.userId}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              'ID de publicación: $idVisible',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            if (post.pendienteSincronizar)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Este post tiene cambios locales que aún no se envían al servidor.',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
