class PuntoInteres {
  final String nombre;
  final double latitud;
  final double longitud;

  const PuntoInteres({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  factory PuntoInteres.fromMap(Map<String, dynamic> map) {
    return PuntoInteres(
      nombre: map['nombre'] as String,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
    );
  }
}
