import '../models/actividad.dart';

class ActividadService {
  final List<Actividad> _actividades = [
    Actividad(
      id: 1,
      nombre: 'Conferencia de tecnología',
      descripcion: 'Introducción a las nuevas tecnologías.',
      fecha: DateTime(2026, 11, 15),
    ),
    Actividad(
      id: 2,
      nombre: 'Taller de programación',
      descripcion: 'Fundamentos de programación con Flutter.',
      fecha: DateTime(2026, 11, 16),
    ),
    Actividad(
      id: 3,
      nombre: 'Seminario de innovación',
      descripcion: 'Innovación y desarrollo tecnológico.',
      fecha: DateTime(2026, 11, 17),
    ),
  ];

  Future<List<Actividad>> obtenerActividades() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_actividades);
  }
}
