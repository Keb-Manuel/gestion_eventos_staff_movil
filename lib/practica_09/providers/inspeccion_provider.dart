import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_inspeccion.dart';
import '../services/sensores_service.dart';

class InspeccionProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final SensoresService _sensoresService = SensoresService();

  final List<RegistroInspeccion> _registros = [];

  List<RegistroInspeccion> get registros =>
      List.unmodifiable(_registros);

  bool cargando = false;
  String? error;

  double get acelerometroX => _sensoresService.acelerometroX;
  double get acelerometroY => _sensoresService.acelerometroY;
  double get acelerometroZ => _sensoresService.acelerometroZ;

  double get giroscopioX => _sensoresService.giroscopioX;
  double get giroscopioY => _sensoresService.giroscopioY;
  double get giroscopioZ => _sensoresService.giroscopioZ;

  static const String _claveRegistros = 'bitacora_inspecciones_p9';

  InspeccionProvider() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    await cargarRegistros();

    _sensoresService.iniciarLectura(
      alActualizar: () {
        notifyListeners();
      },
    );
  }

  Future<void> cargarRegistros() async {
    try {
      final preferencias = await SharedPreferences.getInstance();
      final datos = preferencias.getString(_claveRegistros);

      if (datos == null) return;

      final List<dynamic> lista = jsonDecode(datos);

      _registros
        ..clear()
        ..addAll(
          lista.map(
            (elemento) => RegistroInspeccion.fromJson(
              Map<String, dynamic>.from(elemento),
            ),
          ),
        );

      notifyListeners();
    } catch (e) {
      error = 'No se pudieron cargar los registros: $e';
      notifyListeners();
    }
  }

  Future<void> tomarFotografia() async {
    if (cargando) return;

    cargando = true;
    error = null;
    notifyListeners();

    try {
      final XFile? fotografia = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      // Si el usuario cancela la cámara, no se crea ningún registro.
      if (fotografia == null) return;

      final directorio = await getApplicationDocumentsDirectory();

      final carpetaFotos = Directory(
        '${directorio.path}/fotografias_inspeccion',
      );

      if (!await carpetaFotos.exists()) {
        await carpetaFotos.create(recursive: true);
      }

      final id = DateTime.now().microsecondsSinceEpoch.toString();

      final archivo = await File(fotografia.path).copy(
        '${carpetaFotos.path}/inspeccion_$id.jpg',
      );

      final registro = RegistroInspeccion(
        id: id,
        fecha: DateTime.now(),
        rutaImagen: archivo.path,
        acelerometroX: acelerometroX,
        acelerometroY: acelerometroY,
        acelerometroZ: acelerometroZ,
        giroscopioX: giroscopioX,
        giroscopioY: giroscopioY,
        giroscopioZ: giroscopioZ,
      );

      _registros.insert(0, registro);

      await _guardarRegistros();
    } catch (e) {
      error = 'No se pudo guardar la fotografía: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> _guardarRegistros() async {
    final preferencias = await SharedPreferences.getInstance();

    final datos = jsonEncode(
      _registros.map((registro) => registro.toJson()).toList(),
    );

    await preferencias.setString(_claveRegistros, datos);
  }

  Future<void> eliminarRegistro(RegistroInspeccion registro) async {
    _registros.removeWhere((elemento) => elemento.id == registro.id);

    try {
      final archivo = File(registro.rutaImagen);

      if (await archivo.exists()) {
        await archivo.delete();
      }

      await _guardarRegistros();
      notifyListeners();
    } catch (e) {
      error = 'No se pudo eliminar el registro: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sensoresService.detenerLectura();
    super.dispose();
  }
}