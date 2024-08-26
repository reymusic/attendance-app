import 'package:attendanceapp/database/db.dart';
import 'package:attendanceapp/screens/attendance.dart';
import 'package:attendanceapp/screens/student.dart';
import 'package:attendanceapp/widgets/icon_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? DBRef;

  @override
  void initState() {
    super.initState();
    DBRef = DBHelper.dbInstance;
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
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.black12,
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 2),
                  children: [
                    NavIconButton(
                        title: "Students",
                        next: StudentScreen(),
                        icon: Icon(
                          Icons.school,
                          color: Colors.blue.shade600,
                          size: 24,
                        )),
                    NavIconButton(
                        title: "Groups",
                        next: AttendanceScreen(),
                        icon: Icon(
                          Icons.group,
                          color: Colors.blue.shade600,
                          size: 24,
                        )),
                    NavIconButton(
                        title: "Attendance",
                        next: AttendanceScreen(),
                        icon: Icon(
                          Icons.contacts_outlined,
                          color: Colors.blue.shade600,
                          size: 24,
                        )),
                    NavIconButton(
                        title: "Export",
                        next: AttendanceScreen(),
                        icon: Icon(
                          CupertinoIcons.share_solid,
                          color: Colors.blue.shade600,
                          size: 24,
                        )),
                  ],
                ),
              )
            ])));
  }
}
