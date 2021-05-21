
import 'package:flutter/material.dart';

class StocialTextField extends StatelessWidget{

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String labelText;
  final bool? obscureText;
  final Function(String?)? onChanged;
  final Key? textFieldKey;
  final double borderRadius;

  StocialTextField({this.controller, required this.labelText, this.keyboardType, this.obscureText, this.onChanged, this.textFieldKey, this.borderRadius = 5});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 40,
      child: TextFormField(
        controller: controller,
        key: textFieldKey,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(style: BorderStyle.solid, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(style: BorderStyle.solid, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(style: BorderStyle.solid, width: 0.5),
          ),
          fillColor: Color(0x07000000),
        ),
      ),
    );
  }

}
