import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  MyTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            )
        ),
      ),
    );
  }
}
