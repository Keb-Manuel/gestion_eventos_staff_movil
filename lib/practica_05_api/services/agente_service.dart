import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/agente.dart';

class AgenteService {
  final String url =
      'https://valorant-api.com/v1/agents?isPlayableCharacter=true';

  Future<List<Agente>> obtenerAgentes() async {
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final List<dynamic> agentesJson = datos['data'];

      return agentesJson
          .map((agente) => Agente.fromJson(agente))
          .toList();
    } else {
      throw Exception('Error al obtener los agentes de VALORANT');
    }
  }
}