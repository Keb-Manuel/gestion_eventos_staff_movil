import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// ⚠️ Cambia "gestion_eventos_staff_movil" por el `name:` real de tu pubspec.yaml
import 'package:gestion_eventos_staff_movil/screens/posts_screen.dart';
import 'package:gestion_eventos_staff_movil/services/post_service.dart';

void main() {
  testWidgets('PostsScreen muestra el título y el spinner inicial',
      (tester) async {
    // Cliente falso: NO pega a la red real.
    // Resuelve en el siguiente microtask → no deja Timer pendiente.
    final mock = MockClient((request) async {
      return http.Response(
        jsonEncode(<Map<String, dynamic>>[]), // lista vacía
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PostsScreen(service: PostService(client: mock)),
      ),
    );

    // 1. Título de la AppBar
    expect(find.text('Publicaciones REST'), findsOneWidget);

    // 2. Estado inicial del FutureBuilder
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 3. Tras asentarse → lista vacía (no hay spinner)
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      find.text('No hay publicaciones disponibles'),
      findsOneWidget,
    );
  });
}
