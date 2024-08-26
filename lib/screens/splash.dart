import 'dart:async';

import 'package:attendanceapp/screens/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      _opacity = 0.0;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        opacity: _opacity,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Student",
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 35,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: " Attendance",
                    style: TextStyle(
                        color: Colors.greenAccent.shade700,
                        fontSize: 35,
                        fontWeight: FontWeight.w600))
              ])),
              SizedBox(
                height: 200,
              ),
              Text(
                'V1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
              ),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
