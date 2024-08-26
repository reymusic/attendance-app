import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  VoidCallback callback;
  String text;
  double radius;
  Color bgColor = Colors.grey.shade300;
  Color textColor;

  CancelButton(
      {required this.callback,
      this.text = "Cancel",
      this.radius = 10.0,
      Color? bgColor,
      this.textColor = Colors.black}) {
    this.bgColor = bgColor ?? this.bgColor;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius))),
    );
  }
}

Widget SaveButton({required VoidCallback callback}) {
  return CancelButton(
    callback: callback,
    text: "Save",
    textColor: Colors.white,
    bgColor: Colors.blue.shade700,
  );
}
