import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[500],
                  ))
            ],
          ),

          //text
          Text(text)
        ],
      ),
    );
  }
}
