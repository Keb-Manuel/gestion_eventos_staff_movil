import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const configuracion = InitializationSettings(
      android: android,
    );

    await plugin.initialize(settings: configuracion);

    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrar() async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_practica',
        'Práctica móvil',
        channelDescription: 'Alertas de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      id: 1,
      title: 'Reporte Móvil de Incidencias',
      body: 'Tu reporte se ha guardado correctamente.',
      notificationDetails: detalles,
    );
  }
}
