import 'package:flutter/foundation.dart';

import '../models/producto.dart';
import '../services/inventario_database.dart';
import '../services/notificacion_service.dart';
import '../services/producto_api_service.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioDatabase _database = InventarioDatabase.instance;
  final ProductoApiService _apiService = ProductoApiService();

  List<Producto> _productos = [];

  bool _cargando = false;
  String? _error;
  bool _inicializado = false;

  List<Producto> get productos => _productos;

  bool get cargando => _cargando;

  String? get error => _error;

  int get totalProductos => _productos.length;

  int get totalUnidades =>
      _productos.fold(0, (total, producto) => total + producto.stock);

  int get productosStockBajo =>
      _productos.where((producto) => producto.stockBajo).length;

  Future<void> inicializar() async {
    if (_inicializado) return;

    await cargarProductos();
    _inicializado = true;
  }

  Future<void> cargarProductos() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await _database.obtenerProductos();
    } catch (e) {
      _error = 'Error al cargar el inventario: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  
Future<bool> guardarProducto(Producto producto) async {
  try {
    if (producto.id == null) {
      await _database.insertarProducto(producto);
    } else {
      await _database.actualizarProducto(producto);
    }

    await cargarProductos();

    if (producto.stockBajo) {
      try {
        await NotificacionService.mostrarNotificacion(
          titulo: 'Stock bajo',
          cuerpo:
              '${producto.nombre} tiene ${producto.stock} unidades disponibles.',
          id: producto.id ?? DateTime.now().millisecondsSinceEpoch,
        );
      } catch (e) {
        debugPrint('No se pudo mostrar la notificación: $e');
      }
    }

    return true;
  } catch (e) {
    _error = 'No se pudo guardar el producto: $e';
    notifyListeners();
    return false;
  }
}


  Future<bool> eliminarProducto(int id) async {
    try {
      await _database.eliminarProducto(id);
      await cargarProductos();
      return true;
    } catch (e) {
      _error = 'No se pudo eliminar el producto: $e';
      notifyListeners();
      return false;
    }
  }

  Future<int> importarProductosApi() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    int importados = 0;

    try {
      final productosApi = await _apiService.obtenerProductos();

      for (final producto in productosApi) {
        final apiId = producto.apiId;

        if (apiId == null) continue;

        final existe = await _database.existeProductoApi(apiId);

        if (!existe) {
          await _database.insertarProducto(producto);
          importados++;
        }
      }

      _productos = await _database.obtenerProductos();
      return importados;
    } catch (e) {
      _error = 'Error al importar productos: $e';
      return 0;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}