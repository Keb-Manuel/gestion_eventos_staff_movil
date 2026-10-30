class Publicacion {
  final int userId;
  final int id;
  final String titulo;
  final String contenido;

  Publicacion({
    required this.userId,
    required this.id,
    required this.titulo,
    required this.contenido,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      userId: json['userId'],
      id: json['id'],
      titulo: json['title'],
      contenido: json['body'],
    );
  }
}
