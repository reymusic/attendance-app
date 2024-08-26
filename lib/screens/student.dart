import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/widgets/add_student.dart';
import 'package:attendanceapp/widgets/button.dart';
import 'package:attendanceapp/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentScreen extends StatefulWidget {
  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Map<String, dynamic>> students = [];
  DBHelper? DBRef;

  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var dateController = TextEditingController();
  var _errors = '';

  void closeSheet(context) {
    nameController.clear();
    dateController.clear();
    surnameController.clear();

    Navigator.pop(context);
    _errors = "";
  }

  void saveStudent(context) async {
    if (nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      var check = await DBRef!.addStudent(
          name: nameController.text,
          surname: surnameController.text,
          dob: dateController.text);
      if (check) {
        closeSheet(context);
        getStudent();
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("* Please fill all the required fields")));
      _errors = "* Please fill all the required fields";
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    DBRef = DBHelper.dbInstance;
    getStudent();
  }

  void getStudent() async {
    students = await DBRef!.getStudents();
    setState(() {});
  }

  String capitalize(String data) {
    return '${data[0].toUpperCase()}${data.substring(
      1,
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance App",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView(
            children: students.map((student) {
          print(student);
          return InkWell(
            onTap: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => AddStudentBottomSheet(
                      DBRef: DBRef!, onClose: getStudent, updateStudentData: student));
            },
            child: Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.white),
              child: ListTile(
                trailing: Text('0187AS2210${student['roll_no']}',
                    style: TextStyle(fontSize: 18)),
                title: Text(
                  "${capitalize(student['name'])} ${capitalize(student['surname'])}",
                  style: TextStyle(fontSize: 18),
                ),
                // : Text(student['surname']),
                // trailing: Text(student['roll_no'].toString()),
              ),
            ),
          );
        }).toList()),
      ),
      floatingActionButton: IconButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) =>
                  AddStudentBottomSheet(DBRef: DBRef!, onClose: getStudent));
        },
        icon: Icon(
          CupertinoIcons.plus,
          color: Colors.white,
          size: 35,
          weight: 1.2,
        ),
        style: IconButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(icon: Icon(Icons.home_filled)),
      //   BottomNavigationBarItem(icon: Icon(Icons.add_box))
      // ]),
    );
  }
}
