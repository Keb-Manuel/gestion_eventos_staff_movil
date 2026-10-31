import '../../database/db.dart';
import '../models/nota.dart';

class NotasService {
  Future<List<Nota>> listar() async {
    final resultados = await DB.listar();

    return resultados.map((map) => Nota.fromMap(map)).toList();
  }

  Future<int> insertar(Nota nota) async {
    return DB.insertar(
      nota.titulo,
      nota.contenido,
    );
  }

  Future<int> actualizar(Nota nota) async {
    return DB.actualizar(
      nota.id!,
      nota.titulo,
      nota.contenido,
    );
  }

  Future<int> eliminar(int id) async {
    return DB.eliminar(id);
  }
}