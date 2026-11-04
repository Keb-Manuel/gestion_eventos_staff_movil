import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;
  final PostService service;
  const PostFormScreen({super.key, this.post, required this.service});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.post?.title ?? '');
    _body = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    final esNuevo = widget.post == null;
    if (esNuevo) {
      await widget.service.crear(
        userId: 1,
        title: _title.text.trim(),
        body: _body.text.trim(),
      );
    } else {
      await widget.service.actualizar(widget.post!.copyWith(
        title: _title.text.trim(),
        body: _body.text.trim(),
      ));
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              widget.post == null ? 'Nueva publicación' : 'Editar publicación'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _body,
                decoration: const InputDecoration(labelText: 'Contenido'),
                minLines: 4,
                maxLines: 8,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      );
}
