import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showFavoriteNotification(String pokemonName) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('favorites', 'Favoritos', importance: Importance.high),
    );
    await _notificationsPlugin.show(0, 'Pokédex', '¡$pokemonName ahora es tu favorito!', notificationDetails);
  }
}