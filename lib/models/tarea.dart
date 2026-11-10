class Tarea {
  final int id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final DateTime fechaCreacion;

  const Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.completada,
    required this.fechaCreacion,
  });

  factory Tarea.fromRow(Map<String, dynamic> r) => Tarea(
        id: r['id'] as int,
        titulo: r['titulo'] as String,
        descripcion: r['descripcion'] as String,
        completada: (r['completada'] as int) == 1,
        fechaCreacion: DateTime.parse(r['fecha_creacion'] as String),
      );

  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    bool? completada,
    DateTime? fechaCreacion,
  }) =>
      Tarea(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion,
        completada: completada ?? this.completada,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );
}