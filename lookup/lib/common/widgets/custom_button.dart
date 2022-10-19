import 'package:flutter/material.dart';
import 'package:lookup/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // VoidCallBack is one type of Function(). Here, text and onpress is written in constructor.
  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          primary: tabColor,
          minimumSize: const Size(double.infinity, 50), //double.infinity means cover whole width
        ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
        ),
    );
  }
}