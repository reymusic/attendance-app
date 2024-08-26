import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/widgets/button.dart';
import 'package:attendanceapp/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddStudentBottomSheet extends StatefulWidget {
  VoidCallback onClose;
  DBHelper DBRef;
  Map updateStudentData = {'update': false};

  AddStudentBottomSheet(
      {required this.DBRef, required this.onClose, Map? updateStudentData}) {
    this.updateStudentData = updateStudentData ?? this.updateStudentData;
  }

  @override
  State<AddStudentBottomSheet> createState() => _AddStudentBottomSheetState(
      onClose: onClose, DBRef: DBRef, updateStudentData: updateStudentData);
}

class _AddStudentBottomSheetState extends State<AddStudentBottomSheet> {
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var dateController = TextEditingController();
  var _errors = '';
  VoidCallback onClose;
  DBHelper DBRef;
  Map updateStudentData;
  int? rollno;

  _AddStudentBottomSheetState(
      {required this.DBRef,
      required this.onClose,
      required this.updateStudentData}) {
    if (this.updateStudentData['update'] == null) {
      nameController.text = updateStudentData['name'];
      surnameController.text = updateStudentData['surname'];
      dateController.text = updateStudentData['dob'];
      rollno = updateStudentData['roll_no'];
    }
  }

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
        onClose();
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("* Please fill all the required fields")));
      _errors = "* Please fill all the required fields";
      setState(() {});
    }
  }

  void updateStudent(context) async {
    if (nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        rollno != null) {
      var check = await DBRef!.updateStudent(
          name: nameController.text,
          surname: surnameController.text,
          dob: dateController.text,
          rollno: rollno);
      if (check) {
        closeSheet(context);
        onClose();
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("* Please fill all the required fields")));
      _errors = "* Please fill all the required fields";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "${rollno != null ? 'Update' : 'Add'} Student",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(controller: nameController, hintText: "Student Name"),
            SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: surnameController, hintText: "Student Surname"),
            SizedBox(
              height: 10,
            ),
            MyDateField(
              controller: dateController,
              hintText: "Date of Birth",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: SaveButton(
                          callback: () => rollno != null
                              ? updateStudent(context)
                              : saveStudent(context))),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                      child: CancelButton(callback: () => closeSheet(context)))
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              _errors,
              style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
