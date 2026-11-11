import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CamaraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> tomarFotografia() async {
    final permiso = await Permission.camera.request();

    if (permiso.isPermanentlyDenied) {
      throw Exception(
        'El permiso de cámara está bloqueado. '
        'Actívalo desde los ajustes del dispositivo.',
      );
    }

    if (!permiso.isGranted) {
      throw Exception('No se concedió el permiso de cámara.');
    }

    // Si el usuario cancela, devuelve null.
    return await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
  }
}
