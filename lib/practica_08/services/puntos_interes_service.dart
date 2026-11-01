import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/punto_interes.dart';

class PuntosInteresService {
  static const String _clavePuntos = 'puntos_interes';

  Future<List<PuntoInteres>> obtenerPuntos() async {
    final preferencias = await SharedPreferences.getInstance();
    final datos = preferencias.getString(_clavePuntos);

    if (datos == null) return [];

    final lista = jsonDecode(datos) as List;

    return lista
        .map(
          (elemento) => PuntoInteres.fromMap(
            Map<String, dynamic>.from(elemento as Map),
          ),
        )
        .toList();
  }

  Future<void> guardarPuntos(List<PuntoInteres> puntos) async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = puntos.map((punto) => punto.toMap()).toList();

    await preferencias.setString(
      _clavePuntos,
      jsonEncode(datos),
    );
  }
}
