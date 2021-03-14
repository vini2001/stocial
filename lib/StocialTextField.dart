
import 'package:flutter/material.dart';

class StocialTextField extends StatelessWidget{

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String labelText;
  final bool? obscureText;
  final Function(String?)? onChanged;

  StocialTextField({this.controller, required this.labelText, this.keyboardType, this.obscureText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(style: BorderStyle.none)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(style: BorderStyle.none)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(style: BorderStyle.none)
          ),
          fillColor: Color(0x07000000),
        ),
      ),
    );
  }

}
