import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/utility/functons.dart';
import 'package:attendanceapp/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var dateController = TextEditingController();
  List<Map>? studentList;
  var attendanceSheet = [{}];
  var readonly = false;

  void getAttendanceSheet() async {
    studentList = await DBHelper.dbInstance.getStudents();
    print(studentList);
    dateController.text = DateFormat('dd/MM/yy').format(DateTime.now());
    attendanceSheet = studentList!
        .map((student) => {
              'roll_no': student['roll_no'],
              'name': student['name'],
              'surname': student['surname'],
              'attending_status': 'a'
            })
        .toList();
    print(attendanceSheet);
    setState(() {});
  }

  void getPreviousAttendance() async {
    attendanceSheet = await DBHelper.dbInstance
        .getStudentAttendence(date: dateController.text);
    if (attendanceSheet!.length > 0)
      readonly = true;
    else {
      readonly = false;
      getAttendanceSheet();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAttendanceSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Date :",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: MyAdjustableDateField(
                        controller: dateController,
                        hintText: "Choose Date",
                        current: true,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(attendanceSheet);
                        if (!readonly) {
                          var inserted = await DBHelper.dbInstance
                              .markStudentAttendence(
                                  attendance: attendanceSheet,
                                  date: dateController.text);
                          if (inserted) {
                            var data = await DBHelper.dbInstance
                                .getStudentAttendence(
                                    date: dateController.text);
                            print("data : $data");
                            readonly = true;
                            setState(() {});
                          }
                        } else {
                          getPreviousAttendance();
                          setState(() {});
                        }
                      },
                      child: Text(
                        !readonly ? "Save" : "View",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: !readonly
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ],
                )),
            Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  print(index);
                  var student = attendanceSheet[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  student['roll_no'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "${capitalize(student['name'])} ${capitalize(student['surname'])}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!readonly) {
                                  student['attending_status'] =
                                      student['attending_status'] != 'p'
                                          ? 'p'
                                          : 'a';
                                  setState(() {});
                                }
                              },
                              child: Text(
                                student['attending_status'].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      student['attending_status'] != 'p'
                                          ? Colors.red
                                          : Colors.greenAccent.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: attendanceSheet.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
