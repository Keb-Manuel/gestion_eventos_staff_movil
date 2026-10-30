class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada ? 1 : 0,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      completada: map['completada'] == 1,
    );
  }

  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    bool? completada,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
    );
  }
}
