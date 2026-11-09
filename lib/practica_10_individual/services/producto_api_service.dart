import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/producto.dart';

class ProductoApiService {
  static const String _url = 'https://dummyjson.com/products?limit=20';

  Future<List<Producto>> obtenerProductos() async {
    try {
      final respuesta = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 15));

      if (respuesta.statusCode != 200) {
        throw Exception(
          'Error al consultar la API. Código: ${respuesta.statusCode}',
        );
      }

      final Map<String, dynamic> datos =
          jsonDecode(respuesta.body) as Map<String, dynamic>;

      final List<dynamic> productosJson =
          datos['products'] as List<dynamic>;

      return productosJson
          .map(
            (producto) => Producto.fromApi(
              producto as Map<String, dynamic>,
            ),
          )
          .toList();
    } on Exception catch (e) {
      throw Exception('No se pudieron obtener los productos: $e');
    }
  }
}