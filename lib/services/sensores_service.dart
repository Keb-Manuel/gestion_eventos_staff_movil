import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class SensoresService {
  double acelerometroX = 0;
  double acelerometroY = 0;
  double acelerometroZ = 0;

  double giroscopioX = 0;
  double giroscopioY = 0;
  double giroscopioZ = 0;

  StreamSubscription<AccelerometerEvent>? _acelerometroSub;
  StreamSubscription<GyroscopeEvent>? _giroscopioSub;

  void iniciar({
    required void Function() onActualizar,
  }) {
    _acelerometroSub = accelerometerEventStream().listen((evento) {
      acelerometroX = evento.x;
      acelerometroY = evento.y;
      acelerometroZ = evento.z;

      onActualizar();
    });

    _giroscopioSub = gyroscopeEventStream().listen((evento) {
      giroscopioX = evento.x;
      giroscopioY = evento.y;
      giroscopioZ = evento.z;

      onActualizar();
    });
  }

  void detener() {
    _acelerometroSub?.cancel();
    _giroscopioSub?.cancel();
  }
}
