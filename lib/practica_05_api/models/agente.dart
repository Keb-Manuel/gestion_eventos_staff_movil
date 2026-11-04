class Agente {
  final String uuid;
  final String nombre;
  final String descripcion;
  final String icono;
  final String rol;
  final List<Habilidad> habilidades;

  Agente({
    required this.uuid,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.rol,
    required this.habilidades,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      uuid: json['uuid'] ?? '',
      nombre: json['displayName'] ?? 'Desconocido',
      descripcion: json['description'] ?? '',
      icono: json['displayIcon'] ?? '',
      rol: json['role']?['displayName'] ?? 'Sin rol',
      habilidades: (json['abilities'] as List? ?? [])
          .map((habilidad) => Habilidad.fromJson(habilidad))
          .toList(),
    );
  }
}

class Habilidad {
  final String nombre;
  final String descripcion;
  final String icono;

  Habilidad({
    required this.nombre,
    required this.descripcion,
    required this.icono,
  });

  factory Habilidad.fromJson(Map<String, dynamic> json) {
    return Habilidad(
      nombre: json['displayName'] ?? '',
      descripcion: json['description'] ?? '',
      icono: json['displayIcon'] ?? '',
    );
  }
}