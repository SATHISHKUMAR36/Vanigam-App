import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    // Request notification permission (Only for Android 13+)
    if (await Permission.notification.request().isGranted) {
      print(" Notification permission granted");
    } else {
      print("Notification permission denied");
      return;
    }

    //  if (await Permission.storage.request().isGranted) {
    //   print("✅ storage permission granted");
    // } else {
    //   print("❌ storage permission denied");
    //   return;
    // }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          openFile(response.payload!);
        }
      },
    );
  }

  static Future<void> showNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Download Complete',
      'Tap to open the file',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  static Future<void> openFile(String filePath) async {
    try {
      await OpenFilex.open(filePath);
    } catch (e) {
      print("⚠️ Error opening file: $e");
    }
  }
}
