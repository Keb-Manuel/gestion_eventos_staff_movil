import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../widgets/materia_card.dart';
import 'detalle_page.dart';

class InicioPage extends StatelessWidget {
  InicioPage({super.key});

  final List<Materia> materias = [
    Materia(
      nombre: 'Programación',
      semestre: 1,
      creditos: 6,
      descripcion: 'Introducción a la programación y desarrollo de algoritmos.',
    ),
    Materia(
      nombre: 'Bases de Datos',
      semestre: 2,
      creditos: 6,
      descripcion:
          'Fundamentos para diseñar, administrar y consultar bases de datos.',
    ),
    Materia(
      nombre: 'Redes de Computadoras',
      semestre: 3,
      creditos: 5,
      descripcion: 'Conceptos y funcionamiento de las redes de computadoras.',
    ),
    Materia(
      nombre: 'Ingeniería de Software',
      semestre: 4,
      creditos: 6,
      descripcion: 'Metodologías y procesos para el desarrollo de software.',
    ),
    Materia(
      nombre: 'Desarrollo Web',
      semestre: 5,
      creditos: 6,
      descripcion: 'Desarrollo de aplicaciones y sitios web.',
    ),
    Materia(
      nombre: 'Inteligencia Artificial',
      semestre: 6,
      creditos: 5,
      descripcion:
          'Conceptos básicos y aplicaciones de la inteligencia artificial.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Materias'),
      ),
      body: ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final materia = materias[index];

          return MateriaCard(
            materia: materia,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePage(
                    materia: materia,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
