import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentSubmitScreen extends StatefulWidget {
  const StudentSubmitScreen({super.key});

  @override
  State<StudentSubmitScreen> createState() => _StudentSubmitScreenState();
}

class _StudentSubmitScreenState extends State<StudentSubmitScreen> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStudentCount();
    });
  }

  int studentCount = 0;
  int studentNumCount = 0;
  int confirmStudentsCount = 0;

  void fetchStudentCount() async {
    try {
      var snapshot = await fireStore.collection('students').get();
      int tempStudentNumCount = 0;
      int tempConfirmStudentsCount = 0;

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data['student_num'] != null &&
            data['student_num'].toString().isNotEmpty) {
          tempStudentNumCount++;
        }
        if (data['confirm_students'] != null &&
            data['confirm_students'].toString().isNotEmpty) {
          tempConfirmStudentsCount++;
        }
      }

      setState(() {
        studentNumCount = tempStudentNumCount;
        confirmStudentsCount = tempConfirmStudentsCount;
        studentCount = studentNumCount + confirmStudentsCount;
      });

      debugPrint("Total Students: $studentCount");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to fetch student count: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              Center(
                  child: Image.asset(
                "assets/images/logo.png",
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              )),
              SizedBox(height: 12),
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
              SizedBox(height: 50),
              Center(
                child: Text(
                  "आज का डेटा सबमिट करने के लिए धन्यवाद।\nआपका डेटा सफलतापूर्वक सबमिट हो गया है।",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.1,
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        SizedBox(width: 8),
                        Text(
                          DateFormat('d MMM yyyy hh:mm a')
                              .format(DateTime.now()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
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
                        SizedBox(width: 8),
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
                    SizedBox(height: 12),
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
                        SizedBox(width: 8),
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
                    SizedBox(height: 12),
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
                        SizedBox(width: 8),
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
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "प्राथमिक विद्यालय के छात्रों की संख्या जिन्होंने आज भोजन किया :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$studentNumCount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "माध्यमिक विद्यालय के छात्रों की संख्या जिन्होंने आज भोजन किया :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$confirmStudentsCount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
