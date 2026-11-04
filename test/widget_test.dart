import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestion_eventos_staff_movil/models/post.dart';
import 'package:gestion_eventos_staff_movil/screens/posts_screen.dart';
import 'package:gestion_eventos_staff_movil/services/post_service.dart';

class FakePostService implements PostService {
  final ResultadoCarga resultado;
  FakePostService(this.resultado);

  @override
  Future<ResultadoCarga> obtenerPosts() async => resultado;

  @override
  Future<int> pendientes() async => 0;

  @override
  Future<void> crear({
    required int userId,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> actualizar(Post p) async {}

  @override
  Future<void> eliminar(int id) async {}

  @override
  Future<void> marcarSincronizado() async {}
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'nombre_usuario': 'Tester',
    });
  });

  testWidgets('PostsScreen muestra título, spinner y lista vacía',
      (tester) async {
    final fake = FakePostService(
      const ResultadoCarga(posts: [], offline: false),
    );

    await tester.pumpWidget(
      MaterialApp(home: PostsScreen(service: fake)),
    );

    expect(find.text('Publicaciones REST'), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No hay publicaciones'), findsOneWidget);

    expect(find.text('Bienvenido, Tester'), findsOneWidget);

    expect(find.byIcon(Icons.wifi_off), findsNothing);
  });
}
