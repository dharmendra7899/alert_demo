import 'dart:async';
import 'package:alert_demo/custom%20notification.dart';
import 'package:alert_demo/custom_app_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController studentController = TextEditingController();
  late Timer _timer;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;
  int studentCount = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchStudentCount();
    // });
    startBackgroundTask();
    _startTimer();
  }

  @override
  void dispose() {
    studentController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void fetchStudentCount() async {
    try {
      var snapshot = await fireStore.collection('students').get();
      setState(() {
        studentCount = snapshot.docs.length;
      });
      debugPrint("834657865 $studentCount");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch student count")),
        );
      }
    }
  }

  void startBackgroundTask() {
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      "simplePeriodicTask",
      frequency: Duration(seconds: 30),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) async {
      final sharedPreference = await SharedPreferences.getInstance();
      bool isDataSaved = sharedPreference.getBool("isDataSaved") ?? false;
      if (!isDataSaved) {
        NotificationService.showNotification(
          'Alert Reminder',
          'Please add total number of students for the midday meal',
          'Notification payload',
        );
      }
    });
  }

  void setStudents() async {
    setState(() {
      isLoading = true;
    });
    String students = studentController.text.trim();
    if (students.isEmpty) {
      showSnackBar("Please enter a student number");
      return;
    }

    try {
      await fireStore.collection('students').add({'student_num': students});
      final sharedPreference = await SharedPreferences.getInstance();
      sharedPreference.setBool("isDataSaved", true);
      studentController.clear();
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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Student Midday Meal",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                AppTextField(
                  controller: studentController,
                  textCapitalization: TextCapitalization.none,
                  keyBoardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field is required";
                    }
                    return null;
                  },
                  maxLength: 10,
                  labelText: "Student Number",
                ),
                SizedBox(height: 30),
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
                    borderRadius: BorderRadius.circular(30),
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
                            borderRadius: BorderRadius.circular(30),
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
    );
  }
}
