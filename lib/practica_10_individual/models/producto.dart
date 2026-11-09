
class Producto {
  final int? id;
  final int? apiId;
  final String nombre;
  final String descripcion;
  final String categoria;
  final double precio;
  final int stock;
  final int stockMinimo;
  final String? imagen;
  final DateTime fechaRegistro;

  Producto({
    this.id,
    this.apiId,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.stockMinimo,
    this.imagen,
    required this.fechaRegistro,
  });

  bool get stockBajo => stock <= stockMinimo;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apiId': apiId,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'precio': precio,
      'stock': stock,
      'stockMinimo': stockMinimo,
      'imagen': imagen,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] as int?,
      apiId: map['apiId'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      precio: (map['precio'] as num).toDouble(),
      stock: map['stock'] as int,
      stockMinimo: map['stockMinimo'] as int,
      imagen: map['imagen'] as String?,
      fechaRegistro: DateTime.parse(
        map['fechaRegistro'] as String,
      ),
    );
  }

  factory Producto.fromApi(Map<String, dynamic> json) {
    return Producto(
      apiId: json['id'] as int,
      nombre: json['title'] as String? ?? 'Sin nombre',
      descripcion: json['description'] as String? ?? '',
      categoria: json['category'] as String? ?? 'General',
      precio: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      stockMinimo: 5,
      imagen: json['thumbnail'] as String?,
      fechaRegistro: DateTime.now(),
    );
  }
}
