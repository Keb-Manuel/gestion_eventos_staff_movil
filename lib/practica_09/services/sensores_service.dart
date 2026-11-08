import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class SensoresService {
  StreamSubscription<AccelerometerEvent>? _acelerometroSubscription;
  StreamSubscription<GyroscopeEvent>? _giroscopioSubscription;

  double acelerometroX = 0;
  double acelerometroY = 0;
  double acelerometroZ = 0;

  double giroscopioX = 0;
  double giroscopioY = 0;
  double giroscopioZ = 0;

  void iniciarLectura({
    required Function() alActualizar,
  }) {
    _acelerometroSubscription =
        accelerometerEventStream().listen(
      (evento) {
        acelerometroX = evento.x;
        acelerometroY = evento.y;
        acelerometroZ = evento.z;

        alActualizar();
      },
    );

    _giroscopioSubscription =
        gyroscopeEventStream().listen(
      (evento) {
        giroscopioX = evento.x;
        giroscopioY = evento.y;
        giroscopioZ = evento.z;

        alActualizar();
      },
    );
  }

  void detenerLectura() {
    _acelerometroSubscription?.cancel();
    _giroscopioSubscription?.cancel();

    _acelerometroSubscription = null;
    _giroscopioSubscription = null;
  }
}