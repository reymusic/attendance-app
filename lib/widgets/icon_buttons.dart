import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavIconButton extends StatelessWidget {
  String title;
  Widget next;
  Icon icon;

  NavIconButton({required this.title, required this.next, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => next));
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(height: 5,),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
