import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    
    // Solicitar permissões para Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> showTrackFinishedNotification(String trackName) async {
    const androidDetails = AndroidNotificationDetails(
      'music_channel',
      'Music Notifications',
      importance: Importance.low,
      priority: Priority.low,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'Música Finalizada',
      '$trackName terminou de tocar',
      notificationDetails,
    );
  }

  static Future<void> schedulePlaylistReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Music Reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      'Hora da Música!',
      'Que tal ouvir suas playlists favoritas?',
      notificationDetails,
    );
  }

  static Future<void> showNewMusicNotification(String artistName, String trackName) async {
    const androidDetails = AndroidNotificationDetails(
      'new_music_channel',
      'New Music',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      2,
      'Nova Música Descoberta!',
      '$trackName por $artistName',
      notificationDetails,
    );
  }
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  Future<void> requestPermission() async {
    if (this == null) return;
    final granted = await this!.requestNotificationsPermission(
    );
  }
}
