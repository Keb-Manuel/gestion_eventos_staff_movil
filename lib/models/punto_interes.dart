
class PuntoInteres {
  final String nombre;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String imagenUrl;

  const PuntoInteres({
    required this.nombre,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    this.imagenUrl = '',
  });
}
