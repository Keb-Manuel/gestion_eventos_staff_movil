class Producto {
  final String nombre;
  final String categoria;
  final double precio;
  final int existencia;

  Producto({
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.existencia,
  });

  double get valorInventario => precio * existencia;
}