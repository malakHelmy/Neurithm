import 'package:flutter/material.dart';

InputDecoration customTextFieldDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Color.fromARGB(115, 255, 255, 255)),
    focusedBorder: const UnderlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
  );
}
