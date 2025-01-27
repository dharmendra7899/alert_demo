import 'dart:async';
import 'package:alert_demo/custom%20notification.dart';
import 'package:alert_demo/custom_app_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController studentController = TextEditingController();
  final TextEditingController studentController1 = TextEditingController();
  late Timer _timer;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;
  int studentCount = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    startBackgroundTask();
    _startTimer();
  }

  @override
  void dispose() {
    studentController.dispose();
    studentController1.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startBackgroundTask() {
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      "simplePeriodicTask",
      frequency: Duration(seconds: 10),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      final sharedPreference = await SharedPreferences.getInstance();
      bool isDataSaved = sharedPreference.getBool("isDataSaved") ?? false;
      if (!isDataSaved) {
        NotificationService.showNotificationWithRepeat(
          'Alert Reminder',
          'Please add total number of students for the midday meal',
          "Notification"
        );
      }
    });
  }

  void setStudents() async {
    setState(() {
      isLoading = true;
    });
    String students = studentController.text.trim();
    String students1 = studentController1.text.trim();
    if (students.isEmpty) {
      showSnackBar("Please enter a student number");
      return;
    }

    try {
      await fireStore
          .collection('students')
          .add({'student_num': students, "confirm_students": students1});
      final sharedPreference = await SharedPreferences.getInstance();
      sharedPreference.setBool("isDataSaved", true);

      studentController.clear();
      studentController1.clear();
      Navigator.pushReplacementNamed(context, '/student');
      Workmanager().registerPeriodicTask(
        "periodic-task-identifier",
        "reset",
        frequency: Duration(hours: 12),
      );
      showSnackBar("Student Added Successfully!");
    } catch (e) {
      showSnackBar("An error occurred: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      "मध्याह्न भोजन प्राधिकरण \nउत्तर प्रदेश",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.1,
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        "आज का दिनांक:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        DateFormat('d MMM yyyy hh:mm a').format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        "विद्यालय का नाम:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'प्राथमिक विद्यालय भदेसरमऊ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        "जिला:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'लखनऊ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        "ब्लॉक:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'मलिहाबाद',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "प्राथमिक विद्यालय के छात्रों की संख्या जिन्होंने आज भोजन किया:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: studentController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(height: 1),
                    decoration: InputDecoration(
                      hintText: "छात्रों की संख्या",
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      isCollapsed: true,
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "माध्यमिक विद्यालय के छात्रों की संख्या जिन्होंने आज भोजन किया:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: studentController1,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(height: 1),
                    decoration: InputDecoration(
                      hintText: "छात्रों की संख्या",
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      isCollapsed: true,
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff04b3fb),
                            Color(0xffe6e6fb),
                          ],
                          begin: AlignmentDirectional.centerStart,
                          end: AlignmentDirectional.centerEnd),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState == null ||
                            formKey.currentState!.validate()) {
                          setStudents();
                        }
                      },
                      style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      child: Center(
                          child: isLoading == true
                              ? CircularProgressIndicator.adaptive()
                              : Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
