import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  SnackBar buildSnackBar(String message, {int seconds = 2, String? label, Function? onClose}) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
      action: label == null ? null : SnackBarAction(
        label: label,
        onPressed: () {  onClose!(); },
      ),
    );
  }

  void showSnackBarMessage(String message, {int seconds = 2, String? label, Function? onClose}) {
    ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(message, seconds: seconds, label: label, onClose: onClose));
  }

  void pop([Object? response]) {
    print(response);
    Navigator.of(context).pop(response);
  }

}