class Incidencia {
  final int? id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? foto;
  final double? latitud;
  final double? longitud;
  final DateTime fecha;

  Incidencia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.foto,
    this.latitud,
    this.longitud,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'foto': foto,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Incidencia.fromMap(Map<String, dynamic> map) {
    return Incidencia(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      categoria: map['categoria'] as String,
      foto: map['foto'] as String?,
      latitud: map['latitud'] as double?,
      longitud: map['longitud'] as double?,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }
}