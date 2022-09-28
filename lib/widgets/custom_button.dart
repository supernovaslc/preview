import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  bool isLoading;

  CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      autofocus: true,
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Color.fromARGB(255, 241, 159, 37)),
        minimumSize: const Size(double.infinity, 54),
        primary: color,
        onPrimary: const Color.fromARGB(255, 244, 174, 54),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color != null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
