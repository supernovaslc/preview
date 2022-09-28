import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool isPass;
  final TextInputType textInputType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.isPass = false,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black38,
      ),
    );

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}
