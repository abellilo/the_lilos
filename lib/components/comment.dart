import 'package:flutter/material.dart';

class MyComment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  MyComment(
      {super.key, required this.user, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text),

          const SizedBox(height: 5,),

          //user, time
          Row(
            children: [
              Text(user, style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11
              ),),
              Text(" + ", style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11
              ),),
              Text(time,style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11
              ),)
            ],
          )
        ],
      ),
    );
  }
}
