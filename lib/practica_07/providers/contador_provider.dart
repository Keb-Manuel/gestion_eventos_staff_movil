import 'package:flutter/foundation.dart';

class ContadorProvider extends ChangeNotifier {
  int _contador = 0;

  int get contador => _contador;

  void incrementar() {
    _contador++;
    notifyListeners();
  }

  void decrementar() {
    _contador--;
    notifyListeners();
  }

  void reiniciar() {
    _contador = 0;
    notifyListeners();
  }
}
