import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gestion_eventos_staff_movil/database/db.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async => DB.reiniciarParaTests());
  tearDown(() async => DB.reiniciarParaTests());

  test('insertar y listar', () async {
    final id = await DB.insertarTarea(titulo: 'Comprar', descripcion: 'Leche');
    final tareas = await DB.listarTareas();
    expect(tareas, hasLength(1));
    expect(tareas.first['id'], id);
    expect(tareas.first['titulo'], 'Comprar');
    expect(tareas.first['completada'], 0);
  });

  test('toggle completada', () async {
    final id = await DB.insertarTarea(titulo: 'X', descripcion: '');
    await DB.toggleCompletada(id, true);
    expect(await DB.listarTareas(soloCompletadas: true), hasLength(1));
  });

  test('filtro pendientes', () async {
    await DB.insertarTarea(titulo: 'A', descripcion: '');
    final id2 = await DB.insertarTarea(titulo: 'B', descripcion: '');
    await DB.toggleCompletada(id2, true);

    final pendientes = await DB.listarTareas(soloCompletadas: false);
    expect(pendientes, hasLength(1));
    expect(pendientes.first['titulo'], 'A');
  });

  test('actualizar y eliminar', () async {
    final id = await DB.insertarTarea(titulo: 'Viejo', descripcion: 'X');
    await DB.actualizarTarea(id, titulo: 'Nuevo', descripcion: 'Y', completada: true);
    final t = await DB.listarTareas();
    expect(t.first['titulo'], 'Nuevo');
    expect(t.first['completada'], 1);

    await DB.eliminarTarea(id);
    expect(await DB.listarTareas(), isEmpty);
  });

  test('persistencia tras cerrar', () async {
    await DB.insertarTarea(titulo: 'Persistente', descripcion: 'Sigo aquí');
    await DB.cerrarParaTests();
    expect(await DB.listarTareas(), hasLength(1));
  });
}