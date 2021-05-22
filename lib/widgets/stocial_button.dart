import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StocialButton extends StatelessWidget {

  StocialButton({required this.text, this.onPressed});
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

}