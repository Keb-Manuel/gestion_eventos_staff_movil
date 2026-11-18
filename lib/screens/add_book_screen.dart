import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book.dart';
import '../data/book_database.dart';
import '../services/notification_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});
  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _notes = TextEditingController();
  String? _photo;
  bool _saving = false;

  Future<void> _takePhoto() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 75);
      if (image != null && mounted) setState(() => _photo = image.path);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se pudo abrir la cámara. Revisa los permisos.')));
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final key = 'local-${DateTime.now().microsecondsSinceEpoch}';
      await BookDatabase.instance.save(Book(
        key: key,
        title: _title.text.trim(),
        author: _author.text.trim(),
        notes: _notes.text.trim(),
        photoPath: _photo,
        isLocal: true,
      ));
      await NotificationService.instance.bookSaved(_title.text.trim());
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se pudo guardar el libro. Inténtalo de nuevo.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar libro')),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('Registra un libro en tu colección.',
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 18),
          TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El título es obligatorio.'
                  : null),
          const SizedBox(height: 14),
          TextFormField(
              controller: _author,
              decoration: const InputDecoration(labelText: 'Autor'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'El autor es obligatorio.'
                  : null),
          const SizedBox(height: 14),
          TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Notas (opcional)', alignLabelWithHint: true)),
          const SizedBox(height: 18),
          OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Tomar fotografía de portada')),
          if (_photo != null)
            Padding(
                padding: const EdgeInsets.only(top: 12),
                child:
                    Text('Fotografía capturada: ${_photo!.split('/').last}')),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const CircularProgressIndicator()
                : const Text('Guardar libro'),
          ),
        ]),
      ),
    );
  }
}
