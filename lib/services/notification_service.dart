import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings: settings);
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> bookSaved(String title) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'biblioteca_guardados',
        'Libros guardados',
        channelDescription: 'Avisos cuando agregas libros a tu biblioteca',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Biblioteca Personal',
      body: 'Se guardó "$title" en tu biblioteca.',
      notificationDetails: details,
    );
  }
}
