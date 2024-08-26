import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbInstance = DBHelper._();
  static final TABLE_STUDENT = 'student';
  static final TABLE_ATTENDANCE = 'attendance';
  static final TABLE_GROUP = 'student_group';

  Database? myDB;

  Future<Database> getDB() async {
    if (myDB == null) {
      myDB = await openDB();
    }
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'attendance.db');

    return openDatabase(dbPath, onCreate: (db, version) async {
      await db.execute("CREATE TABLE $TABLE_STUDENT("
          "roll_no INTEGER PRIMARY KEY autoincrement,"
          "name TEXT NOT NULL,"
          "surname TEXT,"
          "dob date);");

      await db.execute("CREATE TABLE $TABLE_GROUP("
          "g_no INTEGER PRIMARY KEY autoincrement,"
          "leader INTEGER NOT NULL,"
          "group_name TEXT NOT NULL,"
          "CONSTRAINT fk_leader_group FOREIGN KEY(leader)"
          "     REFERENCES $TABLE_STUDENT(roll_no));");

      await db.execute("CREATE TABLE $TABLE_ATTENDANCE("
          "roll_no INTEGER NOT NULL,"
          "status TEXT NOT NULL DEFAULT 'a',"
          "attending_date date,"
          "CONSTRAINT pk_attendance"
          "   PRIMARY KEY(roll_no, attending_date),"
          "CONSTRAINT fk_roll_no_attendance "
          "   FOREIGN KEY(roll_no)"
          "     REFERENCES $TABLE_STUDENT(roll_no));");
    }, version: 1);
  }

  Future<bool> addStudent(
      {required String name, String surname = "", required String dob}) async {
    var db = await getDB();
    int rowInsterted = await db
        .insert(TABLE_STUDENT, {'name': name, 'surname': surname, 'dob': dob});

    return rowInsterted > 0;
  }

  Future<List<Map<String, dynamic>>> getStudentAttendence(
      {required String date}) async {
    print(date);
    var db = await getDB();
    List<Map<String, dynamic>> studentAttendance =
        await db.rawQuery("SELECT s.roll_no, name, surname, status AS attending_status "
            "FROM $TABLE_STUDENT s JOIN $TABLE_ATTENDANCE a "
            "ON a.roll_no = s.roll_no "
            "   AND attending_date = '$date'");

    return studentAttendance;
  }

  Future<bool> markStudentAttendence(
      {required List<Map> attendance, required String date}) async {
    int marked = 0;
    var db = await getDB();

    try {
      await db.execute(
          "INSERT INTO $TABLE_ATTENDANCE (roll_no, status, attending_date)"
          " VALUES ${attendance.map(((data) => "(${data['roll_no']}, '${data['attending_status']}', '$date')")).toList().join(',')}");
    } catch (e) {
      print("Error: $e");
      return false;
    }
    return true;
  }

  Future<bool> correctStudentAttendence(
      {required List<Map> attendance, required String date}) async {
    int corrected = 0;
    var db = await getDB();

    try {
      attendance
          .forEach((data) async => await db.execute("UPDATE $TABLE_ATTENDANCE"
              " SET status = '${data['attending_status']}'"
              " WHERE roll_no = ${data['roll_no']} "
              "   AND attending_date = '$date';"));
    } catch (e) {
      print("Error: $e");
      return false;
    }
    return true;
  }

  Future<bool> updateStudent(
      {required String name,
      String surname = "",
      required String dob,
      rollno}) async {
    var db = await getDB();
    int rowInsterted = await db.update(
        TABLE_STUDENT, {'name': name, 'surname': surname, 'dob': dob},
        where: 'roll_no = $rollno');

    return rowInsterted > 0;
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    var db = await getDB();
    var students = db.rawQuery("select * from $TABLE_STUDENT");
    return students;
  }
}
