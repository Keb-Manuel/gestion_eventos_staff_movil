class Actividad {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime fecha;

  const Actividad({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
