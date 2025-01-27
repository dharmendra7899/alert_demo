import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/notification_icon');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> showNotificationWithRepeat(
      String title, String body, String payload) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'Mid day Meal',
      channelDescription: 'This is your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      ongoing: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    Future.delayed(Duration(seconds: 5), () async {
      await showNotificationWithRepeat(title, body, payload);
    });
  }

  static Future<void> _onNotificationTapped(
      NotificationResponse notificationResponse) async {
    final String? actionId = notificationResponse.actionId;
    final String? payload = notificationResponse.payload;
    if (actionId == 'submit' || actionId == 'cancel' || actionId == null) {
      navigatorKey.currentState?.pushReplacementNamed('/home');
    }
  }

  /// Show an in-app dialog notification
  static void _showInAppDialog(String title, String body, String? payload) {
    final TextEditingController studentController = TextEditingController();

    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          content: TextField(
            controller: studentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter student number"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String studentNumber = studentController.text;
                if (studentNumber.isNotEmpty) {
                  debugPrint("Student Number: $studentNumber");
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a student number")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
