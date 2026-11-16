class Reporte {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? fotografia;
  final double latitud;
  final double longitud;
  final String fecha;

  Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.fotografia,
    required this.latitud,
    required this.longitud,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'fotografia': fotografia,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha,
    };
  }

  factory Reporte.fromMap(Map<String, dynamic> map) {
    return Reporte(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      fotografia: map['fotografia'] as String?,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
      fecha: map['fecha'] as String,
    );
  }
}
