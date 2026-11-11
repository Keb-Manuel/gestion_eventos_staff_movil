import 'package:image_picker/image_picker.dart';

class EvidenciaInspeccion {
  final XFile fotografia;
  final DateTime fechaHora;

  final double acelerometroX;
  final double acelerometroY;
  final double acelerometroZ;

  final double giroscopioX;
  final double giroscopioY;
  final double giroscopioZ;

  const EvidenciaInspeccion({
    required this.fotografia,
    required this.fechaHora,
    required this.acelerometroX,
    required this.acelerometroY,
    required this.acelerometroZ,
    required this.giroscopioX,
    required this.giroscopioY,
    required this.giroscopioZ,
  });
}
