import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<dynamic> publicaciones = [];
  bool cargando = false;
  String? error;

  Future<void> consultarAPI() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final respuesta = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        setState(() {
          publicaciones = datos;
        });
      } else {
        throw Exception('Error HTTP: ${respuesta.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = 'No se pudo conectar con el servidor: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta API REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton.icon(
              onPressed: cargando ? null : consultarAPI,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Consultar API'),
            ),
          ),
          if (cargando) const CircularProgressIndicator(),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: publicaciones.length,
              itemBuilder: (context, index) {
                final publicacion = publicaciones[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(publicacion['title']),
                    subtitle: Text(publicacion['body']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
