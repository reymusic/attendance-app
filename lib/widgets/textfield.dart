import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextInputType keyboardType;
  VoidCallback onTapAction = () {};

  MyTextField(
      {required TextEditingController this.controller,
      required String this.hintText,
      TextInputType this.keyboardType = TextInputType.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade600, width: 1.4),
              borderRadius: BorderRadius.circular(11)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 1.4),
              borderRadius: BorderRadius.circular(11)),
          hintText: hintText,
        ),
      ),
    );
  }
}

class MyDateField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  bool current;

  MyDateField(
      {required TextEditingController this.controller,
      required String this.hintText,
      this.current = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.none,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade600, width: 1.4),
              borderRadius: BorderRadius.circular(11)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 1.4),
              borderRadius: BorderRadius.circular(11)),
          hintText: hintText,
        ),
        canRequestFocus: false,
        onTap: () async {
          DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime(1980),
              lastDate:
                  current ? DateTime.now() : DateTime(DateTime.now().year - 3));

          controller.text = DateFormat('dd/MM/yy').format(date!);
        },
      ),
    );
  }
}

class MyAdjustableDateField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  bool current;
  DateTime? _date = DateTime.now();

  MyAdjustableDateField(
      {required TextEditingController this.controller,
      required String this.hintText,
      this.current = false});

  void fomattingDate(DateTime newdate) {
    controller.text = DateFormat('dd/MM/yy').format(newdate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.none,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade600, width: 1.4),
                borderRadius: BorderRadius.circular(11)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade600, width: 1.4),
                borderRadius: BorderRadius.circular(11)),
            hintText: hintText,
            label: Text(
              'Date',
              style: TextStyle(
                  color: Colors.blue.shade700, fontWeight: FontWeight.w500),
            ),
            prefixIcon: IconButton(
                onPressed: () {
                  print(_date);
                  _date = _date!.subtract(Duration(days: 1));
                  fomattingDate(_date!);
                },
                icon: Icon(
                  CupertinoIcons.arrow_down,
                  color: Colors.black,
                  size: 24,
                )),
            contentPadding: EdgeInsets.all(4.0),
            suffixIcon: IconButton(
                onPressed: () {
                  if (_date!.add(Duration(days: 1)).compareTo(DateTime.now()) <=
                      0) _date = _date!.add(Duration(days: 1));
                  print(_date);
                  fomattingDate(_date!);
                },
                icon: Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.black,
                  size: 24,
                ))),
        canRequestFocus: false,
        onTap: () async {
          _date = await showDatePicker(
              context: context,
              firstDate: DateTime(1980),
              lastDate: DateTime.now());

          _date = _date ?? DateTime.now();
          fomattingDate(_date!);
        },
      ),
    );
  }
}
