import 'package:alert_demo/custom%20notification.dart';
import 'package:alert_demo/student_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await requestNotificationPermission();
  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isGranted) {
    debugPrint("Notification permission already granted.");
  } else {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      debugPrint("Notification permission granted.");
    } else {
      openAppSettings();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: StudentPage(),
    );
  }
}
