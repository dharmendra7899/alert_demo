import 'package:alert_demo/custom%20notification.dart';
import 'package:alert_demo/splash_screen.dart';
import 'package:alert_demo/student_page.dart';
import 'package:alert_demo/student_submit_screen.dart';
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
      await NotificationService.showNotificationWithRepeat(
        'Alert Reminder',
        'Please add total number of students for the midday meal',"Notification",
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
      showDialog(
        context: NotificationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notification Permission Required"),
            content: Text(
                "To receive important updates, please enable notifications in the app settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}


Future<void> guideUserToEnableSoundAndVibration() async {
  debugPrint(
      "Please ensure sound and vibration are enabled in the device settings.");
  openAppSettings();
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
        '/': (context) => SplashScreen(),
        '/splash': (context) => SplashScreen(),
        '/home': (context) => StudentPage(),
        '/student': (context) => StudentSubmitScreen(),
      },
    );
  }
}
