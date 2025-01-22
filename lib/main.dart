import 'package:alert_demo/custom%20notification.dart';
import 'package:alert_demo/student_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await requestNotificationPermission();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final sharedPreference = await SharedPreferences.getInstance();
    if (task == 'reset') {
      sharedPreference.clear();
    }
    bool isDataSaved = sharedPreference.getBool("isDataSaved") ?? false;
    if (!isDataSaved) {
      NotificationService.showNotification(
        'Alert Reminder',
        'Please add total number of students for the midday meal',
        'Notification payload',
      );
    }
    return Future.value(true);
  });
}

void startBackgroundTask() {
  Workmanager().registerPeriodicTask(
    "periodic-task-identifier",
    "simplePeriodicTask",
    frequency: Duration(seconds: 30),
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => StudentPage(),
        '/home': (context) => StudentPage(),
      },
    );
  }
}
