import 'dart:async';
import 'package:alert_demo/custom%20notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController studentController = TextEditingController();
  late Timer _timer;
  bool _isNumberEntered = false;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;
  int studentCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStudentCount();
      // _showAlertDialog();
    });
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
      print("834657865 $studentCount");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch student count")),
        );
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (!_isNumberEntered) {
        _showAlertDialog();
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
      studentController.clear();
      fetchStudentCount();
      showSnackBar("Student Added Successfully!");
      Navigator.of(context).pop();
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

  void _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Student Number",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          content: TextField(
            controller: studentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter number"),
          ),
          actions: [
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: setStudents,
                    style: ButtonStyle(
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.blueAccent,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )),
                    child: const Text("Submit", style: TextStyle(fontSize: 18)),
                  ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Student Number Input",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: GestureDetector(
        onTap: ()  {
           NotificationService.showNotification(
            'New Notification',
            'This is a custom notification!',
            'Notification payload',
          );
        },
        child: Center(
          child: Text(
            "Total Students : ${studentController.text}",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
