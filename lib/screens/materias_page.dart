import 'package:flutter/material.dart';
import 'package:gestion_eventos_staff_movil/models/Materia.dart';
import '../widgets/materia_card.dart';
import 'detalle_materia_page.dart';

class MateriasPage extends StatelessWidget {
  const MateriasPage({super.key});

  static const List<Materia> materias = [
    Materia(
      nombre: 'Fundamentos de Programación',
      semestre: 1,
      creditos: 5,
      descripcion:
          'Materia introductoria al desarrollo de software. '
          'Se estudian algoritmos, variables, tipos de datos, '
          'estructuras de control y conceptos básicos de programación.',
    ),
    Materia(
      nombre: 'Programación Orientada a Objetos',
      semestre: 2,
      creditos: 5,
      descripcion:
          'Materia enfocada en el desarrollo de aplicaciones mediante '
          'programación orientada a objetos. Se estudian clases, objetos, '
          'encapsulamiento, herencia y polimorfismo.',
    ),
    Materia(
      nombre: 'Estructura de Datos',
      semestre: 3,
      creditos: 5,
      descripcion:
          'Estudio de estructuras de datos utilizadas para organizar y '
          'manipular información. Se incluyen listas, pilas, colas, '
          'árboles y algoritmos de búsqueda.',
    ),
    Materia(
      nombre: 'Fundamentos de Bases de Datos',
      semestre: 3,
      creditos: 5,
      descripcion:
          'Materia dedicada al diseño y administración de bases de datos. '
          'Se estudian modelos de datos, tablas, relaciones, consultas '
          'y lenguaje SQL.',
    ),
    Materia(
      nombre: 'Ingeniería de Software',
      semestre: 5,
      creditos: 5,
      descripcion:
          'Se estudian procesos, metodologías y herramientas utilizadas '
          'para analizar, diseñar, desarrollar, probar y mantener '
          'sistemas de software.',
    ),
    Materia(
      nombre: 'Desarrollo de Aplicaciones Móviles',
      semestre: 7,
      creditos: 5,
      descripcion:
          'Materia enfocada en el desarrollo de aplicaciones para '
          'dispositivos móviles. Se estudian interfaces, navegación, '
          'componentes reutilizables y manejo de datos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Materias'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Materias disponibles',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona una materia para consultar sus detalles.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          ...materias.map(
            (materia) {
              return MateriaCard(
                materia: materia,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DetalleMateriaPage(
                          materia: materia,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}