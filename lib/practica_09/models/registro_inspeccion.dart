class RegistroInspeccion {
  final String id;
  final DateTime fecha;
  final String rutaImagen;

  final double acelerometroX;
  final double acelerometroY;
  final double acelerometroZ;

  final double giroscopioX;
  final double giroscopioY;
  final double giroscopioZ;

  RegistroInspeccion({
    required this.id,
    required this.fecha,
    required this.rutaImagen,
    required this.acelerometroX,
    required this.acelerometroY,
    required this.acelerometroZ,
    required this.giroscopioX,
    required this.giroscopioY,
    required this.giroscopioZ,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'rutaImagen': rutaImagen,
      'acelerometroX': acelerometroX,
      'acelerometroY': acelerometroY,
      'acelerometroZ': acelerometroZ,
      'giroscopioX': giroscopioX,
      'giroscopioY': giroscopioY,
      'giroscopioZ': giroscopioZ,
    };
  }

  factory RegistroInspeccion.fromJson(Map<String, dynamic> json) {
    return RegistroInspeccion(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      rutaImagen: json['rutaImagen'],
      acelerometroX: (json['acelerometroX'] as num).toDouble(),
      acelerometroY: (json['acelerometroY'] as num).toDouble(),
      acelerometroZ: (json['acelerometroZ'] as num).toDouble(),
      giroscopioX: (json['giroscopioX'] as num).toDouble(),
      giroscopioY: (json['giroscopioY'] as num).toDouble(),
      giroscopioZ: (json['giroscopioZ'] as num).toDouble(),
    );
  }
}