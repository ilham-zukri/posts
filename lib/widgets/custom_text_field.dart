import 'package:flutter/material.dart';

Widget customTextField({
  required String label,
  required TextEditingController controller,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller:  controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    ),
  );
}
