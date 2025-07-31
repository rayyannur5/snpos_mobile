import 'package:flutter/material.dart';

class CircularSpinnerWithText extends StatelessWidget {
  final String text;

  const CircularSpinnerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 6,
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
